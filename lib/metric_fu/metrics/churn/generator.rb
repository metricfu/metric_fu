module MetricFu
  class ChurnGenerator < Generator
    def self.metric
      :churn
    end

    ###
    # options available are what can be passed to churn_calculator
    # https://github.com/danmayer/churn#library-options
    ###
    def emit
      @output = run(options)
    end

    def analyze
      if @output.nil? || @output.size.zero?
        @churn = { churn: {} }
      else
        @churn = @output
      end
      @churn
    end

    # ensure hash only has the :churn key
    def to_h
      { churn: @churn[:churn] }
    end

    # @param args [Hash] churn metric run options
    # @return [Hash] churn results
    def run(args)
      # @note passing in false to report will return a hash
      #    instead of the default String
      ::Churn::ChurnCalculator.new(args).report(false)
    end
  end
end
