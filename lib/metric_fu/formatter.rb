require 'metric_fu/constantize'
module MetricFu
  module Formatter
    BUILTIN_FORMATS = {
      'html' => ['MetricFu::Formatter::HTML', 'Generates a templated HTML report using the configured template class and graph engine.'],
      'yaml' => ['MetricFu::Formatter::YAML', 'Generates the raw output as yaml']
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
      MetricFu.reporting_require { 'templates/awesome/awesome_template' }

      module_function

      def options
        @options ||= {}
      end
      def option(name)
        options.fetch(name) { raise "No such template option: #{name}" }
      end

      def configure_template(config)
        @options = {}
        @options['template_class'] = AwesomeTemplate
        @options['link_prefix'] = nil
        @options['darwin_txmt_protocol_no_thanks'] = true
        # # turning off syntax_highlighting may avoid some UTF-8 issues
        @options['syntax_highlighting'] = true
      end

    end
  end
end
