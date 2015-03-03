require "spec_helper"
MetricFu.metrics_require { "flog/grapher" }

describe MetricFu::FlogGrapher do
  before :each do
    MetricFu.configuration
    @flog_grapher = MetricFu::FlogGrapher.new
  end

  it "should respond to flog_total, flog_average and labels" do
    expect(@flog_grapher).to respond_to(:flog_average)
    expect(@flog_grapher).to respond_to(:labels)
    expect(@flog_grapher).to respond_to(:top_five_percent_average)
  end

  describe "responding to #initialize" do
    it "should initialize top_five_percent_average, flog_average and labels" do
      expect(@flog_grapher.flog_average).to eq([])
      expect(@flog_grapher.labels).to eq({})
      expect(@flog_grapher.top_five_percent_average).to eq([])
    end
  end

  describe "responding to #get_metrics" do
    before(:each) do
      methods = {}
      100.times do |i|
        methods["method_name_#{i}"] = { score: i.to_f }
      end

      @metrics = { flog: { total: 111.1,
                           average: 7.7,
                           method_containers: [{ methods: methods }] } }
      @date = "1/2"
    end

    it "should push to top_five_percent_average" do
      average = (99.0 + 98.0 + 97.0 + 96.0 + 95.0) / 5.0
      expect(@flog_grapher.top_five_percent_average).to receive(:push).with(average)
      @flog_grapher.get_metrics(@metrics, @date)
    end

    it "should push 9.9 to flog_average" do
      expect(@flog_grapher.flog_average).to receive(:push).with(7.7)
      @flog_grapher.get_metrics(@metrics, @date)
    end

    context "when metrics were not generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("metric_missing.yml")
        @date = "1/2"
      end

      it "should not push to top_five_percent_average" do
        expect(@flog_grapher.top_five_percent_average).not_to receive(:push)
        @flog_grapher.get_metrics(@metrics, @date)
      end

      it "should not push to flog_average" do
        expect(@flog_grapher.flog_average).not_to receive(:push)
        @flog_grapher.get_metrics(@metrics, @date)
      end

      it "should not update labels with the date" do
        expect(@flog_grapher.labels).not_to receive(:update)
        @flog_grapher.get_metrics(@metrics, @date)
      end
    end

    context "when metrics have been generated" do
      before(:each) do
        @metrics = FIXTURE.load_metric("20090630.yml")
        @date = "1/2"
      end

      it "should push to top_five_percent_average" do
        average = (73.6 + 68.5 + 66.1 + 46.6 + 44.8 + 44.1 + 41.2 + 36.0) / 8.0
        expect(@flog_grapher.top_five_percent_average).to receive(:push).with(average)
        @flog_grapher.get_metrics(@metrics, @date)
      end

      it "should push to flog_average" do
        expect(@flog_grapher.flog_average).to receive(:push).with(9.9)
        @flog_grapher.get_metrics(@metrics, @date)
      end

      it "should update labels with the date" do
        expect(@flog_grapher.labels).to receive(:update).with(0 => "1/2")
        @flog_grapher.get_metrics(@metrics, @date)
      end
    end
  end

  describe "responding to #get_metrics with legacy data" do
    before(:each) do
      @metrics = FIXTURE.load_metric("20090630.yml")

      @date = "1/2"
    end

    it "should push to top_five_percent_average" do
      average = (73.6 + 68.5 + 66.1 + 46.6 + 44.8 + 44.1 + 41.2 + 36.0) / 8.0
      expect(@flog_grapher.top_five_percent_average).to receive(:push).with(average)
      @flog_grapher.get_metrics(@metrics, @date)
    end
  end
end
