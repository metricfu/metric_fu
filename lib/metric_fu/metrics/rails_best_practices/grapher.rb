MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class RailsBestPracticesGrapher < Grapher
    attr_accessor :rails_best_practices_count, :labels

    def self.metric
      :rails_best_practices
    end

    def initialize
      super
      @rails_best_practices_count = []
      @labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:rails_best_practices]
        size = (metrics[:rails_best_practices][:problems] || []).size
        @rails_best_practices_count.push(size)
        @labels.update(@labels.size => date)
      end
    end

    def title
      "Rails Best Practices: design problems"
    end

    def data
      [
        ["rails_best_practices", @rails_best_practices_count.join(",")]
      ]
    end

    def output_filename
      "rails_best_practices.js"
    end
  end
end
