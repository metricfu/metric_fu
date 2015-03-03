require "spec_helper"
MetricFu.reporting_require { "graphs/graph" }

describe MetricFu do
  describe "responding to #graph" do
    it "should return an instance of Graph" do
      expect(MetricFu.graph).to be_a(Graph)
    end
  end
end

describe MetricFu::Graph do
  before(:each) do
    @graph = MetricFu::Graph.new
  end

  describe "setting the date on the graph" do
    # TODO better test
    it "should set the date once for one data point" do
      metric_file = "metric_fu/tmp/_data/20101105.yml"
      expect(MetricFu::Utility).to receive(:glob).and_return([metric_file].sort)
      expect(MetricFu::Utility).to receive(:load_yaml).with(metric_file).and_return("Metrics")
      double_grapher = double
      expect(double_grapher).to receive(:get_metrics).with("Metrics", "11/5")
      expect(double_grapher).to receive(:graph!)

      @graph.graphers = [double_grapher]
      @graph.generate
    end

    # TODO better test
    it "should set the date when the data directory isn't in the default place" do
      metric_file = "/some/kind/of/weird/directory/somebody/configured/_data/20101105.yml"
      expect(MetricFu::Utility).to receive(:glob).and_return([metric_file].sort)
      expect(MetricFu::Utility).to receive(:load_yaml).with(metric_file).and_return("Metrics")
      double_grapher = double
      expect(double_grapher).to receive(:get_metrics).with("Metrics", "11/5")
      expect(double_grapher).to receive(:graph!)

      @graph.graphers = [double_grapher]
      @graph.generate
    end
  end
end
