# Used to find which version, if any, of a gem to use when running command-line tools
module MetricFu
  module MetricVersion
    extend self

    # @return [Array] rcov version if running rcov
    # Rcov is not a dependency in the gemspec
    # but is available to be shelled out
    def rcov
      ['~> 0.8']
    end

    # @example MetricFu::MetricVersion.flog will return the gem version of Flog to require
    # @return [nil] when the metric_fu gem dependency isn't specified
    # @return [Array] represenation of the metric_fu gem dependency if specified
    #   in the gemspec.
    # Will raise method missing if :version_for is falsy
    # @see gems
    def method_missing(method,*args,&block)
      if (gem_version = version_for(method.to_s))
        gem_version != [] ? gem_version : nil
      else
        super
      end
    end

    private

    # Generates and returns an abstract syntax tree from the gemspec
    # @return [Sexp]
    def ast
      require 'ruby_parser'
      parser = RubyParser.new
      parser.parse(gemspec)
    end


    # Uses the ast to find all the specified runtime dependencies and their version requirements
    # @return Array<Array<gem_name,gem_version>>, where gem_name is a string and gem_version is an Array
    def gems
      @gems ||= ast.find{|node| node[0] == :iter}.
        find{|node| node[0] == :block}.                     # in the specification block
        select{|node| node[0] == :call }.                   # select all the methods
        select{|node| node[2] == :add_runtime_dependency }. # that are :add_runtime_dependency
        map{|node| [                                        # return a mapped array of
          node[3][1].downcase.sub('metric_fu-',''),         # the downcased gem name (with any metric_fu- prefix removed)
          Array(Array(node[4])[1..-1]).map{|node|node[1]}   #  and an Array of the specified gem version(s)
        ]}
    end

    # @return Array<String> where the strings are valid gem version requires
    #   The Array is empty if no gem version is specified
    def version_for(gem_name)
      node = gems.find{|node|node[0] == gem_name.downcase}  # find the gem in the ast with the given downcased name
      node && node[1]                                       # if found, return its version specification
    end

    # Read in the contents of the gemspec
    def gemspec
      File.read(File.expand_path('../../metric_fu.gemspec', __FILE__))
    end
  end
end
