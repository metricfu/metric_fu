MetricFu.data_structures_require { "sexp_node" }
module MetricFu
  class LineNumbers
    attr_reader :file_path

    # Parses ruby code to collect line numbers for class, module, and method definitions.
    # Used by metrics that don't provide line numbers for class, module, or methods problems
    # @param contents [String] a string of ruby code
    # @param file_path [String] the file path for the contents, defaults to empty string
    def initialize(contents, file_path = "")
      @file_path = file_path
      @locations = {}
      if contents.to_s.size.zero?
        mf_log "NON PARSEABLE INPUT: File is empty at path #{file_path.inspect}\n\t#{caller.join("\n\t")}"
      else
        parse_code(contents)
      end
    end

    # @param line_number [Integer]
    # @return [Boolean] if the given line number is in a method
    def in_method?(line_number)
      not method_at_line(line_number) == :no_method_at_line
    end

    # @param line_number [Integer]
    # @return [String, nil] the method which includes that line number, if any
    # For all collected locations, find the first location
    #   where the line_number_range includes the line_number.
    #   If a location is found, return the method name (first element)
    #   Else return :no_method_at_line
    def method_at_line(line_number)
      default_proc = -> { [:no_method_at_line] }
      @locations.detect(default_proc) do |_method_name, line_number_range|
        line_number_range.include?(line_number)
      end.first
    end

    # @param method [String] the method name being queried
    # @return [Integer, nil] the line number at which the given method is defined
    def start_line_for_method(method)
      return nil unless @locations.has_key?(method)
      @locations[method].first
    end

    private

    def parse_code(contents)
      file_sexp = MetricFu::SexpNode.parse(contents)
      file_sexp && process_ast(file_sexp)
    rescue => e
      # catch errors for files ruby_parser fails on
      mf_log "RUBY PARSE FAILURE: #{e.class}\t#{e.message}\tFILE:#{file_path}\tSEXP:#{file_sexp.inspect}\n\tCONTENT:#{contents.inspect}\n\t#{e.backtrace}"
    end

    def process_ast(file_sexp)
      node = MetricFu::SexpNode.new(file_sexp)
      case node.node_type
      when nil
        mf_log "No ruby code found in #{file_path}"
      when :class
        process_class(node)
      when :module
        process_module(node)
      else
        mf_debug "SEXP: Parsing line numbers for classes in sexp type #{node.node_type.inspect}"
        mf_debug "      in #{file_path}"
        node.each_module { |child_node| process_class(child_node) }
        node.each_class  { |child_node| process_class(child_node) }
      end
    end

    def process_module(module_node)
      module_name = module_node.name
      module_node.each_class do |class_node|
        process_class(class_node, module_name)
        class_node.hide_methods_from_next_round
      end
      process_class(module_node)
    end

    def process_class(class_node, module_name = nil)
      class_name = class_node.name
      process_singleton_methods(class_node, class_name)
      process_instance_methods(class_node, class_name, module_name)
      process_class_methods(class_node, class_name, module_name)
    end

    def process_singleton_methods(class_node, class_name)
      class_node.each_singleton_class do |singleton_node|
        singleton_node.each_singleton_method do |singleton_method_node|
          singleton_method_name = singleton_method_node.full_name(class_name)
          @locations[singleton_method_name] = singleton_method_node.line_range
        end
      end
    end

    def process_instance_methods(class_node, class_name, module_name)
      class_node.each_instance_method do |instance_method_node|
        instance_method_name = instance_method_node.full_name(module_name, class_name)
        @locations[instance_method_name] = instance_method_node.line_range
      end
    end

    def process_class_methods(class_node, class_name, module_name)
      class_node.each_class_method do |class_method_node|
        class_method_name = class_method_node.full_name(module_name, class_name)
        @locations[class_method_name] = class_method_node.line_range
      end
    end
  end
end
