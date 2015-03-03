require "spec_helper"
MetricFu.metrics_require { "reek/grapher" }

describe ReekGrapher do
  before :each do
    @reek_grapher = MetricFu::ReekGrapher.new
    MetricFu.configuration
  end

  it "should respond to reek_count and labels" do
    expect(@reek_grapher).to respond_to(:reek_count)
    expect(@reek_grapher).to respond_to(:labels)
  end

  describe "responding to #initialize" do
    it "should initialise reek_count and labels" do
      expect(@reek_grapher.reek_count).to eq({})
      expect(@reek_grapher.labels).to eq({})
    end
  end

  describe "responding to #get_metrics" do
    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "1/2"
      end

      it "should not set a hash of code smells to reek_count" do
        @reek_grapher.get_metrics(@metrics, @date)
        expect(@reek_grapher.reek_count).to eq({})
      end

      it "should not update labels with the date" do
        expect(@reek_grapher.labels).not_to receive(:update)
        @reek_grapher.get_metrics(@metrics, @date)
      end
    end

    context "when metrics have been generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("20090630.yml")
        @date = "1/2"
      end

      it "should set a hash of code smells to reek_count" do
        @reek_grapher.get_metrics(@metrics, @date)
        expect(@reek_grapher.reek_count).to eq(
          "Uncommunicative Name" => [27],
          "Feature Envy" => [20],
          "Utility Function" => [15],
          "Long Method" => [26],
          "Nested Iterators" => [12],
          "Control Couple" => [4],
          "Duplication" => [48],
          "Large Class" => [1]
        )
      end

      it "should update labels with the date" do
        expect(@reek_grapher.labels).to receive(:update).with(0 => "1/2")
        @reek_grapher.get_metrics(@metrics, @date)
      end
    end
  end
end
