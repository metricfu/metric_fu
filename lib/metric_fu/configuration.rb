MetricFu.lib_require { "logger" }
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
    configuration.tap(&:configure_metrics)
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
    require_relative "environment"
    require_relative "io"
    require_relative "formatter"
    require_relative "templates/configuration"

    # TODO: Remove need to include the module
    include MetricFu::Environment

    def initialize #:nodoc:#
      reset
    end

    # TODO review if these code is functionally duplicated in the
    # base generator initialize
    attr_reader :formatters
    def reset
      # TODO: Remove calls to self and/or allow querying the
      #   template/filesystem/metric/graph/environment, etc settings
      #   from the configuration instance
      MetricFu::Io::FileSystem.set_directories
      @templates_configuration = MetricFu::Templates::Configuration.new
      MetricFu::Formatter::Templates.templates_configuration = @templates_configuration
      @formatters = []
      @graph_engine = :bluff
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

    def self.configure_metric(name)
      yield MetricFu::Metric.get_metric(name)
    end

    def configure_metric(name, &block)
      self.class.configure_metric(name, &block)
    end

    def configure_metrics
      MetricFu::Io::FileSystem.set_directories
      MetricFu::Metric.metrics.each do |metric|
        if block_given?
          yield metric
        else
          metric.enabled = false
          metric.enable
        end
        metric.activate if metric.enabled unless metric.activated
      end
    end

    # TODO: Reconsider method name/behavior, as it really adds a formatter
    def configure_formatter(format, output = nil)
      @formatters << MetricFu::Formatter.class_for(format).new(output: output)
    end

    # @return [Array<Symbol>] names of enabled metrics with graphs
    def graphed_metrics
      # TODO: This is a common enough need to be pushed into MetricFu::Metric as :enabled_metrics_with_graphs
      MetricFu::Metric.enabled_metrics.select(&:has_graph?).map(&:name)
    end

    def configure_graph_engine(graph_engine)
      @graph_engine = graph_engine
    end

    def graph_engine
      @graph_engine
    end

    # This allows us to configure the templates with:
    #
    #   MetricFu.run do |config|
    #     config.templates_configuration do |templates_config|
    #       templates_config.link_prefix = 'http:/'
    #     end
    #   end
    def templates_configuration
      yield @templates_configuration
    end

    # @param option [String, Symbol] the requested template option
    # @return [String] the configured template option
    def templates_option(option)
      @templates_configuration.option(option)
    end
  end
end
