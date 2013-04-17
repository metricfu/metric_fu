require 'spec_helper'

describe "MetricFu::Hotspot" do
  it "returns an array of of the analyzers that subclass it" do
    expected_analyzers = [ReekHotspot, RoodiHotspot,
      FlogHotspot, ChurnHotspot, SaikuroHotspot,
      FlayHotspot, StatsHotspot, RcovHotspot]

    MetricFu::Hotspot.analyzers.size.should == expected_analyzers.size
  end
end
