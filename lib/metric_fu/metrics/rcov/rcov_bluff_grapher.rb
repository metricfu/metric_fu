MetricFu.metrics_require   { 'rcov/rcov_grapher' }
module MetricFu
  class RcovBluffGrapher < RcovGrapher
    def title
      'Rcov: code coverage'
    end
    def data
      [
        ['rcov', @rcov_percent.join(',')]
      ]
    end
    def output_filename
      'rcov.js'
    end
  end
end
