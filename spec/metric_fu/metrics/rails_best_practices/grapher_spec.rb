require "spec_helper"
MetricFu.metrics_require { "rails_best_practices/grapher" }

describe RailsBestPracticesGrapher do
  before :each do
    @stats_grapher = MetricFu::RailsBestPracticesGrapher.new
    MetricFu.configuration
  end

  it "should respond to rails_best_practices_count and labels" do
    expect(@stats_grapher).to respond_to(:rails_best_practices_count)
    expect(@stats_grapher).to respond_to(:labels)
  end

  describe "responding to #initialize" do
    it "should initialise rails_best_practices_count and labels" do
      expect(@stats_grapher.rails_best_practices_count).to eq([])
      expect(@stats_grapher.labels).to eq({})
    end
  end

  describe "responding to #get_metrics" do
    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "01022003"
      end

      it "should not push to rails_best_practices_count" do
        expect(@stats_grapher.rails_best_practices_count).not_to receive(:push)
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

      it "should push to rails_best_practices_count" do
        expect(@stats_grapher.rails_best_practices_count).to receive(:push).with(2)
        @stats_grapher.get_metrics(@metrics, @date)
      end

      it "should push 0 to rails_best_practices_count when no problems were found" do
        expect(@stats_grapher.rails_best_practices_count).to receive(:push).with(0)
        @stats_grapher.get_metrics({ rails_best_practices: {} }, @date)
      end

      it "should update labels with the date" do
        expect(@stats_grapher.labels).to receive(:update).with(0 => "01022003")
        @stats_grapher.get_metrics(@metrics, @date)
      end
    end
  end
end
