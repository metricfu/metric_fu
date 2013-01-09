module MetricFu

  class Churn < Generator

    def initialize(options={})
      super
      @opts = command_line_options
    end

    def emit
      @output = command_line_call
      yaml_start = @output.index("---")
      @output = @output[yaml_start...@output.length] if yaml_start
    end

    def analyze
      if @output.match(/Churning requires a subversion or git repo/)
        @churn = [:churn => {}]
      else
        @churn = YAML::load(@output)
      end
    end

    def to_h
      {:churn => @churn[:churn]}
    end

    private
      def command_line_options
        opts = ["--yaml"]
        opts << "--minimum_churn_count=#{@options[:minimum_churn_count]}" if @options[:minimum_churn_count]

        opts.join(" ")
      end

      def command_line_call
        `churn #{@opts}`
      end
  end

end
