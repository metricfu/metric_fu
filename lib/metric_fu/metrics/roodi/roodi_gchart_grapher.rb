MetricFu.metrics_require   { 'roodi/roodi_grapher' }
module MetricFu
  class RoodiGchartGrapher < RoodiGrapher
    def graph!
      determine_y_axis_scale(@roodi_count)
      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Roodi: potential design problems"),
        :data => @roodi_count,
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'roodi.png'))
    end
  end
end
