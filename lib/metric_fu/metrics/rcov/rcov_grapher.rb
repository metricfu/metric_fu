MetricFu.reporting_require { 'graphs/grapher' }
module MetricFu
  class RcovGrapher < Grapher
    attr_accessor :rcov_percent, :labels

    def self.metric
      :rcov
    end

    def initialize
      super
      self.rcov_percent = []
      self.labels = {}
    end

    def get_metrics(metrics, date)
      if metrics && metrics[:rcov]
        self.rcov_percent.push(metrics[:rcov][:global_percent_run])
        self.labels.update( { self.labels.size => date })
      end
    end

    def title
      'Rcov: code coverage'
    end

    def data
      [
        ['rcov', @rcov_percent.join(',')]
      ]
    end

    def output_filename
      'rcov.js'
    end

  end
end
