require File.expand_path('analysis_error', MetricFu.errors_dir)
MetricFu.data_structures_require { 'location' }
%w(table record grouping ranking problems).each do |path|
  MetricFu.metrics_require   { "hotspots/analysis/#{path}" }
end
MetricFu.metrics_require   { 'hotspots/hotspot' }

module MetricFu
  class HotspotAnalyzer

    COMMON_COLUMNS = %w{metric}
    GRANULARITIES =  %w{file_path class_name method_name}

    # UNUSED
    # attr_accessor :table

    def tool_analyzers
      MetricFu::Hotspot.analyzers
    end

    def initialize(report_hash)
      # we can't depend on the Report
      # returning a parsed yaml file as a hash?
      report_hash = YAML::load(report_hash) if report_hash.is_a?(String)
      setup(report_hash)
    end

    # def worst_items
    def hotspots
      analyzed_problems.worst_items
    end
    # just for testing
    def analyzed_problems
      @analyzed_problems = MetricFu::HotspotAnalyzedProblems.new(@rankings, @analyzer_tables)
    end
    alias_method :worst_items, :hotspots
    extend Forwardable
    def_delegators  :@analyzer_tables, :table
    def_delegators  :@analyzed_problems, :problems_with, :location
    def_delegators  :@rankings, :worst_files, :worst_methods, :worst_classes
    private

    def setup(report_hash)
      # TODO There is likely a clash that will happen between
      # column names eventually. We should probably auto-prefix
      # them (e.g. "roodi_problem")
      analyzer_columns = COMMON_COLUMNS + GRANULARITIES + tool_analyzers.map{|analyzer| analyzer.columns}.flatten
      # though the tool_analyzers aren't returned, they are processed in
      # various places here, then by the analyzer tables
      # then by the rankings
      # to ultimately generate the hotspots
      @analyzer_tables = MetricFu::AnalyzerTables.new(analyzer_columns)
      tool_analyzers.each do |analyzer|
        analyzer.generate_records(report_hash[analyzer.name], @analyzer_tables.table)
      end
      @analyzer_tables.generate_records
      @rankings = MetricFu::HotspotRankings.new(@analyzer_tables.tool_tables)
      @rankings.calculate_scores(tool_analyzers, GRANULARITIES)
      # just for testing
      analyzed_problems
    end

    # UNUSED
    # def most_common_column(column_name, size)
    #   #grouping = Ruport::Data::Grouping.new(@table,
    #   #                                      :by => column_name,
    #   #                                      :order => lambda { |g| -g.size})
    #   get_grouping(@table, :by => column_name, :order => lambda {|g| -g.size})
    #   values = []
    #   grouping.each do |value, _|
    #     values << value if value!=nil
    #     if(values.size==size)
    #       break
    #     end
    #   end
    #   return nil if values.empty?
    #   if(values.size == 1)
    #     return values.first
    #   else
    #     return values
    #   end
    # end



  end
end
