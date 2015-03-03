require "spec_helper"
MetricFu.metrics_require { "hotspots/analysis/analyzer_tables" }

describe MetricFu::AnalyzerTables do
  before do
    enable_hotspots
  end

  def analyzer_table(result_hash)
    @analyzer_tables ||= {}
    @analyzer_tables.fetch(result_hash) do
      common_columns = %w{metric}
      granularities =  %w{file_path class_name method_name}
      tool_analyzers = MetricFu::Hotspot.analyzers
      analyzer_columns = common_columns + granularities + tool_analyzers.map(&:columns).flatten

      analyzer_tables = MetricFu::AnalyzerTables.new(analyzer_columns)
      tool_analyzers.each do |analyzer|
        analyzer.generate_records(result_hash[analyzer.name], analyzer_tables.table)
      end
      analyzer_tables.generate_records
      rankings = MetricFu::HotspotRankings.new(analyzer_tables.tool_tables)
      rankings.calculate_scores(tool_analyzers, granularities)
      @analyzer_tables[result_hash] = analyzer_tables
      analyzer_tables
    end
  end

  context "with Stats data" do
    before do
      @result_hash = HOTSPOT_DATA["stats.yml"]
      @table = analyzer_table(@result_hash).table
    end

    it "should have codeLOC" do
      row = @table.find { |row| row["stat_name"] == :codeLOC }
      expect(row["stat_value"]).to eq(4222)
    end

    it "should have testLOC" do
      row = @table.find { |row| row["stat_name"] == :testLOC }
      expect(row["stat_value"]).to eq(2111)
    end

    it "should have code_to_test_ratio" do
      row = @table.find { |row| row["stat_name"] == :code_to_test_ratio }
      expect(row["stat_value"]).to eq(2)
    end
  end

  context "with three different path representations of file (from Saikuro, Flog, and Reek)" do
    before do
      @result_hash = HOTSPOT_DATA["three_metrics_on_same_file.yml"]
      @table = analyzer_table(@result_hash).table
    end

    specify "all records should have full file_path" do
      @table.each do |row|
        expect(row["file_path"]).to eq("lib/client/client.rb")
      end
    end

    specify "all records should have class name" do
      expect(@table.select { |rows| rows.fetch(:class_name, :no_key) == nil }.size).to eq(0)
    end

    specify "one record should not have method name" do
      expect(@table.select { |rows| rows.fetch(:method_name, :no_key) == nil }.size).to eq(0)
    end
  end
end
