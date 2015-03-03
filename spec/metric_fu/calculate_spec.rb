require "spec_helper"
MetricFu.lib_require { "calculate" }

describe MetricFu::Calculate do
  describe "returns a percent rounded to the nearest integer" do
    specify "3 / 10 == 30" do
      expect(MetricFu::Calculate.integer_percent(3, 10)).to eq(30)
    end
    specify "3.0 / 10 == 30" do
      expect(MetricFu::Calculate.integer_percent(3.0, 10)).to eq(30)
    end
    it "raises an ArgumentError on non-numeric input" do
      expect {
        MetricFu::Calculate.integer_percent("", 10)
      }.to raise_error(ArgumentError)
    end
    it "returns 0 when the denominator is 0" do
      expect(MetricFu::Calculate.integer_percent(3, 0)).to eq(0)
    end
  end
end
