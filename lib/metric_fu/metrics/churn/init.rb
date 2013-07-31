module MetricFu
  class MetricChurn < Metric

    def metric_name
      :churn
    end

    def default_run_options
      { :start_date => %q("1 year ago"), :minimum_churn_count => 10}
    end

    def has_graph?
      false
    end

    def enable
      super
    end

  end
end
