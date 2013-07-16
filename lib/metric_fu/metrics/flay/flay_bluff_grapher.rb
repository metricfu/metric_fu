MetricFu.metrics_require   { 'flay/flay_grapher' }
module MetricFu
  class FlayBluffGrapher < FlayGrapher
    def title
      'Flay: duplication'
    end
    def data
      [
        ['flay', @flay_score.join(',')]
      ]
    end
    def output_filename
      'flay.js'
    end
  end
end
