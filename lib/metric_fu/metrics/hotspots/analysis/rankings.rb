MetricFu.metrics_require do
  [
    "hotspots/analysis/ranking"
  ]
end
module MetricFu
  class HotspotRankings
    def initialize(tool_tables)
      @tool_tables = tool_tables
      @file_ranking = MetricFu::Ranking.new
      @class_ranking = MetricFu::Ranking.new
      @method_ranking = MetricFu::Ranking.new
    end

    def calculate_scores(tool_analyzers, granularities)
      tool_analyzers.each do |analyzer|
        calculate_scores_by_granularities(analyzer, granularities)
      end
    end

    def worst_methods
      @method_ranking.delete(nil)
      @method_ranking.top
    end

    def worst_classes
      @class_ranking.delete(nil)
      @class_ranking.top
    end

    def worst_files
      @file_ranking.delete(nil)
      @file_ranking.top
    end

    private

    def calculate_scores_by_granularities(analyzer, granularities)
      granularities.each do |granularity|
        calculate_score_for_granularity(analyzer, granularity)
      end
    end

    def calculate_score_for_granularity(analyzer, granularity)
      metric_ranking = calculate_metric_scores(granularity, analyzer)

      add_to_master_ranking(
        ranking(granularity),
        metric_ranking,
        analyzer
      )
    end

    # CALCULATES METRIC HOTSPOT SCORES / RANKINGS PER map/reduce in HOTSPOT subclasses
    def calculate_metric_scores(granularity, analyzer)
      metric_ranking = MetricFu::Ranking.new
      metric_violations = @tool_tables[analyzer.name]
      metric_violations.each do |row|
        location = row[granularity]
        metric_ranking[location] ||= []
        metric_ranking[location] << analyzer.map(row)
      end

      metric_ranking.each do |item, scores|
        metric_ranking[item] = analyzer.reduce(scores)
      end

      metric_ranking
    end

    def ranking(column_name)
      case column_name
      when "file_path"
        @file_ranking
      when "class_name"
        @class_ranking
      when "method_name"
        @method_ranking
      else
        raise ArgumentError, "Invalid column name #{column_name}"
      end
    end

    def add_to_master_ranking(master_ranking, metric_ranking, analyzer)
      metric_ranking.each do |item, _|
        master_ranking[item] ||= 0
        master_ranking[item] += analyzer.score(metric_ranking, item) # scaling? Do we just add in the raw score?
      end
    end
  end
end
