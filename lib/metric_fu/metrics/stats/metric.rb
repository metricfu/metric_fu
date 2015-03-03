module MetricFu
  class MetricStats < Metric
    def name
      :stats
    end

    def default_run_options
      {
        # returns a list of directories that contains the glob of files that have the file_pattern in the file names
        additional_test_directories: [{ glob_pattern: File.join(".", "spec", "**", "*_spec.rb"), file_pattern: "spec" }],
        additional_app_directories: [{ glob_pattern: File.join(".", "engines", "**", "*.rb"), file_pattern: "" }],
      }
    end

    def has_graph?
      true
    end

    def enable
      super
    end

    def activate
      activate_library "code_metrics"
      super
    end
  end
end
