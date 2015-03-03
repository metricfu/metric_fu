MetricFu.metrics_require { "cane/violations" }
module MetricFu
  class CaneGenerator < Generator
    attr_reader :violations, :total_violations

    def self.metric
      :cane
    end

    def emit
      args =  [
        abc_max_param,
        style_measure_param,
        no_doc_param,
        no_readme_param
      ].join
      @output = run!(args)
    end

    def analyze
      @violations = violations_by_category
      extract_total_violations
    end

    def to_h
      { cane: { total_violations: @total_violations, violations: @violations } }
    end

    private

    def abc_max_param
      options[:abc_max] ? " --abc-max #{options[:abc_max]}" : ""
    end

    def style_measure_param
      options[:line_length] ? " --style-measure #{options[:line_length]}" : ""
    end

    def no_doc_param
      options[:no_doc] == "y" ? " --no-doc" : ""
    end

    def no_readme_param
      options[:no_readme] == "y" ? " --no-readme" : ""
    end

    def violations_by_category
      violations_output = @output.scan(/(.*?)\n\n(.*?)\n\n/m)
      violations_output.each_with_object({}) do |(category_desc, violation_list), violations|
        category = category_from(category_desc) || :others
        violations[category] ||= []
        violations[category] += violations_for(category, violation_list)
      end
    end

    def category_from(description)
      category_descriptions = {
        abc_complexity: /ABC complexity/,
        line_style: /style requirements/,
        comment: /comment/,
        documentation: /documentation/
      }
      category, desc_matcher = category_descriptions.find { |_k, v| description =~ v }
      mf_debug desc_matcher.inspect
      category
    end

    def violations_for(category, violation_list)
      violation_type_for(category).parse(violation_list)
    end

    def violation_type_for(category)
      case category
      when :abc_complexity
        CaneViolations::AbcComplexity
      when :line_style
        CaneViolations::LineStyle
      when :comment
        CaneViolations::Comment
      when :documentation
        CaneViolations::Documentation
      else
        CaneViolations::Others
      end
    end

    def extract_total_violations
      if @output =~ /Total Violations: (\d+)/
        @total_violations = $1.to_i
      else
        @total_violations = 0
      end
    end
  end
end
