require "spec_helper"
MetricFu.metrics_require { "hotspots/analysis/ranking" }

describe MetricFu::Ranking do
  context "with many items" do
    specify "#top" do
      ranking = Ranking.new
      ranking[:a] = 10
      ranking[:b] = 50
      ranking[:c] = 1
      expect(ranking.top).to eq([:b, :a, :c])
    end

    specify "lowest item is at 0 percentile" do
      ranking = Ranking.new
      ranking[:a] = 10
      ranking[:b] = 50
      expect(ranking.percentile(:a)).to eq(0)
    end

    specify "highest item is at high percentile" do
      ranking = Ranking.new
      ranking[:a] = 10
      ranking[:b] = 50
      ranking[:c] = 0
      ranking[:d] = 5
      expect(ranking.percentile(:b)).to eq(0.75)
    end
  end
end
