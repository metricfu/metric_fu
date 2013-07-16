MetricFu.metrics_require   { 'cane/cane_grapher' }
module MetricFu
  class CaneBluffGrapher < CaneGrapher
    def title
      'Cane: code quality threshold violations'
    end
    def data
      [
        ['cane', @cane_violations.join(',')]
      ]
    end
    def output_filename
      'cane.js'
    end
  end
end
