MetricFu.metrics_require   { 'rails_best_practices/rails_best_practices_grapher' }
module MetricFu
  class RailsBestPracticesGchartGrapher < RailsBestPracticesGrapher
    def title
      "Rails Best Practices: design problems"
    end
    def legend
      ['Problems']
    end
    def data
      self.rails_best_practices_count
    end
    def output_filename
      'rails_best_practices.png'
    end
    def gchart_line_options
      super.merge({
          :bar_colors => COLORS[0..1],
          :legend => legend,
          :custom => 'chdlp=t',
        })
    end
    def y_axis_scale_argument
      @rails_best_practices_count
    end
  end
end
