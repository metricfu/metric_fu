require 'spec_helper'
require 'metric_fu/cli/client'

describe MetricFu do
  let(:helper)  { MetricFu::Cli::Helper.new }

  before(:all) do
    MetricFu.configuration.configure_graph_engine(:bluff)
  end

  before do
    setup_fs
  end

  def base_directory
    directory('base_directory')
  end

  def output_directory
    directory('output_directory')
  end

  def data_directory
    directory('data_directory')
  end

  context "given configured metrics, when run" do

    before do

      # TODO: Should probably use some sort of fake metric
      # to speed up tests. For now, just configuring with a
      # limited set, so we can test the basic functionality
      # without significantly slowing down the specs.
      MetricFu.configuration.configure_metrics do |metric|
        if metric.name == :churn
          metric.enable
          metric.activated = true
        else
          metric.enabled = false
        end
      end

    end

    it "loads the .metrics file" do
      # Global only for testing that this file gets loaded
      $metric_file_loaded = false
      metric_fu
      $metric_file_loaded.should be_true
    end

    it "creates a report yaml file" do
      expect { metric_fu }.to create_file("#{base_directory}/report.yml")
    end

    it "creates a data yaml file" do
      expect { metric_fu }.to create_file("#{data_directory}/#{Time.now.strftime("%Y%m%d")}.yml")
    end

    it "creates a report html file" do
      expect { metric_fu }.to create_file("#{output_directory}/index.html")
    end

    context "with configured formatter" do
      it "outputs using configured formatter" do
        expect {
          MetricFu::Configuration.run do |config|
            config.configure_formatter(:yaml)
          end
          metric_fu
        }.to create_file("#{base_directory}/report.yml")
      end

      it "doesn't output using formatters not configured" do
        expect {
          MetricFu::Configuration.run do |config|
            config.configure_formatter(:yaml)
          end
          metric_fu
        }.to_not create_file("#{output_directory}/index.html")
      end

    end

    context "with command line formatter" do
      it "outputs using command line formatter" do
        expect { metric_fu "--format yaml"}.to create_file("#{base_directory}/report.yml")
      end

      it "doesn't output using formatters not configured" do
        expect { metric_fu "--format yaml"}.to_not create_file("#{output_directory}/index.html")
      end

    end

    context "with configured and command line formatter" do

      before do
        MetricFu::Configuration.run do |config|
          config.configure_formatter(:html)
        end
      end

      it "outputs using command line formatter" do
        expect { metric_fu "--format yaml"}.to create_file("#{base_directory}/report.yml")
      end

      it "doesn't output using configured formatter (cli takes precedence)" do
        expect { metric_fu "--format yaml"}.to_not create_file("#{output_directory}/index.html")
      end

    end

    context "with configured specified out" do
      it "outputs using configured out" do
        expect {
          MetricFu::Configuration.run do |config|
            config.configure_formatter(:yaml, "customreport.yml")
          end
          metric_fu
        }.to create_file("#{base_directory}/customreport.yml")
      end

      it "doesn't output using formatters not configured" do
        expect {
          MetricFu::Configuration.run do |config|
            config.configure_formatter(:yaml, "customreport.yml")
          end
          metric_fu
        }.to_not create_file("#{base_directory}/report.yml")
      end

    end

    context "with command line specified formatter + out" do
      it "outputs to the specified path" do
        expect { metric_fu "--format yaml --out customreport.yml"}.to create_file("#{base_directory}/customreport.yml")
      end

      it "doesn't output to default path" do
        expect { metric_fu "--format yaml --out customreport.yml"}.to_not create_file("#{base_directory}/report.yml")
      end

    end

    context "with command line specified out only" do
      it "outputs to the specified path" do
        expect { metric_fu "--out customdir --no-open"}.to create_file("#{base_directory}/customdir/index.html")
      end

      it "doesn't output to default path" do
        expect { metric_fu "--out customdir --no-open"}.to_not create_file("#{output_directory}/index.html")
      end

    end


    after do
      MetricFu::Configuration.run do |config|
        config.formatters.clear
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
    cleanup_fs
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
