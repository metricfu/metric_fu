require "metric_fu/constantize"
module MetricFu
  module Formatter
    BUILTIN_FORMATS = {
      "html" => ["MetricFu::Formatter::HTML", "Generates a templated HTML report using the configured template class and graph engine."],
      "yaml" => ["MetricFu::Formatter::YAML", "Generates the raw output as yaml"]
    }
    DEFAULT = [[:html]]

    class << self
      include MetricFu::Constantize

      def class_for(format)
        if (builtin = BUILTIN_FORMATS[format.to_s])
          constantize(builtin[0])
        else
          constantize(format.to_s)
        end
      end
    end

    module Templates
      MetricFu.lib_require { "templates/metrics_template" }

      module_function

      def templates_configuration=(templates_configuration)
        @templates_configuration = templates_configuration
      end

      def option(name)
        templates_configuration.option(name)
      end

      def templates_configuration
        @templates_configuration ||= MetricFu::Templates::Configuration.new
      end
    end
  end
end
