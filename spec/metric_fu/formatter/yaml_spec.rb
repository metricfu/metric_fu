require "spec_helper"

describe MetricFu::Formatter::YAML do

  before do
    setup_fs

    @metric1 = MetricFu.configuration.mri? ? :cane : :flay
    @metric2 = :hotspots
    MetricFu.result.add(@metric1)
    MetricFu.result.add(@metric2)
  end

  context "In general" do

    it "creates a report yaml file" do
      expect {
      MetricFu::Formatter::YAML.new.finish
      }.to create_file("#{directory('base_directory')}/report.yml")
    end

  end

  context "given a custom output file" do

    before do
      @output = "customreport.yml"
    end

    it "creates a report yaml file to the custom output path" do
      expect {
      MetricFu::Formatter::YAML.new(output: @output).finish
      }.to create_file("#{directory('base_directory')}/customreport.yml")
    end

  end

  context "given a custom output stream" do

    before do
      @output = $stdout
    end

    it "creates a report yaml in the custom stream" do
      out = MfDebugger::Logger.capture_output {
        MetricFu::Formatter::YAML.new(output: @output).finish
      }
      out.should include ":#{@metric1}:"
      out.should include ":#{@metric2}:"
    end

  end

  after do
    cleanup_fs
  end

end
