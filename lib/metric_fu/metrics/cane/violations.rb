module MetricFu
  module CaneViolations
    class AbcComplexity
      def self.parse(violation_list)
        violation_list.split(/\n/).map do |violation|
          file, method, complexity = violation.split
          { file: file, method: method, complexity: complexity }
        end
      end
    end

    class LineStyle
      def self.parse(violation_list)
        violation_list.split(/\n/).map do |violation|
          line, description = violation.split(/\s{2,}/).reject { |x|x.strip == "" }
          { line: line, description: description }
        end
      end
    end

    class Comment
      def self.parse(violation_list)
        violation_list.split(/\n/).map do |violation|
          line, class_name = violation.split
          { line: line, class_name: class_name }
        end
      end
    end

    class Documentation
      def self.parse(violation_list)
        violation_list.split(/\n/).map do |violation|
          { description: violation.strip }
        end
      end
    end

    class Others
      def self.parse(violation_list)
        violation_list.split(/\n/).map do |violation|
          { description: violation.strip }
        end
      end
    end
  end
end
