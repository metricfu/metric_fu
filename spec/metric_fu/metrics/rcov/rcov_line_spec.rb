require "spec_helper"
require "metric_fu/metrics/rcov/rcov_line"

describe MetricFu::RCovLine do
  describe "#to_h" do
    it "returns a hash with the content and was_run" do
      rcov_line = RCovLine.new("some content", 1)

      expect(rcov_line.to_h).to eq(content: "some content", was_run: 1)
    end
  end

  describe "#covered?" do
    it "returns true if was_run is 1" do
      rcov_line = RCovLine.new("", 1)

      expect(rcov_line.covered?).to eq(true)
    end

    it "returns false if was_run is 0" do
      rcov_line = RCovLine.new("", 0)

      expect(rcov_line.covered?).to eq(false)
    end

    it "returns false if was_run is nil" do
      rcov_line = RCovLine.new("", nil)

      expect(rcov_line.covered?).to eq(false)
    end
  end

  describe "#missed?" do
    it "returns true if was_run is 0" do
      rcov_line = RCovLine.new("", 0)

      expect(rcov_line.missed?).to eq(true)
    end

    it "returns false if was_run is 1" do
      rcov_line = RCovLine.new("", 1)

      expect(rcov_line.missed?).to eq(false)
    end

    it "returns false if was_run is nil" do
      rcov_line = RCovLine.new("", nil)

      expect(rcov_line.missed?).to eq(false)
    end
  end

  describe "#ignored?" do
    it "returns true if was_run is nil" do
      rcov_line = RCovLine.new("", nil)

      expect(rcov_line.ignored?).to eq(true)
    end

    it "returns false if was_run is 1" do
      rcov_line = RCovLine.new("", 1)

      expect(rcov_line.ignored?).to eq(false)
    end

    it "returns false if was_run is 0" do
      rcov_line = RCovLine.new("", 0)

      expect(rcov_line.ignored?).to eq(false)
    end
  end

  describe "#css_class" do
    it "returns 'rcov_run' for an ignored line" do
      rcov_line = RCovLine.new("", nil)
      expect(rcov_line.css_class).to eq("rcov_run")
    end

    it "returns 'rcov_not_run' for a missed line" do
      rcov_line = RCovLine.new("", 0)
      expect(rcov_line.css_class).to eq("rcov_not_run")
    end

    it "returns 'rcov_run' for a covered line" do
      rcov_line = RCovLine.new("", 1)
      expect(rcov_line.css_class).to eq("rcov_run")
    end
  end
end
