MetricFu.lib_require { "formatter/syntax" }
MetricFu.lib_require { "templates/template" }

# Creates an HTML document for a given analyzed file,
# with scored metrics annotating the relevant line.
module MetricFu
  module Templates
    class Report < MetricFu::Template
      # @param file [String] the analyzed file to annotate
      # @param lines [Hash] of line number [String] keyed to an list [[Array] of metrics for that line. Each metric in the list is a hash containing the keys :type => metric_name, :descrption => metric_score
      # @example file and lines
      #   file: "lib/metric_fu/gem_version.rb
      #   lines: {"30"=>[{:type=>:flog, :description=>"Score of 22.43"}], "42"=>[{:type=>:flog, :description=>"Score of 8.64"}]}
      def initialize(file, lines)
        @file = file
        @lines = lines
        @data = File.open(file, "rb") { |f| f.readlines }
      end

      def render
        erbify("report")
      end

      def convert_ruby_to_html(ruby_text, line_number)
        MetricFu::Formatter::Syntax.new.highlight(ruby_text, line_number)
      end

      def line_for_display(line, line_number)
        if MetricFu::Formatter::Templates.option("syntax_highlighting")
          line_for_display = convert_ruby_to_html(line, line_number)
        else
          "<a name='n#{line_number}' href='n#{line_number}'>#{line_number}</a>#{line}"
       end
      end

      def template_directory
        File.dirname(__FILE__)
      end
    end
  end
end
