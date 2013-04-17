MetricFu.metrics_require   { 'flog/flog_grapher' }
module MetricFu
  class FlogGchartGrapher < FlogGrapher
    def graph!
      determine_y_axis_scale(@top_five_percent_average + @flog_average)
      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Flog: code complexity"),
        :data => [@flog_average, @top_five_percent_average],
        :stacked => false,
        :bar_colors => COLORS[0..1],
        :legend => ['average', 'top 5% average'],
        :custom => "chdlp=t",
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'flog.png'))
    end
  end
end
