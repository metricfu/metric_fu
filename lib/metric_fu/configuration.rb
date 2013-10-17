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
    configuration.tap do |config|
      config.configure_metrics
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
  # Each metric can be configured by e.g.
  #   config.configure_metric(:flog) do |flog|
  #     flog.enable
  #     flog.dirs_to_flog = %w(app lib spec)
  #     ...
  #   end
  #
  # or iterate over all metrics to configure by e.g.
  #   config.configure_metrics.each do |metric|
  #     ...
  #   end
  #
  # == Formatter Configuration
  #
  # Formatters can be configured by e.g.
  #   config.configure_formatter(:html)
  #   config.configure_formatter(:yaml, "customreport.yml")
  #   config.configure_formatter(MyCustomFormatter)
  #
  class Configuration
    require_relative 'environment'
    require_relative 'io'
    require_relative 'formatter'
    # TODO: Remove need to include the module
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
      # TODO: Remove calls to self and/or allow querying the
      #   template/filesystem/metric/graph/environment, etc settings
      #   from the configuration instance
      MetricFu::Io::FileSystem.set_directories
      MetricFu::Formatter::Templates.configure_template(self)
      @formatters = []
    end

    # This allows us to have a nice syntax like:
    #
    #   MetricFu.run do |config|
    #     config.configure_metric(:churn) do
    #       ...
    #     end
    #
    #     config.configure_formatter(MyCustomFormatter)
    #   end
    #
    # See the README for more information on configuration options.
    # TODO: Consider breaking compatibility by removing this, now unused method
    def self.run
      yield MetricFu.configuration
    end

    def configure_metric(name)
      yield MetricFu::Metric.get_metric(name)
    end

    def configure_metrics
      MetricFu::Io::FileSystem.set_directories
      MetricFu::Metric.metrics.each do |metric|
        if block_given?
          yield metric
        elsif !metric_manually_configured?(metric)
          metric.enabled = false
          metric.enable
        end
        metric.activate if metric.enabled unless metric.activated
      end
    end

    # TODO: Remove this method.  If we run configure_metrics
    #   and it disabled rcov, we shouldn't have to worry here
    #   that rcov is a special case that can only be enabled
    #   manually
    def metric_manually_configured?(metric)
      [:rcov].include?(metric.name)
    end

    # TODO: Reconsider method name/behavior, as it really adds a formatter
    def configure_formatter(format, output = nil)
      @formatters << MetricFu::Formatter.class_for(format).new(output: output)
    end

    # @return [Array<Symbol>] names of enabled metrics with graphs
    def graphed_metrics
      # TODO: This is a common enough need to be pushed into MetricFu::Metric as :enabled_metrics_with_graphs
      MetricFu::Metric.enabled_metrics.select{|metric|metric.has_graph?}.map(&:name)
    end

    def graph_engine
      :bluff
    end

  end
end
