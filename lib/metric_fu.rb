module MetricFu
  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
  LIB_ROOT = File.join(APP_ROOT,'lib/metric_fu')
  @loaded_files = []
  class << self
    attr_reader :loaded_files
  end
  def self.lib_require(base='',&block)
    paths = []
    base_path = File.join(LIB_ROOT, base)
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
  def self.root_dir
    APP_ROOT
  end
  def self.lib_dir
    LIB_ROOT
  end
  class << self
    %w(metrics reporting logging errors data_structures tasks).each do |dir|
      define_method("#{dir}_dir") do
        File.join(lib_dir,dir)
      end
      module_eval(%Q(def #{dir}_require(&block); lib_require('#{dir}', &block); end))
    end
  end
  def self.tasks_load(tasks_relative_path)
    load File.join(LIB_ROOT, 'tasks', *Array(tasks_relative_path))
  end
  # path is relative to where the task is being run,
  # not to the metric_fu library
  def self.artifact_dir
    (ENV['CC_BUILD_ARTIFACTS'] || 'tmp/metric_fu')
  end
  def self.configure
    MetricFu.lib_require { 'core_ext' }
    MetricFu.lib_require { 'configuration' }
    init_files = Dir.glob(File.join(MetricFu.metrics_dir, '**/init.rb')).reject do |file|
      if file =~ /rcov/o
        MetricFu.configuration.mf_debug("rcov is not available. See README")
        true
      elsif MetricFu.configuration.mri?
        false
      elsif file =~ /cane/o
        MetricFu.configuration.mf_debug("Cane is only available in MRI. It requires ripper")
        true
      elsif file =~ /flog/o
        MetricFu.configuration.mf_debug("Flog is only available in MRI. It requires ripper")
        true
      elsif file =~ /rails_best_practices/o
        MetricFu.configuration.mf_debug("Rails Best Practices only available in MRI. It requires ripper")
        true
      else
        false
      end
    end
    init_files.each do |file|
      load file
    end
    MetricFu.configuration
  end
  def self.mri_only_metrics
    if MetricFu.configuration.mri?
      []
    else
      [:cane, :flog, :rails_best_practices]
    end
  end
  def self.run_rcov
    load File.join(MetricFu.metrics_dir, 'rcov/init.rb')
  end
  def self.skip_rcov
    MetricFu.metrics -= [:rcov]
    MetricFu.graphs  -= [:rcov]
  end
  class << self
    %w(scratch output _data).each do |dir|
      define_method("#{dir.gsub(/[^A-Za-z0-9]/,'')}_dir") do
        File.join(artifact_dir,dir)
      end
    end

  end
  # def const_missing(name)
  #
  # end
end
MetricFu.lib_require { 'version' }
MetricFu.lib_require { 'initial_requires' }
# Load a few things to make our lives easier elsewhere.
MetricFu.lib_require { 'load_files' }
