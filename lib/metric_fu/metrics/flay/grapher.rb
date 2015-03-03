MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class FlayGrapher < Grapher
    attr_accessor :flay_score, :labels

    def self.metric
      :flay
    end

    def initialize
      super
      @flay_score = []
      @labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:flay]
        @flay_score.push(metrics[:flay][:total_score].to_i)
        @labels.update(@labels.size => date)
      end
    end

    def title
      "Flay: duplication"
    end

    def data
      [
        ["flay", @flay_score.join(",")]
      ]
    end

    def output_filename
      "flay.js"
    end
  end
end
