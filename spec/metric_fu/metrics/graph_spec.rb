require "spec_helper"
MetricFu.metrics_require { 'graph' }

describe MetricFu do

  describe "responding to #graph" do
    it "should return an instance of Graph" do
      MetricFu.graph.should be_a(Graph)
    end
  end
end

describe MetricFu::Graph do

  before(:each) do
    @graph = MetricFu::Graph.new
  end

  describe "setting the date on the graph" do
    next if breaks_when?(MetricFu.configuration.rubinius?)
    before(:each) do
      @graph.stub(:mf_log)
    end

    it "should set the date once for one data point" do
      Dir.should_receive(:[]).and_return(["metric_fu/tmp/_data/20101105.yml"])
      File.should_receive(:join)
      File.should_receive(:open).and_return("Metrics")
      double_grapher = double
      double_grapher.should_receive(:get_metrics).with("Metrics", "11/5")
      double_grapher.should_receive(:graph!)

      @graph.graphers = [double_grapher]
      @graph.generate
    end

    it "should set the date when the data directory isn't in the default place" do
      Dir.should_receive(:[]).and_return(["/some/kind/of/weird/directory/somebody/configured/_data/20101105.yml"])
      File.should_receive(:join)
      File.should_receive(:open).and_return("Metrics")
      double_grapher = double
      double_grapher.should_receive(:get_metrics).with("Metrics", "11/5")
      double_grapher.should_receive(:graph!)

      @graph.graphers = [double_grapher]
      @graph.generate
    end
  end
end
