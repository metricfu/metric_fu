module MetricFu
  class StatsGenerator < Generator
    def self.metric
      :stats
    end

    def emit
      require "code_metrics/statistics"
      @output = MetricFu::Utility.capture_output do
        CodeMetrics::Statistics.new(*dirs).to_s
      end
    end

    def analyze
      lines = remove_noise(@output).compact

      @stats = {}

      set_global_stats(lines.pop)
      set_granular_stats(lines)

      @stats
    end

    def to_h
      { stats: @stats }
    end

    private

    def remove_noise(output)
      lines = output.split("\n")
      lines = lines.find_all { |line| line =~ /^\s*[C|]/ }
      lines.shift
      lines
    end

    def set_global_stats(totals)
      return if totals.nil?
      parsed_totals = totals.split("  ").find_all { |el| !el.empty? }
      @stats[:codeLOC] = parsed_totals.shift.match(/\d.*/)[0].to_i
      @stats[:testLOC] = parsed_totals.shift.match(/\d.*/)[0].to_i
      matched_numbers  = Array(parsed_totals.shift.match(/1\:(\d.*)/))
      if matched_numbers.size == 2
        @stats[:code_to_test_ratio] = matched_numbers[1].to_f
      else
        mf_log "Unexpected code to test ratio #{matched_numbers.inspect} over directories #{dirs.inspect}"
        @stats[:code_to_test_ratio] = 0.0
      end
    end

    def set_granular_stats(lines)
      @stats[:lines] = lines.map do |line|
        elements = line.split("|")
        elements.map!(&:strip)
        elements = elements.find_all { |el| !el.empty? }
        info_line = {}
        info_line[:name] = elements.shift
        elements.map!(&:to_i)
        [:lines, :loc, :classes, :methods,
         :methods_per_class, :loc_per_method].each do |sym|
          info_line[sym] = elements.shift
        end
        info_line
      end
    end

    # @return [Array<[ 'Acceptance specs', 'spec/acceptance' ]>]
    def dirs
      require "code_metrics/stats_directories"
      require "code_metrics/statistics"
      stats_dirs = CodeMetrics::StatsDirectories.new
      options.fetch(:additional_test_directories).each do |option|
        stats_dirs.add_test_directories(option.fetch(:glob_pattern), option.fetch(:file_pattern))
      end
      options.fetch(:additional_app_directories).each do |option|
        stats_dirs.add_directories(option.fetch(:glob_pattern), option.fetch(:file_pattern))
      end
      stats_dirs.directories
    end
  end
end
