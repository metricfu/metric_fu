require "spec_helper"
require "metric_fu/metrics/hotspots/analysis/record"

describe MetricFu::RcovHotspot do
  describe "map" do
    let(:zero_row) do
      MetricFu::Record.new({"percentage_uncovered"=>0.0}, nil)
    end

    let(:non_zero_row) do
      MetricFu::Record.new({"percentage_uncovered"=>0.75}, nil)
    end

    it {subject.map(zero_row).should eql(0.0)}
    it {subject.map(non_zero_row).should eql(0.75)}
  end
end