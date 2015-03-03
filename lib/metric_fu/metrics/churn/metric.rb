module MetricFu
  class MetricChurn < Metric
    def name
      :churn
    end

    def default_run_options
      {
        start_date: '"1 year ago"',
        minimum_churn_count: 10,
        ignore_files: [],
        data_directory: MetricFu::Io::FileSystem.scratch_directory(name)
      }
    end

    def has_graph?
      false
    end

    def enable
      super
    end

    def activate
      activate_library("churn/calculator")
      super
    end
  end
end
