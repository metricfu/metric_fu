require "spec_helper"
MetricFu.formatter_require { "yaml" }

describe MetricFu::Formatter::YAML do
  before do
    setup_fs

    config = MetricFu.configuration

    if config.mri?
      @metric1 = :cane
    else
      @metric1 = :stats
      config.templates_configuration do |c|
        c.syntax_highlighting = false
      end
    end
    allow(MetricFu::Metric.get_metric(@metric1)).to receive(:run_external).and_return("")
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
      out = MetricFu::Utility.capture_output {
        MetricFu::Formatter::YAML.new(output: @output).finish
      }
      expect(out).to include ":#{@metric1}:"
      expect(out).to include ":#{@metric2}:"
    end
  end

  after do
    cleanup_fs
  end
end
