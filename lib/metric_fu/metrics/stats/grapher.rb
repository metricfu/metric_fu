MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class StatsGrapher < Grapher
    attr_accessor :loc_counts, :lot_counts, :labels

    def self.metric
      :stats
    end

    def initialize
      super
      self.loc_counts = []
      self.lot_counts = []
      self.labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:stats]
        loc_counts.push(metrics[:stats][:codeLOC].to_i)
        lot_counts.push(metrics[:stats][:testLOC].to_i)
        labels.update(labels.size => date)
      end
    end

    def title
      "Stats: LOC & LOT"
    end

    def data
      [
        ["LOC", @loc_counts.join(",")],
        ["LOT", @lot_counts.join(",")],
      ]
    end

    def output_filename
      "stats.js"
    end
  end
end
