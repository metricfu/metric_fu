MetricFu.metrics_require   { 'stats/stats_grapher' }
module MetricFu
  class StatsGchartGrapher < StatsGrapher
    def graph!
      determine_y_axis_scale(@loc_counts + @lot_counts)
      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Stats: LOC & LOT"),
        :data => [@loc_counts, @lot_counts],
        :bar_colors => COLORS[0..1],
        :legend => ['Lines of code', 'Lines of test'],
        :custom => "chdlp=t",
        :max_value => @max_value,
        :axis_with_labels => 'x,y',
        :axis_labels => [@labels.values, @yaxis],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'stats.png'))
    end
  end
end
