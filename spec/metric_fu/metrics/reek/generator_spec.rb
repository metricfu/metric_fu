require "spec_helper"
MetricFu.metrics_require { "reek/generator" }

describe MetricFu::ReekGenerator do
  describe "emit" do
    let(:options) { { dirs_to_reek: [] } }
    let(:files_to_analyze) { ["lib/foo.rb", "lib/bar.rb"] }
    let(:reek) { MetricFu::ReekGenerator.new(options) }

    before :each do
      allow(reek).to receive(:files_to_analyze).and_return(files_to_analyze)
    end

    it "includes config file pattern into reek parameters when specified" do
      options.merge!(config_file_pattern: "lib/config/*.reek")
      expect(reek).to receive(:run!) do |args|
        expect(args).to include("--config", "lib/config/*.reek")
      end.and_return("")
      reek.emit
    end

    it "doesn't add an empty parameter when no config file pattern is specified" do
      expect(reek).to receive(:run!) do |args|
        expect(args).not_to include("")
      end.and_return("")
      reek.emit
    end

    it "turns off color output from reek output, for reek 1.3.7 or greater" do
      allow(reek).to receive(:reek_version).and_return("1.3.7")
      expect(reek).to receive(:run!) do |args|
        expect(args).to include("--no-color")
      end.and_return("")
      reek.emit
    end

    it "does not set an (invalid) --no-color option for reek < 1.3.7" do
      allow(reek).to receive(:reek_version).and_return("1.3.6")
      expect(reek).to receive(:run!) do |args|
        expect(args).not_to include("--no-color")
      end.and_return("")
      reek.emit
    end

    it "includes files to analyze into reek parameters" do
      expect(reek).to receive(:run!) do |args|
        expect(args).to include("lib/foo.rb", "lib/bar.rb")
      end.and_return("")
      reek.emit
    end
  end

  # TODO review tested output
  describe "analyze method" do
    before :each do
      MetricFu::Configuration.run {}
      allow(File).to receive(:directory?).and_return(true)
      @reek = MetricFu::ReekGenerator.new
    end

    context "with reek warnings" do
      before :each do
        @lines = <<-HERE
"app/controllers/activity_reports_controller.rb" -- 4 warnings:
  [2, 4]:ActivityReportsController#authorize_user calls current_user.primary_site_ids multiple times (Duplication)
  [5, 7]:ActivityReportsController#authorize_user calls params[id] multiple times (Duplication)
  [11, 15]:ActivityReportsController#authorize_user calls params[primary_site_id] multiple times (Duplication)
  [8]:ActivityReportsController#authorize_user has approx 6 statements (Long Method)

"app/controllers/application.rb" -- 1 warnings:
  [23]:ApplicationController#start_background_task/block/block is nested (Nested Iterators)

"app/controllers/link_targets_controller.rb" -- 1 warnings:
  [5, 21]:LinkTargetsController#authorize_user calls current_user.role multiple times (Duplication)

"app/controllers/newline_controller.rb" -- 1 warnings:
  [6, 9]:NewlineController#some_method calls current_user.<< "new line\n" multiple times (Duplication)
      HERE
        @reek.instance_variable_set(:@output, @lines)
        @matches = @reek.analyze
      end

      it "should find the code smell's method name" do
        smell = @matches.first[:code_smells].first
        expect(smell[:method]).to eq("ActivityReportsController#authorize_user")
      end

      it "should find the code smell's type" do
        smell = @matches[1][:code_smells].first
        expect(smell[:type]).to eq("Nested Iterators")
      end

      it "should find the code smell's message" do
        smell = @matches[1][:code_smells].first
        expect(smell[:message]).to eq("is nested")
      end

      it "should find the code smell's type" do
        smell = @matches.first
        expect(smell[:file_path]).to eq("app/controllers/activity_reports_controller.rb")
      end

      it "should NOT insert nil smells into the array when there's a newline in the method call" do
        expect(@matches.last[:code_smells]).to eq(@matches.last[:code_smells].compact)
      end
    end

    context "without reek warnings" do
      before :each do
        @lines = <<-HERE

0 total warnings
      HERE
        @reek.instance_variable_set(:@output, @lines)
        @matches = @reek.analyze
      end

      it "returns empty analysis" do
        expect(@matches).to eq({})
      end
    end
  end
end

describe MetricFu::ReekGenerator do
  before :each do
    MetricFu::Configuration.run {}
    @reek = MetricFu::ReekGenerator.new
    @lines11 = <<-HERE
"app/controllers/activity_reports_controller.rb" -- 4 warnings:
ActivityReportsController#authorize_user calls current_user.primary_site_ids multiple times (Duplication)
ActivityReportsController#authorize_user calls params[id] multiple times (Duplication)
ActivityReportsController#authorize_user calls params[primary_site_id] multiple times (Duplication)
ActivityReportsController#authorize_user has approx 6 statements (Long Method)

"app/controllers/application.rb" -- 1 warnings:
ApplicationController#start_background_task/block/block is nested (Nested Iterators)

"app/controllers/link_targets_controller.rb" -- 1 warnings:
LinkTargetsController#authorize_user calls current_user.role multiple times (Duplication)

"app/controllers/newline_controller.rb" -- 1 warnings:
NewlineController#some_method calls current_user.<< "new line\n" multiple times (Duplication)
      HERE
    @lines12 = <<-HERE
app/controllers/activity_reports_controller.rb -- 4 warnings (+3 masked):
  ActivityReportsController#authorize_user calls current_user.primary_site_ids multiple times (Duplication)
  ActivityReportsController#authorize_user calls params[id] multiple times (Duplication)
  ActivityReportsController#authorize_user calls params[primary_site_id] multiple times (Duplication)
  ActivityReportsController#authorize_user has approx 6 statements (Long Method)
app/controllers/application.rb -- 1 warnings:
  ApplicationController#start_background_task/block/block is nested (Nested Iterators)
app/controllers/link_targets_controller.rb -- 1 warnings (+1 masked):
  LinkTargetsController#authorize_user calls current_user.role multiple times (Duplication)
app/controllers/newline_controller.rb -- 1 warnings:
  NewlineController#some_method calls current_user.<< "new line\n" multiple times (Duplication)
      HERE
  end

  context "with Reek 1.1 output format" do
    it "reports 1.1 style when the output is empty" do
      @reek.instance_variable_set(:@output, "")
      expect(@reek).not_to be_reek_12
    end
    it "detects 1.1 format output" do
      @reek.instance_variable_set(:@output, @lines11)
      expect(@reek).not_to be_reek_12
    end

    it "massages empty output to be unchanged" do
      @reek.instance_variable_set(:@output, "")
      expect(@reek.massage_for_reek_12).to be_empty
    end
  end

  context "with Reek 1.2 output format" do
    it "detects 1.2 format output" do
      @reek.instance_variable_set(:@output, @lines12)
      expect(@reek).to be_reek_12
    end

    it "correctly massages 1.2 output" do
      @reek.instance_variable_set(:@output, @lines12)
      expect(@reek.massage_for_reek_12).to eq(@lines11)
    end
  end
end
