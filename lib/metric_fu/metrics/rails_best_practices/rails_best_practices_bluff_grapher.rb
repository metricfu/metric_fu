MetricFu.metrics_require   { 'rails_best_practices/rails_best_practices_grapher' }
module MetricFu
  class RailsBestPracticesBluffGrapher < RailsBestPracticesGrapher
    def title
      'Rails Best Practices: design problems'
    end
    def data
      [
        ['rails_best_practices', @rails_best_practices.join(',')]
      ]
    end
    def output_filename
      'rails_best_practices.js'
    end
  end
end
