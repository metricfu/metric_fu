MetricFu.reporting_require { 'graphs/grapher' }
module MetricFu
  class FlayGrapher < Grapher
    attr_accessor :flay_score, :labels

    def initialize
      super
      @flay_score = []
      @labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics.report_hash()[:flay]
        @flay_score.push(metrics.report_hash()[:flay][:total_score].to_i)
        @labels.update( { @labels.size => date })
      end
    end
  end
end
