require "spec_helper"
MetricFu.metrics_require { "hotspots/hotspot" }

describe MetricFu::Hotspot do
  before do
    enable_hotspots
  end

  it "returns an array of of the analyzers that subclass it" do
    expected_analyzers = [ReekHotspot, RoodiHotspot,
                          FlogHotspot, ChurnHotspot, SaikuroHotspot,
                          FlayHotspot, StatsHotspot, RcovHotspot]

    expect(MetricFu::Hotspot.analyzers.size).to eq(expected_analyzers.size)
  end
end
