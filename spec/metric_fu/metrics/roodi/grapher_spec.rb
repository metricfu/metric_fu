require "spec_helper"
MetricFu.metrics_require { "roodi/grapher" }

describe RoodiGrapher do
  before :each do
    @roodi_grapher = MetricFu::RoodiGrapher.new
    MetricFu.configuration
  end

  it "should respond to roodi_count and labels" do
    expect(@roodi_grapher).to respond_to(:roodi_count)
    expect(@roodi_grapher).to respond_to(:labels)
  end

  describe "responding to #initialize" do
    it "should initialise roodi_count and labels" do
      expect(@roodi_grapher.roodi_count).to eq([])
      expect(@roodi_grapher.labels).to eq({})
    end
  end

  describe "responding to #get_metrics" do
    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "1/2"
      end

      it "should not push to roodi_count" do
        expect(@roodi_grapher.roodi_count).not_to receive(:push)
        @roodi_grapher.get_metrics(@metrics, @date)
      end

      it "should not update labels with the date" do
        expect(@roodi_grapher.labels).not_to receive(:update)
        @roodi_grapher.get_metrics(@metrics, @date)
      end
    end

    context "when metrics have been generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("20090630.yml")
        @date = "1/2"
      end

      it "should push to roodi_count" do
        expect(@roodi_grapher.roodi_count).to receive(:push).with(13)
        @roodi_grapher.get_metrics(@metrics, @date)
      end

      it "should update labels with the date" do
        expect(@roodi_grapher.labels).to receive(:update).with(0 => "1/2")
        @roodi_grapher.get_metrics(@metrics, @date)
      end
    end
  end
end
