module MetricFu
  class HotspotAnalyzedProblems
    MetricFu.metrics_require   { "hotspots/analysis/ranked_problem_location" }

    def initialize(hotspot_rankings, analyzer_tables)
      @hotspot_rankings = hotspot_rankings
      @analyzer_tables = analyzer_tables
    end

    def worst_items
      worst_items = {}
      worst_items[:files]   = worst(@hotspot_rankings.worst_files,   :file)
      worst_items[:classes] = worst(@hotspot_rankings.worst_classes, :class)
      worst_items[:methods] = worst(@hotspot_rankings.worst_methods, :method)
      worst_items
    end

    private

    # @param rankings [Array<MetricFu::HotspotRankings>]
    # @param granularity [Symbol] one of :class, :method, :file
    def worst(rankings, granularity)
      rankings.map do |ranked_item_name|
        sub_table = get_sub_table(granularity, ranked_item_name)
        MetricFu::HotspotRankedProblemLocation.new(sub_table, granularity)
      end
    end

    def get_sub_table(granularity, ranked_item_name)
      tables = @analyzer_tables.tables_for(granularity)
      tables[ranked_item_name]
    end
  end
end
