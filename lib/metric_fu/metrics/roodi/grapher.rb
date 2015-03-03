MetricFu.reporting_require { "graphs/grapher" }
module MetricFu
  class RoodiGrapher < Grapher
    attr_accessor :roodi_count, :labels

    def self.metric
      :roodi
    end

    def initialize
      super
      @roodi_count = []
      @labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:roodi]
        @roodi_count.push(metrics[:roodi][:problems].size)
        @labels.update(@labels.size => date)
      end
    end

    def title
      "Roodi: design problems"
    end

    def data
      [
        ["roodi", @roodi_count.join(",")]
      ]
    end

    def output_filename
      "roodi.js"
    end
  end
end
