require "spec_helper"
require "metric_fu/cli/helper"
MetricFu.configuration.configure_metric(:rcov) do |rcov|
  rcov.enabled = true
end
MetricFu.configure

describe MetricFu::Cli::Helper do
  describe "defaults" do
    let(:helper)  { MetricFu::Cli::Helper.new }
    let(:defaults) { helper.process_options }

    context "on every Ruby version" do
      it "opens the report in a browser" do
        expect(defaults[:open]).to be_truthy
      end

      it "enables Flay" do
        expect(defaults[:flay]).to be_truthy
      end

      it "enables Reek" do
        expect(defaults[:reek]).to be_truthy
      end

      it "enables Hotspots" do
        expect(defaults[:hotspots]).to be_truthy
      end

      it "enables Churn" do
        expect(defaults[:churn]).to be_truthy
      end

      it "enables Saikuro" do
        expect(defaults[:saikuro]).to be_truthy
      end

      if MetricFu.configuration.mri?
        it "enables Flog" do
          !expect(defaults[:flog]).to be_truthy
        end

        it "enables Cane" do
          expect(defaults[:cane]).to be_truthy
        end
      end

      it "enables RCov" do
        expect(defaults[:rcov]).to be_truthy
      end

      it "runs by default" do
        expect(defaults[:run]).to be_truthy
      end
    end

    if MetricFu.configuration.mri?

      it "enables Rails Best Practices" do
        expect(defaults[:rails_best_practices]).to be_truthy
      end

    end
  end

  describe ".parse" do
    let(:helper)  { MetricFu::Cli::Helper.new }

    it "turns open in browser off" do
      expect(helper.process_options(["--no-open"])[:open]).to be_falsey
    end

    it "turns open in browser on" do
      expect(helper.process_options(["--open"])[:open]).to be_truthy
    end

    it "turns saikuro off" do
      expect(helper.process_options(["--no-saikuro"])[:saikuro]).to be_falsey
    end

    it "turns saikuro on" do
      expect(helper.process_options(["--saikuro"])[:saikuro]).to be_truthy
    end

    it "turns churn off" do
      expect(helper.process_options(["--no-churn"])[:churn]).to be_falsey
    end

    it "turns churn on" do
      expect(helper.process_options(["--churn"])[:churn]).to be_truthy
    end

    it "turns flay off" do
      expect(helper.process_options(["--no-flay"])[:flay]).to be_falsey
    end

    it "turns flay on" do
      expect(helper.process_options(["--flay"])[:flay]).to be_truthy
    end

    if MetricFu.configuration.mri?

      it "turns flog off" do
        expect(helper.process_options(["--no-flog"])[:flog]).to be_falsey
      end

      it "turns flog on" do
        expect(helper.process_options(["--flog"])[:flog]).to be_truthy
      end

      it "turns cane off" do
        expect(helper.process_options(["--no-cane"])[:cane]).to be_falsey
      end

      it "turns cane on" do
        expect(helper.process_options(["--cane"])[:cane]).to be_truthy
      end

    end

    it "turns hotspots off" do
      expect(helper.process_options(["--no-hotspots"])[:hotspots]).to be_falsey
    end

    it "turns hotspots on" do
      expect(helper.process_options(["--hotspots"])[:hotspots]).to be_truthy
    end

    it "turns rcov off" do
      expect(helper.process_options(["--no-rcov"])[:rcov]).to be_falsey
    end

    it "turns rcov on" do
      expect(helper.process_options(["--rcov"])[:rcov]).to be_truthy
    end

    it "turns reek off" do
      expect(helper.process_options(["--no-reek"])[:reek]).to be_falsey
    end

    it "turns reek on" do
      expect(helper.process_options(["--reek"])[:reek]).to be_truthy
    end

    it "turns roodi off" do
      expect(helper.process_options(["--no-roodi"])[:roodi]).to be_falsey
    end

    it "turns roodi on" do
      expect(helper.process_options(["--roodi"])[:roodi]).to be_truthy
    end

    context "given a single format" do
      it "sets the format" do
        expect(helper.process_options(["--format", "json"])[:format]).to eq([["json"]])
      end
    end

    context "given multiple formats" do
      it "sets multiple formats" do
        expect(helper.process_options(["--format", "json", "--format", "yaml"])[:format]).to eq([["json"], ["yaml"]])
      end
    end
  end
end
