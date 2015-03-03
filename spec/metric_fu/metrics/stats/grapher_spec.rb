require "spec_helper"
MetricFu.metrics_require { "stats/grapher" }

describe StatsGrapher do
  before :each do
    @stats_grapher = MetricFu::StatsGrapher.new
    MetricFu.configuration
  end

  it "should respond to loc_counts and lot_counts and labels" do
    expect(@stats_grapher).to respond_to(:loc_counts)
    expect(@stats_grapher).to respond_to(:lot_counts)
    expect(@stats_grapher).to respond_to(:labels)
  end

  describe "responding to #initialize" do
    it "should initialise loc_counts and lot_counts and labels" do
      expect(@stats_grapher.loc_counts).to eq([])
      expect(@stats_grapher.lot_counts).to eq([])
      expect(@stats_grapher.labels).to eq({})
    end
  end

  describe "responding to #get_metrics" do
    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "01022003"
      end

      it "should not push to loc_counts" do
        expect(@stats_grapher.loc_counts).not_to receive(:push)
        @stats_grapher.get_metrics(@metrics, @date)
      end

      it "should not push to lot_counts" do
        expect(@stats_grapher.lot_counts).not_to receive(:push)
        @stats_grapher.get_metrics(@metrics, @date)
      end

      it "should not update labels with the date" do
        expect(@stats_grapher.labels).not_to receive(:update)
        @stats_grapher.get_metrics(@metrics, @date)
      end
    end

    context "when metrics have been generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("20090630.yml")
        @date = "01022003"
      end

      it "should push to loc_counts" do
        expect(@stats_grapher.loc_counts).to receive(:push).with(15935)
        @stats_grapher.get_metrics(@metrics, @date)
      end

      it "should push to lot_counts" do
        expect(@stats_grapher.lot_counts).to receive(:push).with(7438)
        @stats_grapher.get_metrics(@metrics, @date)
      end

      it "should update labels with the date" do
        expect(@stats_grapher.labels).to receive(:update).with(0 => "01022003")
        @stats_grapher.get_metrics(@metrics, @date)
      end
    end
  end
end
