MetricFu.metrics_require   { 'rails_best_practices/rails_best_practices_grapher' }
module MetricFu
  class RailsBestPracticesGchartGrapher < RailsBestPracticesGrapher
    def graph!
      determine_y_axis_scale(@rails_best_practices_count)
      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Rails Best Practices: design problems"),
        :data => self.rails_best_practices_count,
        :bar_colors => COLORS[0..1],
        :legend => ['Problems'],
        :custom => "chdlp=t",
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'rails_best_practices.png')
      )
    end
  end
end
