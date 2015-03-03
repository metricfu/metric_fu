require "spec_helper"
MetricFu.metrics_require { "hotspots/metric" }
MetricFu.metrics_require { "hotspots/hotspot" }
MetricFu.metrics_require { "hotspots/analysis/record" }
MetricFu.metrics_require { "rcov/hotspot" }

describe MetricFu::RcovHotspot do
  describe "map" do
    let(:zero_row) do
      MetricFu::Record.new({ "percentage_uncovered" => 0.0 }, nil)
    end

    let(:non_zero_row) do
      MetricFu::Record.new({ "percentage_uncovered" => 0.75 }, nil)
    end

    it { expect(subject.map(zero_row)).to eql(0.0) }
    it { expect(subject.map(non_zero_row)).to eql(0.75) }
  end
end
