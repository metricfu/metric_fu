require 'fileutils'
MetricFu.logging_require { 'mf_debugger' }
module MetricFu

  # Even though the below class methods are defined on the MetricFu module
  # They are included here as they deal with configuration

  # The @configuration class variable holds a global type configuration
  # object for any parts of the system to use.
  # TODO Configuration should probably be a singleton class
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    Dir.glob(File.join(MetricFu.metrics_dir, '**/init.rb')).each{|init_file|require(init_file)}
    Dir.glob(File.join(MetricFu.reporting_dir, '**/init.rb')).each{|init_file|require(init_file)}
    reconfigure
  end

  def self.reconfigure
    MetricFu::Configuration.run do |config|
      MetricFu::Metric.metrics.each do |metric|
        if block_given?
          yield metric
        elsif !metric_manually_configured?(metric)
          metric.enabled = false
          metric.enable
        end
        next unless metric.enabled
        next unless metric.activated || metric.activate
      end
    end
    MetricFu.configuration
  end

  def self.metric_manually_configured?(metric)
    [:rcov].include?(metric.metric_name)
  end

  def self.run_rcov
    MetricFu::Metric.get_metric(:rcov).enabled = true
  end
  def self.skip_rcov
    MetricFu::Metric.get_metric(:rcov).enabled = false
  end
  def self.mri_only_metrics
    if MetricFu.configuration.mri?
      []
    else
      [:cane, :flog, :rails_best_practices]
    end
  end

  # = Configuration
  #
  # The Configuration class, as it sounds, provides methods for
  # configuring the behaviour of MetricFu.
  #
  # == Customization for CruiseControl.rb
  #
  # The Configuration class checks for the presence of a
  # 'CC_BUILD_ARTIFACTS' environment variable.  If it's found
  # it will change the default output directory from the default
  # "tmp/metric_fu to the directory represented by 'CC_BUILD_ARTIFACTS'
  #
  # == Metric Configuration
  #
  # Each metric can be configured by e.g. config.get_metric(:churn)
  class Configuration
    require_relative 'environment'
    require_relative 'io'
    require_relative 'formatter'
    include MetricFu::Environment

    def initialize #:nodoc:#
      reset
    end

    def mf_debug(msg)
      MfDebugger.mf_debug msg
    end

    # TODO review if these code is functionally duplicated in the
    # base generator initialize
    attr_reader :formatters
    def reset
      MetricFu::Io::FileSystem.set_directories(self)
      MetricFu::Formatter::Templates.configure_template(self)
      @formatters = []
      @graph_engine_config = MetricFu::GraphEngine.new
    end

    # This allows us to have a nice syntax like:
    #
    #   MetricFu.run do |config|
    #     config.configure_graph_engine(:bluff)
    #   end
    #
    # See the README for more information on configuration options.
    def self.run
      yield MetricFu.configuration
    end

    # @return [Array<Symbol>] names of enabled metrics with graphs
    def graphs
      MetricFu::Metric.enabled_metrics.select{|metric|metric.has_graph?}.map(&:metric_name)
    end

    def add_formatter(format, output = nil)
      @formatters << MetricFu::Formatter.class_for(format).new(output: output)
    end

    # @return [Array<Symbol>] names of graph engines
    # @example [:bluff, :gchart]
    def graph_engines
      @graph_engine_config.graph_engines
    end

    # @return [Symbol] the selected graph engine
    def graph_engine
      @graph_engine_config.graph_engine
    end

    # @param graph_engine [Symbol] the name of the graph engine
    def add_graph_engine(graph_engine)
      @graph_engine_config.add_graph_engine(graph_engine)
    end

    # @param graph_engine [Symbol] sets the selected graph engine to sue
    def configure_graph_engine(graph_engine)
      @graph_engine_config.configure_graph_engine(graph_engine)
    end

  end
end
