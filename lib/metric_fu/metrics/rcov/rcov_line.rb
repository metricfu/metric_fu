module MetricFu
  class RCovLine
    attr_accessor :content, :was_run

    def initialize(content, was_run)
      @content = content
      @was_run = was_run
    end

    def to_h
      { content: @content, was_run: @was_run }
    end

    def covered?
      @was_run == 1
    end

    def missed?
      @was_run == 0
    end

    def ignored?
      @was_run.nil?
    end

    def self.line_coverage(lines)
      lines.map { |line| line[:was_run] }
    end

    def self.covered_lines(line_coverage)
      line_coverage.count(1)
    end

    def self.missed_lines(line_coverage)
      line_coverage.count(0)
    end

    def self.ignored_lines(line_coverage)
      line_coverage.count(nil)
    end

    def css_class
      return "rcov_not_run" if missed?

      "rcov_run"
    end
  end
end
