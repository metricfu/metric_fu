MetricFu.metrics_require   { 'reek/reek_grapher' }
module MetricFu
  class ReekGchartGrapher < ReekGrapher
    def graph!
      determine_y_axis_scale(@reek_count.values.flatten.uniq)
      values = []
      legend = @reek_count.keys.sort
      legend.collect {|k| values << @reek_count[k]}

      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Reek: code smells"),
        :data => values,
        :stacked => false,
        :bar_colors => COLORS,
        :legend => legend,
        :custom => "chdlp=t",
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'reek.png'))
    end
  end
end
