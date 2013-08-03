module MetricFu
  class MetricStats < Metric

    def name
      :stats
    end

    def default_run_options
      {}
    end

    def has_graph?
      true
    end

    def enable
      super if MetricFu.configuration.rails?
    end

  end
end
