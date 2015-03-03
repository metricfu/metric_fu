MetricFu.lib_require { "errors/analysis_error" }
MetricFu.metrics_require { "hotspots/analysis/scoring_strategies" }

module MetricFu
  class Hotspot
    def self.metric
      name.split("::")[-1].split("Hotspot")[0].downcase.to_sym
    end
    @analyzers = {}
    def self.analyzers
      @analyzers.values
    end
    def self.analyzer_for_metric(metric)
      @analyzers.fetch(metric.to_sym) do
        message = "Unknown metric #{metric}. We only know #{@analyzers.keys.inspect}"
        fail MetricFu::AnalysisError, message
      end
    end
    def self.inherited(subclass)
      mf_debug "Adding #{subclass} to #{@analyzers.inspect}"
      @analyzers[subclass.metric] = subclass.new
    end

    def get_mean(collection)
      MetricFu::HotspotScoringStrategies.average(collection)
    end

    def map(row)
      mapping_strategies.fetch(map_strategy) { row.public_send(map_strategy) }
    end

    def mapping_strategies
      {
        present: 1,
        absent: 0,
      }
    end

    def map_strategy
      not_implemented
    end

    def reduce(scores)
      {
        average: MetricFu::HotspotScoringStrategies.average(scores),
        sum: MetricFu::HotspotScoringStrategies.sum(scores),
        absent: 0,
      }.fetch(reduce_strategy) do
        fail "#{reduce_strategy} not a known reduce strategy"
      end
    end

    def reduce_strategy
      not_implemented
    end

    # @return [Integer]
    def score(metric_ranking, item)
      {
        identity: MetricFu::HotspotScoringStrategies.identity(metric_ranking, item),
        percentile: MetricFu::HotspotScoringStrategies.percentile(metric_ranking, item),
        absent: 0,
      }.fetch(score_strategy) { method(score_strategy).call(metric_ranking, item) }
    end

    def score_strategy
      not_implemented
    end

    # Transforms the data param, if non-nil, into a hash with keys:
    #   'metric',  etc.
    #   and appends the hash to the table param
    #   Has no return value
    def generate_records(_data, _table)
      not_implemented
    end

    # @return [String] description result
    def present_group(_group)
      not_implemented
    end

    def not_implemented
      raise "#{caller[0]} not implemented"
    end
  end
end
