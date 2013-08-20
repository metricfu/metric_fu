require 'spec_helper'

describe MetricFu::AnalyzerTables do

  def analyzer_table(result_hash)
    @analyzer_tables ||= {}
    @analyzer_tables.fetch(result_hash) do
      common_columns = %w{metric}
      granularities =  %w{file_path class_name method_name}
      tool_analyzers = MetricFu::Hotspot.analyzers
      analyzer_columns = common_columns + granularities + tool_analyzers.map{|analyzer| analyzer.columns}.flatten

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
      @result_hash = metric_data('hotspots/stats.yml')
      @table = analyzer_table(@result_hash).table
    end

    it "should have codeLOC" do
      row = @table.rows_with('stat_name' => :codeLOC).first
      row['stat_value'].should == 4222
    end

    it "should have testLOC" do
      row = @table.rows_with('stat_name' => :testLOC).first
      row['stat_value'].should == 2111
    end

    it "should have code_to_test_ratio" do
      row = @table.rows_with('stat_name' => :code_to_test_ratio).first
      row['stat_value'].should == 2
    end

  end

  context "with three different path representations of file (from Saikuro, Flog, and Reek)" do

    before do
      @result_hash = metric_data('hotspots/three_metrics_on_same_file.yml')
      @table = analyzer_table(@result_hash).table
    end

    specify "all records should have full file_path" do
      @table.each do |row|
        row['file_path'].should == 'lib/client/client.rb'
      end
    end

    specify "all records should have class name" do
      @table.rows_with(:class_name => nil).should have(0).rows
    end

    specify "one record should not have method name" do
      @table.rows_with(:method_name => nil).should have(1).rows
    end

  end
end
