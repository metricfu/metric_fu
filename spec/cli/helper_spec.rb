require 'spec_helper'
require 'metric_fu/cli/helper'
MetricFu.run_rcov
MetricFu.reconfigure

describe MetricFu::Cli::Helper do

  describe "defaults" do

    let(:helper)  { MetricFu::Cli::Helper.new }
    let(:defaults) { helper.process_options }

    context "on every Ruby version" do

      it "opens the report in a browser" do
        defaults[:open].should be_true
      end

      it "enables Flay" do
        defaults[:flay].should be_true
      end

      it "enables Reek" do
        defaults[:reek].should be_true
      end

      it "enables Hotspots" do
        defaults[:hotspots].should be_true
      end

      it "enables Churn" do
        defaults[:churn].should be_true
      end

      it "enables Saikuro" do
        defaults[:saikuro].should be_true
      end

      if MetricFu.configuration.mri?
        it "enables Flog" do
          !defaults[:flog].should be_true
        end

        it "enables Cane" do
          defaults[:cane].should be_true
        end
      end

      it "enables RCov" do
        defaults[:rcov].should be_true
      end

      it "runs by default" do
        defaults[:run].should be_true
      end
    end

    if MetricFu.configuration.mri?

        it "enables Rails Best Practices" do
          defaults[:rails_best_practices].should be_true
        end

    end

  end

  describe ".parse" do
    let(:helper)  { MetricFu::Cli::Helper.new }

    it "turns open in browser off" do
      helper.process_options(["--no-open"])[:open].should be_false
    end

    it "turns open in browser on" do
      helper.process_options(["--open"])[:open].should be_true
    end

    it "turns saikuro off" do
      helper.process_options(["--no-saikuro"])[:saikuro].should be_false
    end

    it "turns saikuro on" do
      helper.process_options(["--saikuro"])[:saikuro].should be_true
    end

    it "turns churn off" do
      helper.process_options(["--no-churn"])[:churn].should be_false
    end

    it "turns churn on" do
      helper.process_options(["--churn"])[:churn].should be_true
    end

    it "turns flay off" do
      helper.process_options(["--no-flay"])[:flay].should be_false
    end

    it "turns flay on" do
      helper.process_options(["--flay"])[:flay].should be_true
    end

    if MetricFu.configuration.mri?

      it "turns flog off" do
        helper.process_options(["--no-flog"])[:flog].should be_false
      end

      it "turns flog on" do
        helper.process_options(["--flog"])[:flog].should be_true
      end

      it "turns cane off" do
        helper.process_options(["--no-cane"])[:cane].should be_false
      end

      it "turns cane on" do
        helper.process_options(["--cane"])[:cane].should be_true
      end

    end


    it "turns hotspots off" do
      helper.process_options(["--no-hotspots"])[:hotspots].should be_false
    end

    it "turns hotspots on" do
      helper.process_options(["--hotspots"])[:hotspots].should be_true
    end

    it "turns rcov off" do
      helper.process_options(["--no-rcov"])[:rcov].should be_false
    end

    it "turns rcov on" do
      helper.process_options(["--rcov"])[:rcov].should be_true
    end

    it "turns reek off" do
      helper.process_options(["--no-reek"])[:reek].should be_false
    end

    it "turns reek on" do
      helper.process_options(["--reek"])[:reek].should be_true
    end

    it "turns roodi off" do
      helper.process_options(["--no-roodi"])[:roodi].should be_false
    end

    it "turns roodi on" do
      helper.process_options(["--roodi"])[:roodi].should be_true
    end

    context 'given a single format' do
      it "sets the format" do
        helper.process_options(["--format", "json"])[:format].should eq([['json']])
      end
    end

    context 'given multiple formats' do
      it "sets multiple formats" do
        helper.process_options(["--format", "json", "--format", "yaml"])[:format].should eq([['json'], ['yaml']])
      end
    end

  end

end
