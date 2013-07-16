MetricFu.metrics_require   { 'flog/flog_grapher' }
module MetricFu
  class FlogGchartGrapher < FlogGrapher
    def title
      "Flog: code complexity"
    end
    def legend
      ['average', 'top 5% average']
    end
    def data
      [@flog_average, @top_five_percent_average]
    end
    def output_filename
      'flog.png'
    end
    def gchart_line_options
      super.merge({
          :bar_colors => COLORS[0..1],
          :legend => legend,
          :custom => 'chdlp=t',
          :stacked => false,
        })
    end
    def y_axis_scale_argument
      @top_five_percent_average + @flog_average
    end
  end
end
