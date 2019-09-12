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

      expect(reek).to receive(:run!) do |_files, config_files|
        expect(config_files).to eq(["lib/config/*.reek"])
      end.and_return("")

      reek.emit
    end

    it "passes an empty array when no config file pattern is specified" do
      expect(reek).to receive(:run!) do |_files, config_files|
        expect(config_files).to eq([])
      end.and_return("")

      reek.emit
    end

    it "includes files to analyze into reek parameters" do
      expect(reek).to receive(:run!) do |files, _config_files|
        expect(files).to eq(["lib/foo.rb", "lib/bar.rb"])
      end.and_return("")

      reek.emit
    end
  end

  describe "analyze method" do
    before :each do
      MetricFu::Configuration.run {}
      allow(File).to receive(:directory?).and_return(true)
      @generator = MetricFu::ReekGenerator.new
      @examiner = @generator.send(:examiner)
      @smell_warning = Reek.const_defined?(:SmellWarning) ? Reek.const_get(:SmellWarning) : Reek.const_get(:Smells).const_get(:SmellWarning)
      if @smell_warning.instance_methods.include?(:subclass)
        @smell_warning.send(:alias_method, :smell_type, :subclass)
      end
    end

    context "with reek warnings" do
      before :each do
        @smells = [
            instance_double(@smell_warning,
                            source: "app/controllers/activity_reports_controller.rb",
                            context: "ActivityReportsController#authorize_user",
                            message: "calls current_user.primary_site_ids multiple times",
                            smell_type: "Duplication",
                            lines: [2, 4]),
            instance_double(@smell_warning,
                            source: "app/controllers/activity_reports_controller.rb",
                            context: "ActivityReportsController#authorize_user",
                            message: "calls params[id] multiple times",
                            smell_type: "Duplication",
                            lines: [5, 7]),
            instance_double(@smell_warning,
                            source: "app/controllers/activity_reports_controller.rb",
                            context: "ActivityReportsController#authorize_user",
                            message: "calls params[primary_site_id] multiple times",
                            smell_type: "Duplication",
                            lines: [11, 15]),
            instance_double(@smell_warning,
                            source: "app/controllers/activity_reports_controller.rb",
                            context: "ActivityReportsController#authorize_user",
                            message: "has approx 6 statements",
                            smell_type: "Long Method",
                            lines: [8]),

            instance_double(@smell_warning,
                            source: "app/controllers/application.rb",
                            context: "ApplicationController#start_background_task/block/block",
                            message: "is nested",
                            smell_type: "Nested Iterators",
                            lines: [23]),

            instance_double(@smell_warning,
                            source: "app/controllers/link_targets_controller.rb",
                            context: "LinkTargetsController#authorize_user",
                            message: "calls current_user.role multiple times",
                            smell_type: "Duplication",
                            lines: [8]),

            instance_double(@smell_warning,
                            source: "app/controllers/newline_controller.rb",
                            context: "NewlineController#some_method",
                            message: "calls current_user.<< \"new line\n\" multiple times",
                            smell_type: "Duplication",
                            lines: [6, 9])
        ]
        @examiners = [
          instance_double(Reek::Examiner, smells: @smells)
        ]
        @generator.instance_variable_set(:@output, @examiners)
        @matches = @generator.analyze
      end

      it "should find the code smell's line numbers" do
        smell = @matches.first[:code_smells].first
        expect(smell[:lines]).to eq([2, 4])
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

    context "with reek 1.3 output" do
      before :each do
        @smells = [
            double(source: "app/controllers/activity_reports_controller.rb",
                   context: "ActivityReportsController#authorize_user",
                   message: "calls current_user.primary_site_ids multiple times",
                   subclass: "Duplication",
                   lines: [2, 4]),
        ]
        @examiners = [
          instance_double(Reek::Examiner, smells: @smells)
        ]
        @generator.instance_variable_set(:@output, @examiners)
        @matches = @generator.analyze
      end

      it "uses the subclass field to find the smell type" do
        smell = @matches.first[:code_smells].first
        expect(smell[:type]).to eq('Duplication')
      end
    end

    context "with real output, not mocked nor doubled" do
      let(:result) do
        {:file_path=>"spec/support/samples/alfa.rb", :code_smells=>[{:method=>"Alfa", :message=>"takes parameters ['echo', 'foxtrot', 'golf'] to 3 methods", :type=>"DataClump", :lines=>[2, 3, 4]}, {:method=>"Alfa", :message=>"has no descriptive comment", :type=>"IrresponsibleModule", :lines=>[1]}, {:method=>"Alfa#bravo", :message=>"has unused parameter 'echo'", :type=>"UnusedParameters", :lines=>[2]}, {:method=>"Alfa#bravo", :message=>"has unused parameter 'foxtrot'", :type=>"UnusedParameters", :lines=>[2]}, {:method=>"Alfa#bravo", :message=>"has unused parameter 'golf'", :type=>"UnusedParameters", :lines=>[2]}, {:method=>"Alfa#charlie", :message=>"has unused parameter 'echo'", :type=>"UnusedParameters", :lines=>[3]}, {:method=>"Alfa#charlie", :message=>"has unused parameter 'foxtrot'", :type=>"UnusedParameters", :lines=>[3]}, {:method=>"Alfa#charlie", :message=>"has unused parameter 'golf'", :type=>"UnusedParameters", :lines=>[3]}, {:method=>"Alfa#delta", :message=>"has unused parameter 'echo'", :type=>"UnusedParameters", :lines=>[4]}, {:method=>"Alfa#delta", :message=>"has unused parameter 'foxtrot'", :type=>"UnusedParameters", :lines=>[4]}, {:method=>"Alfa#delta", :message=>"has unused parameter 'golf'", :type=>"UnusedParameters", :lines=>[4]}]}
      end
      before do
        @generator = MetricFu::ReekGenerator.new(dirs_to_reek: ["spec/support/samples"])
        @generator.emit
      end

      it "returns real data" do
        @matches = @generator.analyze

        expect(@matches.first).to eq(result)
      end
    end

    context "without reek warnings" do
      before :each do
        @examiners = [
          instance_double(Reek::Examiner, smells: [])
        ]
        @generator.instance_variable_set(:@output, @examiners)
        @matches = @generator.analyze
      end

      it "returns empty analysis" do
        expect(@matches).to eq([])
      end
    end
  end
end
