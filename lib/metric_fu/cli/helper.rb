require "metric_fu"
require "metric_fu/cli/parser"
MetricFu.lib_require { "run" }
# see https://github.com/grosser/pru/blob/master/bin/pru
module MetricFu
  module Cli
    def self.immediate_shutdown!
      exit(1)
    end
    def self.complete!
      exit(0)
    end
    class Helper
      def initialize
        @metric_fu = MetricFu::Run.new
      end

      def run(options = {})
        @metric_fu.run(options)
        complete
      end

      def version
        MetricFu::VERSION
      end

      def shutdown
        out "\nShutting down. Bye"
        MetricFu::Cli.immediate_shutdown!
      end

      def banner
        "MetricFu: A Fistful of code metrics"
      end

      def usage
        <<-EOS
        #{banner}
        Use --help for help
        EOS
      end

      def executable_name
        "metric_fu"
      end

      def metrics
        MetricFu::Metric.metrics.map(&:name).sort_by(&:to_s)
      end

      def process_options(argv = [])
        options = MetricFu::Cli::MicroOptParse::Parser.new do |p|
          p.banner = banner
          p.version = version
          p.option :run, "Run all metrics with defaults", default: true
          metrics.each do |metric|
            p.option metric.to_sym, "Enables or disables #{metric}", default: true # , :value_in_set => [true, false]
          end
          p.option :open, "Open report in browser (if supported by formatter)", default: true
        end.process!(argv)
        options
      end

      private

      def out(text)
        STDOUT.puts text
      end

      def error(text)
        STDERR.puts text
      end

      def complete
        out "all done"
        MetricFu::Cli.complete!
      end
    end
  end
end
