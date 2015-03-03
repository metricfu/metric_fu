module MetricFu
  class MetricRailsBestPractices < Metric
    def name
      :rails_best_practices
    end

    def default_run_options
      {}
    end

    def has_graph?
      true
    end

    def enable
      if MetricFu.configuration.supports_ripper?
        super if MetricFu.configuration.rails?
      else
        MetricFu.logger.debug("Rails Best Practices is only available in MRI 1.9. It requires ripper")
      end
    end

    def activate
      activate_library("rails_best_practices")
      super
    end
  end
end
