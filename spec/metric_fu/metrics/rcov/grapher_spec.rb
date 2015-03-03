require "spec_helper"
MetricFu.metrics_require { "rcov/grapher" }

describe RcovGrapher do
  before :each do
    @rcov_grapher = MetricFu::RcovGrapher.new
    MetricFu.configuration
  end

  it "should respond to rcov_percent and labels" do
    expect(@rcov_grapher).to respond_to(:rcov_percent)
    expect(@rcov_grapher).to respond_to(:labels)
  end

  describe "responding to #initialize" do
    it "should initialise rcov_percent and labels" do
      expect(@rcov_grapher.rcov_percent).to eq([])
      expect(@rcov_grapher.labels).to eq({})
    end
  end

  describe "responding to #get_metrics" do
    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "1/2"
      end

      it "should not push to rcov_percent" do
        expect(@rcov_grapher.rcov_percent).not_to receive(:push)
        @rcov_grapher.get_metrics(@metrics, @date)
      end

      it "should not update labels with the date" do
        expect(@rcov_grapher.labels).not_to receive(:update)
        @rcov_grapher.get_metrics(@metrics, @date)
      end
    end

    context "when metrics have been generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("20090630.yml")
        @date = "1/2"
      end

      it "should push to rcov_percent" do
        expect(@rcov_grapher.rcov_percent).to receive(:push).with(49.6)
        @rcov_grapher.get_metrics(@metrics, @date)
      end

      it "should update labels with the date" do
        expect(@rcov_grapher.labels).to receive(:update).with(0 => "1/2")
        @rcov_grapher.get_metrics(@metrics, @date)
      end
    end
  end
end
