module MetricFu
  class MetricRubocop < Metric
    def name
      :rubocop
    end

    def default_run_options
      config = "#{MetricFu::Io::FileSystem.directory('root_directory')}/.rubocop.yml"
      {
        :dirs_to_rubocop => MetricFu::Io::FileSystem.directory('code_dirs')
      }.merge(File.exists?(config) ? {:config => config} : {})
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