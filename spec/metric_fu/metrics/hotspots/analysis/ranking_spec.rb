require "spec_helper"

describe MetricFu::Ranking do

  context "with many items" do

    specify "#top" do
      ranking = Ranking.new
      ranking[:a] = 10
      ranking[:b] = 50
      ranking[:c] = 1
      ranking.top.should == [:b,:a, :c]
    end

    specify "lowest item is at 0 percentile" do
      ranking = Ranking.new
      ranking[:a] = 10
      ranking[:b] = 50
      ranking.percentile(:a).should == 0
    end

    specify "highest item is at high percentile" do
      ranking = Ranking.new
      ranking[:a] = 10
      ranking[:b] = 50
      ranking[:c] = 0
      ranking[:d] = 5
      ranking.percentile(:b).should == 0.75
    end

  end

end
