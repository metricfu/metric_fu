require "spec_helper"
MetricFu.metrics_require { "rails_best_practices/generator" }

describe RailsBestPracticesGenerator do
  break if metric_not_activated?(:rails_best_practices)

  describe "emit method" do
    let(:analyzer) { ::RailsBestPractices::Analyzer.new(".",  "silent" => true) }
    context "RailsBestPractices provides the expected API" do
      it { expect(analyzer).to respond_to :analyze }
      it { expect(analyzer).to respond_to :errors }
    end
  end

  describe "analyze method" do
    let(:error) { ::RailsBestPractices::Core::Error.new }
    context "RailsBestPractices provdies the expected API" do
      it { expect(error).to respond_to :filename }
      it { expect(error).to respond_to :line_number }
      it { expect(error).to respond_to :message }
      it { expect(error).to respond_to :url }
    end
  end

  describe "to_h method" do
    it "should put things into a hash" do
      MetricFu::Configuration.run {}
      practices = MetricFu::RailsBestPracticesGenerator.new
      practices.instance_variable_set(:@rails_best_practices_results, "the_practices")
      expect(practices.to_h[:rails_best_practices]).to eq("the_practices")
    end
  end
end
