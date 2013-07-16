MetricFu.metrics_require   { 'stats/stats_grapher' }
module MetricFu
  class StatsGchartGrapher < StatsGrapher
    def title
      "Stats: LOC & LOT"
    end
    def data
      [@loc_counts, @lot_counts]
    end
    def output_filename
      'stats.png'
    end
    def legend
      ['Lines of code', 'Lines of test']
    end
    def gchart_line_options
      super.merge({
          :bar_colors => COLORS[0..1],
          :legend => legend,
          :custom => 'chdlp=t',
        })
    end
    def y_axis_scale_argument
      @loc_counts + @lot_counts
    end
  end
end
