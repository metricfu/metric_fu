require 'cane'

module MetricFu
  class Cane < Generator
    attr_reader :violations, :total_violations

    def emit
      command = %Q{mf-cane#{abc_max_param}#{style_measure_param}#{no_doc_param}}
      mf_debug = "** #{command}"
      @output = `#{command}`
    end

    def analyze
      @violations = violations_by_category
      extract_total_violations
    end

    def to_h
      {:cane => {:total_violations => @total_violations, :violations => @violations}}
    end
    private

    def abc_max_param
      MetricFu.cane[:abc_max] ? " --abc-max #{MetricFu.cane[:abc_max]}" : ""
    end

    def style_measure_param
      MetricFu.cane[:line_length] ? " --style-measure #{MetricFu.cane[:line_length]}" : ""
    end

    def no_doc_param
      MetricFu.cane[:no_doc] == 'y' ? " --no-doc" : ""
    end

    def violations_by_category
      violations_output = @output.scan(/(.*?)\n\n(.*?)\n\n/m)
      violations_output.each_with_object({}) do |(category_desc, violation_list), violations|
        category = category_from(category_desc)
        violations[category] = violations_for(category, violation_list)
      end
    end

    def category_from(description)
      category_descriptions = {
        :abc_complexity => /ABC complexity/,
        :line_style => /style requirements/,
        :comment => /comment/
      }
      category_descriptions.find {|k,v| description =~ v}[0]
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
      end
    end

    def extract_total_violations
      total = @output.match(/Total Violations: (\d+)/)[1]
      @total_violations = total.to_i if total
    end
  end
end
