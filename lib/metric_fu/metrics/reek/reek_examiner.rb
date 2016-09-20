module MetricFu
  module ReekExaminer
    def self.get
      require "reek"
      # To load any changing dependencies such as "reek/configuration/app_configuration"
      #   Added in 1.6.0 https://github.com/troessner/reek/commit/7f4ed2be442ca926e08ccc41945e909e8f710947
      #   But not always loaded
      require "reek/cli/application"

      klass = Reek.const_defined?(:Examiner) ? Reek.const_get(:Examiner) : Reek.const_get(:Core).const_get(:Examiner)

      case Gem::Version.new(Reek::Version::STRING).segments.first
        when 1, 2
          ReekExaminerV1.new(klass)
        when 3
          ReekExaminerV3.new(klass)
        else
          ReekExaminerV4.new(klass)
      end
    end

    class ReekExaminerV1
      def initialize(examiner)
        @examiner = examiner
      end

      def run!(files, config_files)
        @output = @examiner.new(files, config_files)
      end

      def analyze
        @output.smells.group_by(&:source).collect do |file_path, smells|
          { file_path: file_path,
            code_smells: analyze_smells(smells) }
        end
      end

      private

      def analyze_smells(smells)
        smells.collect(&method(:smell_data))
      end

      def smell_data(smell)
        { method: smell.context,
          message: smell.message,
          type: smell_type(smell),
          lines: smell.lines }
      end

      def smell_type(smell)
        return smell.subclass if smell.respond_to?(:subclass)
        smell.smell_type
      end

    end

    class ReekExaminerV3 < ReekExaminerV1
      def run!(files, config_files)
        @output = files.map { |file|
          @examiner.new(Pathname.new(file), config_files)
        }
      end

      def analyze
        @output.map(&:smells).flatten.group_by(&:source).collect do |file_path, smells|
          { file_path: file_path,
            code_smells: analyze_smells(smells) }
        end
      end
    end

    class ReekExaminerV4 < ReekExaminerV3
      def run!(files, config_files)
        @output = files.map { |file|
          @examiner.new(Pathname.new(file), filter_by_smells: config_files)
        }
      end
    end
  end
end
