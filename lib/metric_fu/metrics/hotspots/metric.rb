module MetricFu
  class MetricHotspots < Metric
    def name
      :hotspots
    end

    # TODO remove explicit Churn dependency
    def default_run_options
      { start_date: "1 year ago", minimum_churn_count: 10 }
    end

    def has_graph?
      false
    end

    def enable
      super
    end
  end
end
