MetricFu.metrics_require   { 'reek/reek_grapher' }
module MetricFu
  class ReekGchartGrapher < ReekGrapher
    def title
      "Reek: code smells"
    end
    def legend
      @legend ||= @reek_count.keys.sort
    end
    def data
      values = []
      legend.collect {|k| values << @reek_count[k]}
      values
    end
    def output_filename
      'reek.png'
    end
    def gchart_line_options
      super.merge({
          :bar_colors => COLORS,
          :stacked => false,
          :legend => legend,
          :custom => 'chdlp=t',
        })
    end
    def y_axis_scale_argument
      @reek_count.values.flatten.uniq
    end
  end
end
