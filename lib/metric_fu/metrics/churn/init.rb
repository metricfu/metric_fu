module MetricFu
  class MetricChurn < Metric

    def name
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

    def activate
      super
    end

  end
end
