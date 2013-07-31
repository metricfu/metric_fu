module MetricFu
  class Loader

    attr_reader :loaded_files
    def initialize(lib_root)
      @lib_root = lib_root
      @loaded_files = []
    end

    def lib_require(base='',&block)
      paths = []
      base_path = File.join(@lib_root, base)
      Array((yield paths, base_path)).each do |path|
        file = File.join(base_path, *Array(path))
        require file
        if @loaded_files.include?(file)
          puts "!!!\tAlready loaded #{file}" if !!(ENV['MF_DEBUG'] =~ /true/i)
        else
          @loaded_files << file
        end
      end
    end

    def create_dirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir}_dir") do
            File.join(lib_dir,dir)
          end
          module_eval(%Q(def #{dir}_require(&block); lib_require('#{dir}', &block); end))
        end
      end
    end

    def create_artifact_subdirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir.gsub(/[^A-Za-z0-9]/,'')}_dir") do
            File.join(artifact_dir,dir)
          end
        end
      end
    end

    def load_tasks(tasks_relative_path)
      load File.join(@lib_root, 'tasks', *Array(tasks_relative_path))
    end

    def setup
      MetricFu.lib_require { 'configuration' }
      MetricFu.lib_require { 'metric' }
      MetricFu.lib_require { 'initial_requires' }
      # Load a few things to make our lives easier elsewhere.
      MetricFu.lib_require { 'load_files' }
    end
  end
end

