# MetricFu::LineNumber
# (see #initialize)
require 'ruby_parser'
module MetricFu
  class LineNumbers

    # Parses ruby code to collect line numbers for class, module, and method definitions.
    # Used by metrics that don't provide line numbers for class, module, or methods problems
    # @param contents [String] a string of ruby code
    # @param file_path [String] the file path for the contents, defaults to empty string
    def initialize(contents,file_path='')
      if contents.to_s.size.zero?
        mf_log "NON PARSEABLE INPUT: File is empty at path #{file_path.inspect}\n\t#{caller.join("\n\t")}"
      else
        rp = RubyParser.new
        @locations = {}
        file_sexp = rp.parse(contents)
        case file_sexp[0]
        when nil
          mf_log "No ruby code found in #{file_path}"
        when :class
          process_class(file_sexp)
        when :module
          process_module(file_sexp)
        else
          mf_debug "SEXP: Parsing line numbers for classes in sexp type #{file_sexp[0].inspect}"
          mf_debug "      in #{file_path}"
          file_sexp.each_of_type(:module) { |sexp| process_class(sexp) }
          file_sexp.each_of_type(:class)  { |sexp| process_class(sexp) }
        end
      end
    rescue Exception => e
      #catch errors for files ruby_parser fails on
      mf_log "RUBY PARSE FAILURE: #{e.class}\t#{e.message}\tFILE:#{file_path}\tSEXP:#{file_sexp.inspect}\n\tCONTENT:#{contents.inspect}\n\t#{e.backtrace}"
      @locations
    end

    # @param line_number [String]
    # @return [Boolean] if the given line number is in a method
    def in_method? line_number
      !!@locations.detect do |method_name, line_number_range|
        line_number_range.include?(line_number)
      end
    end

    # @param line_number [Integer]
    # @return [String, nil] the method which includes that line number, if any
    # For all collected locations, find the first location where the line_number_range
    #   includes the line_number
    #   If a location is found, return its first element
    #   Else return nil
    def method_at_line line_number
      found_method_and_range = @locations.detect do |method_name, line_number_range|
        line_number_range.include?(line_number)
      end
      if found_method_and_range
        found_method_and_range.first
      else
        nil
      end
    end

    # @param method [String] the method name being queried
    # @erturn [Integer, nil] the line number at which the given method is defined
    def start_line_for_method(method)
      return nil unless @locations.has_key?(method)
      @locations[method].first
    end

    private

    def process_module(sexp)
      module_name = sexp[1]
      sexp.each_of_type(:class) do |exp|
        process_class(exp, module_name)
        hide_methods_from_next_round(exp)
      end
      process_class(sexp)
    end

    def process_class(sexp, module_name=nil)
      class_name = sexp[1]
      process_class_self_blocks(sexp, class_name)
      module_name_string = module_name ? "#{module_name}::" : nil
      sexp.each_of_type(:defn) { |s| @locations["#{module_name_string}#{class_name}##{s[1]}"] = (s.line)..(s.last.line) }
      sexp.each_of_type(:defs) { |s| @locations["#{module_name_string}#{class_name}::#{s[2]}"] = (s.line)..(s.last.line) }
    end

    def process_class_self_blocks(sexp, class_name)
      sexp.each_of_type(:sclass) do |sexp_in_class_self_block|
        sexp_in_class_self_block.each_of_type(:defn) { |s| @locations["#{class_name}::#{s[1]}"] = (s.line)..(s.last.line) }
        hide_methods_from_next_round(sexp_in_class_self_block)
      end
    end

    def hide_methods_from_next_round(sexp)
      sexp.find_and_replace_all(:defn, :ignore_me)
      sexp.find_and_replace_all(:defs, :ignore_me)
    end

  end
end
