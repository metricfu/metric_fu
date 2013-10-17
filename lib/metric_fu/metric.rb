require 'set'
# Encapsulates the configuration options for each metric
module MetricFu
  class Metric

    attr_accessor :enabled, :activated

    def initialize
      self.enabled = false
      @libraries = Set.new
      @configured_run_options = {}
    end

    def enable
      self.enabled = true
    end

    # TODO: Confirm this catches load errors from requires in subclasses, such as for flog
    def activate
      @libraries.each {|library| require(library) }
      self.activated = true
    rescue LoadError => e
      mf_log "#{name} metric not activated, #{e.message}"
    end

    # @return metric name [Symbol]
    def name
      not_implemented
    end

    # @return metric run options [Hash]
    def run_options
      default_run_options.merge(configured_run_options)
    end

    def configured_run_options
      @configured_run_options
    end

    # @return default metric run options [Hash]
    def default_run_options
      not_implemented
    end

    # @return metric_options [Hash]
    def has_graph?
      not_implemented
    end

    @metrics = []
    # @return all subclassed metrics [Array<MetricFu::Metric>]
    # ensure :hotspots runs last
    def self.metrics
      @metrics
    end

    def self.enabled_metrics
      metrics.select{|metric| metric.enabled && metric.activated}.sort_by {|metric| metric.name  == :hotspots ? 1 : 0 }
    end

    def self.get_metric(name)
      metrics.find{|metric|metric.name.to_s == name.to_s}
    end

    def self.inherited(subclass)
      @metrics << subclass.new
    end

    protected

    # Enable using a syntax such as metric.foo = 'foo'
    #   by catching the missing method here,
    #   checking if :foo is a key in the default_run_options, and
    #   setting the key/value in the @configured_run_options hash
    # TODO: See if we can do this without a method_missing
    def method_missing(method, *args)
      key = method_to_attr(method)
      if default_run_options.has_key?(key)
        configured_run_options[key] = args.first
      else
        raise "#{key} is not a valid configuration option"
      end
    end

    # Used above to identify the stem of a setter method
    def method_to_attr(method)
      method.to_s.sub(/=$/, '').to_sym
    end

    private

    def not_implemented
      raise "Required method #{caller[0]} not implemented in #{__FILE__}"
    end

    def activate_library(file)
      @libraries << file.strip
    end

  end
end
