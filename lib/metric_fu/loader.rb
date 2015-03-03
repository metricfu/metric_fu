module MetricFu
  class Loader
    # TODO: This class mostly serves to clean up the base MetricFu module,
    #   but needs further work

    attr_reader :loaded_files
    def initialize(lib_root)
      @lib_root = lib_root
      @loaded_files = []
    end

    def lib_require(base = "", &_block)
      paths = []
      base_path = File.join(@lib_root, base)
      Array((yield paths, base_path)).each do |path|
        file = File.join(base_path, *Array(path))
        require file
        if @loaded_files.include?(file)
          puts "!!!\tAlready loaded #{file}" if !!(ENV["MF_DEBUG"] =~ /true/i)
        else
          @loaded_files << file
        end
      end
    end

    # TODO: Reduce duplication of directory logic
    # Adds methods x_dir and _x_require for the directory x,
    #   relative to the metric_fu lib, to the given klass
    # @param klass [Class] the klass to add methods for the specified directories
    # @yieldreturn [Array<String>] Takes a list of directories and adds readers for each
    # @example For the directory 'metrics', which is relative to the metric_fu lib directory,
    #   creates on the klass two methods:
    #     ::metrics_dir which returns the full path
    #     ::metrics_require which takes a block of files to require relative to the metrics_dir
    def create_dirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir}_dir") do
            File.join(lib_dir, dir)
          end
          module_eval(%(def #{dir}_require(&block); lib_require('#{dir}', &block); end),  __FILE__, __LINE__)
        end
      end
    end

    # Adds method x_dir relative to the metric_fu artifact directory to the given klass
    #   And strips any leading non-alphanumerical character from the directory name
    # @param klass [Class] the klass to add methods for the specified artifact sub-directories
    # @yieldreturn [Array<String>] Takes a list of directories and adds readers for each
    # @example For the artifact sub-directory '_scratch', creates on the klass one method:
    #     ::scratch_dir (which notably has the leading underscore removed)
    def create_artifact_subdirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir.gsub(/[^A-Za-z0-9]/, '')}_dir") do
            File.join(artifact_dir, dir)
          end
        end
      end
    end

    def setup
      MetricFu.lib_require { "logger" }
      MetricFu.logger.debug_on = !!(ENV["MF_DEBUG"] =~ /true/i)

      load_metric_configuration

      MetricFu.lib_require       { "reporter" }
      MetricFu.reporting_require { "result" }

      MetricFu.load_tasks("metric_fu.rake", task_name: "metrics:all")
    end

    def load_metric_configuration
      MetricFu.lib_require { "configuration" }
      load_installed_metrics
      MetricFu.configuration.configure_metrics
      load_user_configuration
    end

    def load_installed_metrics
      MetricFu.lib_require { "metric" }
      Dir.glob(File.join(MetricFu.metrics_dir, "**/metric.rb")).each do |metric_config|
        require metric_config
      end
    end

    def load_user_configuration
      file = File.join(MetricFu.run_dir, ".metrics")
      load file if File.exist?(file)
    end

    # Load specified task task only once
    #   if and only if rake is required and the task is not yet defined
    #   to prevent the task from being loaded multiple times
    # @param tasks_relative_path [String] 'metric_fu.rake' by default
    # @param options [Hash] optional task_name to check if loaded
    # @option options [String] :task_name The task_name to load, if not yet loaded
    def load_tasks(tasks_relative_path, options = { task_name: "" })
      if defined?(Rake::Task) and not Rake::Task.task_defined?(options[:task_name])
        load File.join(@lib_root, "tasks", *Array(tasks_relative_path))
      end
    end
  end
end
