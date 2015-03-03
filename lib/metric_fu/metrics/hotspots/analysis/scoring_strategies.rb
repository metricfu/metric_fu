module MetricFu
  module HotspotScoringStrategies
    module_function

    # per project score percentile
    def percentile(ranking, item)
      ranking.percentile(item)
    end

    # Use the score you got
    #   (ex flog score of 20 is not bad even if it is the top one in project)
    def identity(ranking, item)
      ranking.fetch(item)
    end

    def sum(scores)
      scores.inject(&:+)
    end

    def average(scores)
      sum(scores).to_f / scores.size.to_f
    end
  end
end
