MetricFu.metrics_require   { 'flay/flay_grapher' }
module MetricFu
  class FlayGchartGrapher < FlayGrapher
    def graph!
      determine_y_axis_scale(@flay_score)
      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Flay: duplication"),
        :data => @flay_score,
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'flay.png'))
    end
  end
end
