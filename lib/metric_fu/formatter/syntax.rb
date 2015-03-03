require "coderay"
MetricFu.lib_require { "utility" }
# CodeRay options
# used to analyze source code, because object Tokens is a list of tokens with specified types.
# :tab_width – tabulation width in spaces. Default: 8
# :css – how to include the styles (:class и :style). Default: :class)
#
# :wrap – wrap result in html tag :page, :div, :span or not to wrap (nil)
#
# :line_numbers – how render line numbers (:table, :inline, :list or nil)
#
# :line_number_start – first line number
#
# :bold_every – make every n-th line number bold. Default: 10
module MetricFu
  module Formatter
    class Syntax
      def initialize
        @options = { css: :class, style: :alpha }
        @line_number_options = { line_numbers: :inline, line_number_start: 0 }
      end

      def highlight(ruby_text, line_number)
        tokens = tokenize(ruby_text)
        tokens.div(highlight_options(line_number))
      end

      def highlight_options(line_number)
        line_number = line_number.to_i
        if line_number > 0
          @options.merge(@line_number_options.merge(line_number_start: line_number))
        else
          @options
        end
      end

      private

      def tokenize(ruby_text)
        ascii_text = MetricFu::Utility.clean_ascii_text(ruby_text)
        tokens = CodeRay.scan(ascii_text, :ruby)
      end
    end
  end
end
