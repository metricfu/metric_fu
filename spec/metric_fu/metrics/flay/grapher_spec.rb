require "spec_helper"
MetricFu.metrics_require { "flay/grapher" }

describe FlayGrapher do
  before :each do
    @flay_grapher = MetricFu::FlayGrapher.new
    MetricFu.configuration
  end

  it "should respond to flay_score and labels" do
    expect(@flay_grapher).to respond_to(:flay_score)
    expect(@flay_grapher).to respond_to(:labels)
  end

  describe "responding to #initialize" do
    it "should initialise flay_score and labels" do
      expect(@flay_grapher.flay_score).to eq([])
      expect(@flay_grapher.labels).to eq({})
    end
  end

  describe "responding to #get_metrics" do
    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "1/2"
      end

      it "should not push to flay_score" do
        expect(@flay_grapher.flay_score).not_to receive(:push)
        @flay_grapher.get_metrics(@metrics, @date)
      end

      it "should not update labels with the date" do
        expect(@flay_grapher.labels).not_to receive(:update)
        @flay_grapher.get_metrics(@metrics, @date)
      end
    end

    context "when metrics have been generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("20090630.yml")
        @date = "1/2"
      end

      it "should push to flay_score" do
        expect(@flay_grapher.flay_score).to receive(:push).with(476)
        @flay_grapher.get_metrics(@metrics, @date)
      end

      it "should update labels with the date" do
        expect(@flay_grapher.labels).to receive(:update).with(0 => "1/2")
        @flay_grapher.get_metrics(@metrics, @date)
      end
    end
  end
end
