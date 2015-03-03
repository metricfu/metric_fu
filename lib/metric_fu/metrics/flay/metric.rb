module MetricFu
  class MetricFlay < Metric
    def name
      :flay
    end

    def default_run_options
      { dirs_to_flay: MetricFu::Io::FileSystem.directory("code_dirs"),
        # MetricFu has been setting the minimum score as 100 for
        # a long time. This is a really big number, considering
        # the default is 16. Setting it to nil to use the Flay default.
        minimum_score: nil,
      }
    end

    def has_graph?
      true
    end

    def enable
      super
    end

    def activate
      super
    end
  end
end
