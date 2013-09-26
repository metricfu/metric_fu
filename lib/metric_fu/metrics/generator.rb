require 'fileutils'
module MetricFu

  # = Generator
  #
  # The Generator class is an abstract class that provides the
  # skeleton for producing different types of metrics.
  #
  # It drives the production of the metrics through a template
  # method - #generate_result(options={}).  This method calls
  # #emit, #analyze and #to_h in order to produce the metrics.
  #
  # To implement a concrete class to generate a metric, therefore,
  # the class must implement those three methods.
  #
  # * #emit should take care of running the metric tool and
  #   gathering its output.
  # * #analyze should take care of manipulating the output from
  #   #emit and making it possible to store it in a programmatic way.
  # * #to_h should provide a hash representation of the output from
  #   #analyze ready to be serialized into yaml at some point.
  #
  # == Pre-conditions
  #
  # Based on the class name of the concrete class implementing a
  # Generator, the Generator class will create a 'metric_directory'
  # named after the metric under the scratch_directory, where
  # any output from the #emit method should go.
  #
  # It will also create the output_directory if neccessary, and
  # in general setup the directory structure that the MetricFu system
  # expects.
  class Generator

    attr_reader :result, :template, :options

    def initialize(options={})
      @options = options
    end

    @generators = []
    # @return all subclassed generators [Array<MetricFu::Generator>]
    def self.generators
      @generators
    end

    def self.get_generator(metric)
      generators.find{|generator|generator.metric.to_s == metric.to_s.downcase}
    end

    def self.inherited(subclass)
      @generators << subclass
    end

    # Returns the directory where the Generator will write any output
    def self.metric_directory
      @metric_directory ||=
        MetricFu::Metric.get_metric(metric).run_options[:output_directory] ||
        begin
          metric_directory = MetricFu::Io::FileSystem.scratch_directory(metric)
          FileUtils.mkdir_p(metric_directory, :verbose => false)
        end
    end

    # @return [String]
    # The path of the metric directory this class is using.
    def metric_directory
      self.class.metric_directory
    end

    def remove_excluded_files(paths, globs_to_remove = MetricFu::Io::FileSystem.file_globs_to_ignore)
      files_to_remove = []
      globs_to_remove.each do |glob|
        files_to_remove.concat(Dir[glob])
      end
      paths - files_to_remove
    end

    # Defines some hook methods for the concrete classes to hook into.
    %w[emit analyze].each do |meth|
      define_method("before_#{meth}".to_sym) {}
      define_method("after_#{meth}".to_sym) {}
    end
    define_method("before_to_h".to_sym) {}

    # Provides a template method to drive the production of a metric
    # from a concrete implementation of this class.  Each concrete
    # class must implement the three methods that this template method
    # calls: #emit, #analyze and #to_h.  For more details, see the
    # class documentation.
    #
    # This template method also calls before_emit, after_emit... etc.
    # methods to allow extra hooks into the processing methods, and help
    # to keep the logic of your Generators clean.
    def generate_result
      mf_debug "Executing #{self.class.to_s.gsub(/.*::/, '')}"

      %w[emit analyze].each do |meth|
        send("before_#{meth}".to_sym)
        send("#{meth}".to_sym)
        send("after_#{meth}".to_sym)
      end
      before_to_h()
      to_h()
    end

    def round_to_tenths(decimal)
      decimal = 0.0 if decimal.to_s.eql?('NaN')
      (decimal * 10).round / 10.0
    end

    def emit #:nodoc:
      raise <<-EOF
        This method must be implemented by a concrete class descending
        from Generator.  See generator class documentation for more
        information.
      EOF
    end

    def analyze #:nodoc:
      raise <<-EOF
        This method must be implemented by a concrete class descending
        from Generator.  See generator class documentation for more
        information.
      EOF
    end

    def to_h #:nodoc:
      raise <<-EOF
        This method must be implemented by a concrete class descending
        from Generator.  See generator class documentation for more
        information.
      EOF
    end
  end
end
