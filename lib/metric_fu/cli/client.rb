require "metric_fu"
require "metric_fu/cli/helper"
require "metric_fu/cli/parser"
module MetricFu
  module Cli
    class Client
      def initialize
        @helper = MetricFu::Cli::Helper.new
      end

      def shutdown
        @helper.shutdown
      end

      def run(argv = ARGV.dup)
        options =  @helper.process_options(argv)
        mf_debug "Got options #{options.inspect}"
        if options[:run]
          @helper.run(options)
        else
          STDOUT.puts @helper.usage
        end
      end
    end
  end
end
