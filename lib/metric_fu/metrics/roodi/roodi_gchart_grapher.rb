MetricFu.metrics_require   { 'roodi/roodi_grapher' }
module MetricFu
  class RoodiGchartGrapher < RoodiGrapher
    def title
      "Roodi: potential design problems"
    end
    def data
      @roodi_count
    end
    def output_filename
      'roodi.png'
    end
    def gchart_line_options
      super
    end
    def y_axis_scale_argument
      @roodi_count
    end
  end
end
