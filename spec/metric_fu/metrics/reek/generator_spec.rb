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
end
