MetricFu.configure
module MetricFu
  class Run
    def initialize
      STDOUT.sync = true
      load_user_configuration
    end
    def run(options={})
      configure_run(options)
      measure
      display_results if options[:open]
    end

    # ensure :hotspots runs last
    def report_metrics(metrics=MetricFu.metrics)
      MetricFu.configuration.metrics.sort_by! {|x| x == :hotspots ? 1 : 0 }
      MetricFu.configuration.metrics
    end
    def measure
      reporter.start
      report_metrics.each {|metric|
        reporter.start_metric(metric)
        MetricFu.result.add(metric)
        reporter.finish_metric(metric)
      }
      reporter.finish
    end
    def display_results
      reporter.display_results
    end
    private
    def load_user_configuration
      file = File.join(Dir.pwd, '.metrics')
      load file if File.exist?(file)
    end
    # Updates configuration based on runtime options.
    def configure_run(options)
      disable_metrics(options)
      configure_formatters(options)
    end
    def disable_metrics(options)
      return if options.size == 0
      report_metrics.each do |metric|
        if options[metric.to_sym]
          mf_debug "using metric #{metric}"
        else
          mf_debug "disabling metric #{metric}"
          MetricFu.configuration.metrics -= [ metric ]
          MetricFu.configuration.graphs -= [ metric ]
          mf_debug "active metrics are #{MetricFu.configuration.metrics.inspect}"
        end
      end
    end
    def configure_formatters(options)
      # Configure from command line if any.
      if options[:format]
        MetricFu.formatters.clear # Command-line format takes precedence.
        Array(options[:format]).each do |format, o|
          MetricFu.configuration.add_formatter(format, o)
        end
      end
      # If no formatters specified, use defaults.
      if MetricFu.configuration.formatters.empty?
        Array(MetricFu::Formatter::DEFAULT).each do |format, o|
          MetricFu.configuration.add_formatter(format, o)
        end
      end
    end
    def reporter
      Reporter.new(MetricFu.configuration.formatters)
    end
  end
end
