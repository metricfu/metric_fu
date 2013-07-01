require 'spec_helper'
require 'metric_fu/cli/client'

describe MetricFu do

  let(:helper)  { MetricFu::Cli::Helper.new }

  before(:all) do
    MetricFu::Configuration.run {|config| config.graph_engine = :bluff}
  end

  context "given configured metrics, when run" do
    before do
      # By configuring with a limited set, we can
      # test the basic functionality without significantly
      # slowing down the specs.
      MetricFu::Configuration.run do |config|
        @default_configured_metrics = config.metrics.dup
        config.metrics = [:cane, :churn]
      end
    end

    it "loads the .metrics file" do
      # Global only for testing that this file gets loaded
      $metric_file_loaded = false
      out = metric_fu
      $metric_file_loaded.should be_true
    end

    it "creates a report yaml file" do
      expect { metric_fu }.to create_file("tmp/metric_fu/report.yml")
    end

    it "creates a report html file" do
      expect { metric_fu }.to create_file("tmp/metric_fu/output/index.html")
    end

    after do
      MetricFu::Configuration.run do |config|
        config.metrics = @default_configured_metrics
      end
    end
  end

  context "given other options" do

    it "displays help" do
      out = metric_fu "--help"
      out.should include helper.banner
    end

    it "displays version" do
      out = metric_fu "--version"
      out.should include "#{MetricFu::VERSION}"
    end

    it "errors on unknown flags" do
      out = metric_fu "--asdasdasda"
      out.should include 'invalid option'
    end

  end

  after do
    FileUtils.rm_rf("#{MetricFu.base_directory}/report.yml")
    FileUtils.rm_rf("#{MetricFu.output_directory}/index.html")
  end

  def metric_fu(options = "--no-open")
    MfDebugger::Logger.capture_output {
      begin
        argv = Shellwords.shellwords(options)
        MetricFu::Cli::Client.new.run(argv)
      rescue SystemExit
        # Catch system exit so that it doesn't halt spec.
      end
    }
  end

end
