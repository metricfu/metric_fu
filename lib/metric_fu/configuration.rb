require 'fileutils'
require 'rbconfig'
MetricFu.reporting_require { 'templates/awesome/awesome_template' }
MetricFu.logging_require { 'mf_debugger' }
module MetricFu


  # The @configuration class variable holds a global type configuration
  # object for any parts of the system to use.
  # TODO Configuration should probably be a singleton class
  def self.configuration
    @configuration ||= Configuration.new
  end

  # = Configuration
  #
  # The Configuration class, as it sounds, provides methods for
  # configuring the behaviour of MetricFu.
  #
  # == Customization for Rails
  #
  # The Configuration class checks for the presence of a
  # 'config/environment.rb' file.  If the file is present, it assumes
  # it is running in a Rails project.  If it is, it will:
  #
  # * Add 'app' to the @code_dirs directory to include the
  #   code in the app directory in the processing
  # * Add :stats  and :rails_best_practices to the list of metrics to run
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
  # Each metric can be configured by e.g. config.churn, config.flog, config.saikuro
  class Configuration

    def initialize #:nodoc:#
      reset
    end

    def verbose
      MfDebugger::Logger.debug_on
    end

    def verbose=(toggle)
      MfDebugger::Logger.debug_on = toggle
    end

    def mf_debug(msg)
      MfDebugger.mf_debug msg
    end

    # TODO review if these code is functionally duplicated in the
    # base generator initialize
    def reset
      set_directories
      configure_template
      add_promiscuous_instance_variable(:metrics, [])
      add_promiscuous_instance_variable(:formatters, [])
      add_promiscuous_instance_variable(:graphs, [])
      add_promiscuous_instance_variable(:graph_engines, [])
      add_promiscuous_method(:graph_engine)
    end

    # This allows us to have a nice syntax like:
    #
    #   MetricFu.run do |config|
    #     config.base_directory = 'tmp/metric_fu'
    #   end
    #
    # See the README for more information on configuration options.
    def self.run
      yield MetricFu.configuration
    end

    attr_accessor :metrics
    # e.g. :churn
    def add_metric(metric)
      add_promiscuous_method(metric)
      self.metrics = (metrics << metric).uniq
    end

    # e.g. :reek
    def add_graph(metric)
      add_promiscuous_method(metric)
      self.graphs = (graphs << metric).uniq
    end

    def add_formatter(format, output = nil)
      @formatters << MetricFu::Formatter.class_for(format).new(output: output)
    end

    # e.g. :reek, {}
    def configure_metric(metric, metric_configuration)
      add_promiscuous_instance_variable(metric, metric_configuration)
    end

    # e.g. :bluff
    def add_graph_engine(graph_engine)
      add_promiscuous_method(graph_engine)
      self.graph_engines = (graph_engines << graph_engine).uniq
    end

    # e.g. :bluff
    def configure_graph_engine(graph_engine)
      add_promiscuous_instance_variable(:graph_engine, graph_engine)
    end

    # Perform a simple check to try and guess if we're running
    # against a rails app.
    #
    # TODO This should probably be made a bit more robust.
    def rails?
      add_promiscuous_instance_variable(:rails, File.exist?("config/environment.rb"))
    end

    def is_cruise_control_rb?
      !!ENV['CC_BUILD_ARTIFACTS']
    end

    def jruby?
      @jruby ||= !!RedCard.check(:jruby)
    end

    def mri?
      @mri ||= !!RedCard.check(:ruby)
    end

    def platform #:nodoc:
      # TODO, change
      # RbConfig::CONFIG['ruby_install_name'].dup
      return RUBY_PLATFORM
    end

    def self.ruby_strangely_makes_accessors_private?
       ruby192? || jruby?
    end

    def self.ruby192?
      @ruby192 ||= !!RedCard.check('1.9.2')
    end

    protected unless ruby_strangely_makes_accessors_private?

    def add_promiscuous_instance_variable(name,value)
      instance_variable_set("@#{name}", value)
      add_promiscuous_method(name)
      value
    end

    def add_promiscuous_method(method_name)
        add_promiscuous_class_method_to_metric_fu(method_name)
        add_accessor_to_config(method_name)
    end

    def add_promiscuous_class_method_to_metric_fu(method_name)
        metric_fu_method = <<-EOF
                  def self.#{method_name}
                    configuration.send(:#{method_name})
                  end
        EOF
      MetricFu.module_eval(metric_fu_method)
    end


    def add_accessor_to_config(method_name)
      self.class.send(:attr_accessor, method_name)
    end

    private

    def configure_template
      add_promiscuous_instance_variable(:template_class, AwesomeTemplate)
      add_promiscuous_instance_variable(:link_prefix, nil)
      add_promiscuous_instance_variable(:darwin_txmt_protocol_no_thanks, true)
      # turning off syntax_highlighting may avoid some UTF-8 issues
      add_promiscuous_instance_variable(:syntax_highlighting, true)
    end

    def set_directories
      add_promiscuous_instance_variable(:base_directory,MetricFu.artifact_dir)
      add_promiscuous_instance_variable(:scratch_directory,MetricFu.scratch_dir)
      add_promiscuous_instance_variable(:output_directory,MetricFu.output_dir)
      add_promiscuous_instance_variable(:data_directory,MetricFu.data_dir)
      # due to behavior differences between ruby 1.8.7 and 1.9.3
      # this is good enough for now
      create_directories [base_directory, scratch_directory, output_directory]

      add_promiscuous_instance_variable(:metric_fu_root_directory,MetricFu.root_dir)
      add_promiscuous_instance_variable(:template_directory,
                                        File.join(metric_fu_root_directory,
                                         'lib', 'templates'))
      add_promiscuous_instance_variable(:file_globs_to_ignore,[])
      set_code_dirs
    end

    def create_directories(*dirs)
      Array(*dirs).each do |dir|
        FileUtils.mkdir_p dir
      end
    end

    # Add the 'app' directory if we're running within rails.
    def set_code_dirs
      if rails?
        add_promiscuous_instance_variable(:code_dirs,['app', 'lib'])
      else
        add_promiscuous_instance_variable(:code_dirs,['lib'])
      end
    end
  end
end
