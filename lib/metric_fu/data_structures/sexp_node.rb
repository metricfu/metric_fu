require "ruby_parser"
module MetricFu
  SexpNode = Struct.new(:sexp) do
    # @return file_sexp
    def self.parse(contents)
      rp = RubyParser.new
      rp.parse(contents)
    end
    def nil?
      sexp.nil?
    end

    def node_type
      sexp[0]
    end

    def name
      sexp[1]
    end

    def each_of_type(type, node_class = SexpNode)
      sexp.each_of_type(type) do |child_sexp|
        yield node_class.new(child_sexp)
      end
    end

    def each_module(&block)
      each_of_type(:module, &block)
    end

    def each_class(&block)
      each_of_type(:class, &block)
    end

    def each_singleton_class(&block)
      each_of_type(:sclass, SingletonMethodNode, &block)
    end

    def each_instance_method(&block)
      each_of_type(:defn, InstanceMethodNode, &block)
    end

    def each_class_method(&block)
      each_of_type(:defs, ClassMethodNode, &block)
    end

    def first_line
      sexp.line
    end

    def last_line
      sexp.last.line
    end

    def line_range
      (first_line..last_line)
    end

    def hide_methods_from_next_round
      sexp.find_and_replace_all(:defn, :ignore_me)
      sexp.find_and_replace_all(:defs, :ignore_me)
    end

    def full_method_name(method_separator, class_name, module_name = nil)
      [module_namespace(module_name), class_name, method_separator, name].join
    end

    def module_namespace(module_name = nil)
      if module_name.nil?
        nil
      else
        [module_name, class_method_separator].join
      end
    end

    def instance_method_separator
      "#"
    end

    def class_method_separator
      "::"
    end
  end
  class ClassMethodNode < SexpNode
    def name
      sexp[2]
    end

    def full_name(module_name, class_name)
      full_method_name(class_method_separator, class_name, module_name)
    end
  end
  class InstanceMethodNode < SexpNode
    def full_name(module_name, class_name)
      full_method_name(instance_method_separator, class_name, module_name)
    end
  end
  class SingletonMethodNode < SexpNode
    def full_name(class_name)
      full_method_name(class_method_separator, class_name)
    end

    def each_singleton_method(&block)
      each_of_type(:defn, SingletonMethodNode, &block)
    end
  end
end
