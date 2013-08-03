# Encapsulates the configuration options for each metric
module MetricFu
  class Metric

    attr_accessor :enabled, :activated

    def initialize
      self.enabled = false
    end

    def enable
      self.enabled = true
    end

    def activate
      self.activated = true
    rescue LoadError
      MetricFu.configuration.mf_debug("#{name} library unavailable, not activated")
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
      @configured_run_options ||= {}
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

    def method_missing(method, *args)
      key = method_to_attr(method)
      if default_run_options.has_key?(key)
        configured_run_options[key] = args.first
      else
        raise "#{key} is not a valid configuration option"
      end
    end

    def method_to_attr(method)
      method.to_s.sub(/=$/, '').to_sym
    end

    private

    def not_implemented
      raise "Required method #{caller[0]} not implemented in #{__FILE__}"
    end

  end
end
