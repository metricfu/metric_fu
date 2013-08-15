module MetricFu
  class MetricFlog < Metric

    def name
      :flog
    end

    def default_run_options
      { :dirs_to_flog => MetricFu::Io::FileSystem.directory('code_dirs')  }
    end

    def has_graph?
      true
    end

    def activate
      require 'flog'
      super
    end

    def enable
      if MetricFu.configuration.mri?
        super
      else
        MetricFu.configuration.mf_debug("Flog is only available in MRI due to flog tasks")
      end
    end

  end
end
