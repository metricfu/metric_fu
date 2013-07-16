MetricFu.metrics_require   { 'flay/flay_grapher' }
module MetricFu
  class FlayGchartGrapher < FlayGrapher
    def title
      "Flay: duplication"
    end
    def data
      @flay_score
    end
    def output_filename
      'flay.png'
    end
    def gchart_line_options
      super
    end
    def y_axis_scale_argument
      @flay_score
    end
  end
end
