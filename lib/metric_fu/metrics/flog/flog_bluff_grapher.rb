MetricFu.metrics_require   { 'flog/flog_grapher' }
module MetricFu
  class FlogBluffGrapher < FlogGrapher
    def title
      'Flog: code complexity'
    end
    def data
      [
        ['average', @flog_average.join(',')],
        ['top 5% average', @top_five_percent_average.join(',')]
      ]
    end
    def output_filename
      'flog.js'
    end
  end
end
