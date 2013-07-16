module MetricFu
  class Grapher
    attr_accessor :output_directory

    def initialize(opts = {})
      self.class.require_graphing_gem
      self.output_directory = opts[:output_directory]
    end

    def output_directory
      @output_directory || MetricFu.output_directory
    end

    def self.require_graphing_gem
      # to be overridden by charting engines
    end
  end
end
