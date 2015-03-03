require "spec_helper"
MetricFu.metrics_require { "churn/generator" }

describe MetricFu::ChurnGenerator do
  # TODO extract yaml
  let(:churn_hash) { YAML::load("--- \n:churn: \n  :changed_files: \n  - spec/graphs/flog_grapher_spec.rb\n  - spec/base/graph_spec.rb\n  - lib/templates/awesome/layout.html.erb\n  - lib/graphs/rcov_grapher.rb\n  - lib/base/base_template.rb\n  - spec/graphs/grapher_spec.rb\n  - lib/templates/awesome/flog.html.erb\n  - lib/templates/awesome/flay.html.erb\n  - lib/graphs/roodi_grapher.rb\n  - lib/graphs/reek_grapher.rb\n  - HISTORY\n  - spec/graphs/roodi_grapher_spec.rb\n  - lib/generators/rcov.rb\n  - spec/graphs/engines/gchart_spec.rb\n  - spec/graphs/rcov_grapher_spec.rb\n  - lib/templates/javascripts/excanvas.js\n  - lib/templates/javascripts/bluff-min.js\n  - spec/graphs/reek_grapher_spec.rb\n") }

  let(:config_setup) {
    ENV["CC_BUILD_ARTIFACTS"] = nil
    MetricFu.configure.reset
  }

  describe "analyze method" do
    before :each do
      config_setup
      @changes = { "lib/generators/flog.rb" => 2, "lib/metric_fu.rb" => 3 }
    end

    it "should be empty on error no output captured" do
      churn = MetricFu::ChurnGenerator.new
      churn.instance_variable_set(:@output, nil)
      result = churn.analyze
      expect(result).to eq(churn: {})
    end

    it "should return yaml results" do
      churn = MetricFu::ChurnGenerator.new
      churn.instance_variable_set(:@output, churn_hash)
      result = churn.analyze
      expect(result).to eq(churn: { changed_files: ["spec/graphs/flog_grapher_spec.rb", "spec/base/graph_spec.rb", "lib/templates/awesome/layout.html.erb", "lib/graphs/rcov_grapher.rb", "lib/base/base_template.rb", "spec/graphs/grapher_spec.rb", "lib/templates/awesome/flog.html.erb", "lib/templates/awesome/flay.html.erb", "lib/graphs/roodi_grapher.rb", "lib/graphs/reek_grapher.rb", "HISTORY", "spec/graphs/roodi_grapher_spec.rb", "lib/generators/rcov.rb", "spec/graphs/engines/gchart_spec.rb", "spec/graphs/rcov_grapher_spec.rb", "lib/templates/javascripts/excanvas.js", "lib/templates/javascripts/bluff-min.js", "spec/graphs/reek_grapher_spec.rb"] })
    end
  end

  describe "to_h method" do
    before :each do
      config_setup
    end

    it "should put the changes into a hash" do
      churn = MetricFu::ChurnGenerator.new
      churn.instance_variable_set(:@churn, churn: "results")
      expect(churn.to_h[:churn]).to eq("results")
    end
  end

  describe "emit method" do
    before :each do
      config_setup
      @churn = MetricFu::ChurnGenerator.new
    end

    it "returns churn output" do
      allow(@churn).to receive(:run).and_return(churn_hash)
      result = @churn.emit
      expect(result).to eq(churn_hash)
    end

    it "returns nil, when churn result is not yaml" do
      allow(@churn).to receive(:run).and_return(nil)
      result = @churn.emit
      expect(result).to be nil
    end
  end
end
