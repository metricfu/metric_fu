require "yaml"
MetricFu.metrics_require do
  [
    "hotspots/hotspot",
    "hotspots/analysis/analyzer_tables",
    "hotspots/analysis/analyzed_problems",
    "hotspots/analysis/rankings"
  ]
end

module MetricFu
  class HotspotAnalyzer
    COMMON_COLUMNS = %w{metric}
    GRANULARITIES =  %w{file_path class_name method_name}

    def tool_analyzers
      MetricFu::Hotspot.analyzers
    end

    def initialize(result_hash)
      # we can't depend on the result
      # returning a parsed yaml file as a hash?
      result_hash = YAML::load(result_hash) if result_hash.is_a?(String)
      setup(result_hash)
    end

    def hotspots
      analyzed_problems.worst_items
    end

    def analyzed_problems
      @analyzed_problems = MetricFu::HotspotAnalyzedProblems.new(@rankings, @analyzer_tables)
    end

    private

    # TODO clarify each of these steps in setup
    # extract into its own method
    # remove unnecessary constants,
    # turn into methods
    def setup(result_hash)
      # TODO There is likely a clash that will happen between
      # column names eventually. We should probably auto-prefix
      # them (e.g. "roodi_problem")
      analyzer_columns = COMMON_COLUMNS + GRANULARITIES + tool_analyzers.map(&:columns).flatten
      # though the tool_analyzers aren't returned, they are processed in
      # various places here, then by the analyzer tables
      # then by the rankings
      # to ultimately generate the hotspots
      @analyzer_tables = MetricFu::AnalyzerTables.new(analyzer_columns)
      tool_analyzers.each do |analyzer|
        analyzer.generate_records(result_hash[analyzer.name], @analyzer_tables.table)
      end
      @analyzer_tables.generate_records
      @rankings = MetricFu::HotspotRankings.new(@analyzer_tables.tool_tables)
      @rankings.calculate_scores(tool_analyzers, GRANULARITIES)
      # TODO does it not need to return something here?
      analyzed_problems
    end
  end
end
