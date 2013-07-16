MetricFu.metrics_require   { 'cane/cane_grapher' }
module MetricFu
  class CaneGchartGrapher < CaneGrapher
    def title
      'Cane: code quality threshold violations'
    end
    def legend
      ['violations']
    end
    def data
      @cane_violations
    end
    def output_filename
      'cane.png'
    end
    def gchart_line_options
      super.merge({
        :legend => legend,
      })
    end
    def y_axis_scale_argument
      @cane_violations
    end
  end
end
