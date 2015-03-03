require "set"
MetricFu.lib_require { "gem_run" }
MetricFu.lib_require { "generator" }
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
      MetricFu.metrics_require { default_metric_library_paths }
      @libraries.each { |library| require(library) }
      self.activated = true
    rescue LoadError => e
      mf_log "#{name} metric not activated, #{e.message}"
    end

    # @return metric name [Symbol]
    def name
      not_implemented
    end

    def gem_name
      name
    end

    # @return metric run options [Hash]
    def run_options
      default_run_options.merge(configured_run_options)
    end

    def default_run_args
      run_options.map { |k, v| "--#{k} #{v}" }.join(" ")
    end

    def run
      not_implemented
    end

    def run_external(args = default_run_args)
      runner = GemRun.new(
        gem_name: gem_name.to_s,
        metric_name: name.to_s,
        # version: ,
        args: args,
      )
      stdout, stderr, status = runner.run
      # TODO: do something with the stderr
      # for now, just acknowledge we got it
      unless stderr.empty?
        STDERR.puts "STDERR from #{gem_name}:\n#{stderr}"
      end
      # TODO: status.success? is not reliable for distinguishing
      # between a successful run of the metric and problems
      # found by the metric. Talk to other metrics about this.
      MetricFu.logger.debug "#{gem_name} ran with #{status.success? ? 'success' : 'failure'} code #{status.exitstatus}"
      stdout
    end

    def configured_run_options
      @configured_run_options
    end

    # @return [Hash] default metric run options
    def default_run_options
      not_implemented
    end

    # @return [Hash] metric_options
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
      metrics.select { |metric| metric.enabled && metric.activated }.sort_by { |metric| metric.name  == :hotspots ? 1 : 0 }
    end

    def self.get_metric(name)
      metrics.find { |metric|metric.name.to_s == name.to_s }
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
      method.to_s.sub(/=$/, "").to_sym
    end

    private

    def not_implemented
      raise "Required method #{caller[0]} not implemented in #{__FILE__}"
    end

    def activate_library(file)
      @libraries << file.strip
    end

    def default_metric_library_paths
      paths = []
      paths << generator_path = "#{name}/generator"
      if has_graph?
        paths << grapher_path   = "#{name}/grapher"
      end
      paths
    end
  end
end
