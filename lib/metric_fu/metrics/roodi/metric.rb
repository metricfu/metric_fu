module MetricFu
  class MetricRoodi < Metric
    def name
      :roodi
    end

    def default_run_options
      { dirs_to_roodi: MetricFu::Io::FileSystem.directory("code_dirs"),
        roodi_config: "#{MetricFu::Io::FileSystem.directory('root_directory')}/config/roodi_config.yml" }
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
