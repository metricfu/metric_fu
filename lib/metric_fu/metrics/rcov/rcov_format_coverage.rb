module MetricFu
  class RCovFormatCoverage
    NEW_FILE_MARKER = /^={80}$/.freeze

    def initialize(rcov_text)
      fail "no rcov text" if rcov_text.nil?
      @rcov_text = rcov_text
    end

    def to_h
      rcov_text = @rcov_text.split(NEW_FILE_MARKER)

      rcov_text.shift # Throw away the first entry - it's the execution time etc.

      files = assemble_files(rcov_text)

      TestCoverage.new(files).to_h
    end

    private

    def assemble_files(rcov_text)
      files = {}
      rcov_text.each_slice(2) { |out| files[out.first.strip] = out.last }
      files.each_pair { |fname, content| files[fname] = content.split("\n") }
      files.each_pair do |fname, content|
        content.map! do |raw_line|
          covered_line = if raw_line.start_with?("--")
                           nil # simplecov ignores some lines
                         elsif raw_line.start_with?("!!")
                           0
                         else
                           1
                         end
          RCovLine.new(raw_line[3..-1], covered_line).to_h
        end
        content.reject! { |line| line[:content].to_s == "" }
        files[fname] = { lines: content }
      end
      files
    end

    class TestCoverage
      def initialize(filename_content)
        @files = filename_content
        @global_total_lines = 0
        @global_total_lines_run = 0
      end

      def to_h
        @test_coverage ||= begin
          add_coverage_percentage(@files)
          add_method_data(@files)
          add_global_percent_run(@files, @global_total_lines, @global_total_lines_run)
          @files
        end
      end

      def self.floating_percent(numerator, denominator)
        (numerator * 100.0) / denominator.to_f
      end

      def self.integer_percent(numerator, denominator)
        ::MetricFu::Calculate.integer_percent(numerator, denominator)
      end

      def self.percent_run(lines)
        line_coverage = RCovLine.line_coverage(lines)
        covered_lines = RCovLine.covered_lines(line_coverage)
        ignored_lines = RCovLine.ignored_lines(line_coverage)
        relevant_lines = lines.count - ignored_lines
        if block_given?
          yield covered_lines, relevant_lines
        else
          floating_percent(covered_lines, relevant_lines)
        end
      end

      private

      # TODO: remove multiple side effects
      #   sets global ivars and
      #   modifies the param passed in
      def add_coverage_percentage(files)
        files.each_pair do |fname, content|
          lines = content[:lines]
          percent_run =
            self.class.percent_run(lines) do |covered, relevant|
              @global_total_lines_run += covered
              @global_total_lines += relevant
              self.class.integer_percent(covered, relevant)
            end
          files[fname][:percent_run] = percent_run
        end
      end

      def add_global_percent_run(test_coverage, total_lines, total_lines_run)
        percentage = self.class.floating_percent(total_lines_run, total_lines)
        test_coverage.update(
          global_percent_run: round_to_tenths(percentage)
        )
      end

      def add_method_data(test_coverage)
        test_coverage.each_pair do |file_path, info|
          file_contents = ""
          coverage = []

          info[:lines].each_with_index do |line, _index|
            file_contents << "#{line[:content]}\n"
            coverage << line[:was_run]
          end

          begin
            line_numbers = MetricFu::LineNumbers.new(file_contents)
          rescue StandardError => e
            raise e unless e.message =~ /you shouldn't be able to get here/
            mf_log "ruby_parser blew up while trying to parse #{file_path}. You won't have method level TestCoverage information for this file."
            next
          end

          method_coverage_map = {}
          coverage.each_with_index do |covered, index|
            line_number = index + 1
            if line_numbers.in_method?(line_number)
              method_name = line_numbers.method_at_line(line_number)
              method_coverage_map[method_name] ||= {}
              method_coverage_map[method_name][:total] ||= 0
              method_coverage_map[method_name][:total] += 1
              method_coverage_map[method_name][:uncovered] ||= 0
              method_coverage_map[method_name][:uncovered] += 1 if !covered
            end
          end

          test_coverage[file_path][:methods] = {}

          method_coverage_map.each do |method_name, coverage_data|
            test_coverage[file_path][:methods][method_name] = (coverage_data[:uncovered] / coverage_data[:total].to_f) * 100.0
          end
        end
      end

      def round_to_tenths(decimal)
        decimal = 0.0 if decimal.to_s.eql?("NaN")
        (decimal * 10).round / 10.0
      end
    end
  end
end
