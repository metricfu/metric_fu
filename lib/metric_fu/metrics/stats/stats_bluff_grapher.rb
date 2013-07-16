MetricFu.metrics_require   { 'stats/stats_grapher' }
module MetricFu
  class StatsBluffGrapher < StatsGrapher
    def title
      'Stats: LOC & LOT'
    end
    def data
      [
        ['LOC', @loc_counts.join(',')],
        ['LOT', @lot_counts.join(',')],
      ]
    end
    def output_filename
      'stats.js'
    end
  end
end
