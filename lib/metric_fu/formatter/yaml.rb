module MetricFu
  module Formatter
    class YAML
      include MetricFu::Io

      DEFAULT_PATH = "report.yml"

      def initialize(opts = {})
        @options = opts
        @path_or_io = @options[:output] || DEFAULT_PATH
      end

      def finish
        write_output(MetricFu.result.as_yaml, @path_or_io)
      end
    end
  end
end
