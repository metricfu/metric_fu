MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class CaneGrapher < Grapher
    attr_accessor :cane_violations, :labels

    def self.metric
      :cane
    end

    def initialize
      super
      @cane_violations = []
      @labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:cane]
        @cane_violations.push(metrics[:cane][:total_violations].to_i)
        @labels.update(@labels.size => date)
      end
    end

    def title
      "Cane: code quality threshold violations"
    end

    def data
      [
        ["cane", @cane_violations.join(",")]
      ]
    end

    def output_filename
      "cane.js"
    end
  end
end
