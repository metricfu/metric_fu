require 'spec_helper'

describe MetricFu::HotspotAnalyzedProblems do

  def analyzed_problems(result_hash)
    @analyzed_problems ||= {}
    @analyzed_problems.fetch(result_hash) do
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
      analyzed_problems = MetricFu::HotspotAnalyzedProblems.new(rankings, analyzer_tables)
      @analyzed_problems[result_hash] = analyzed_problems
      analyzed_problems
    end
  end

  context "with several types of data" do

    before do
      @result_hash = metric_data('hotspots/several_metrics.yml')
      @analyzed_problems = analyzed_problems(@result_hash)
      @worst_items = @analyzed_problems.worst_items
    end

    it "gives all issues for a class" do
      expected = {
        :reek => "found 2 code smells",
        :flog => "complexity is 37.9"
      }
      # TODO Unsure if we want to make problems_with and location public or private at this point
      @analyzed_problems.method(:problems_with).call(:class, "Client").should == expected
      expect(@worst_items[:classes].first[:details]).to eq(expected)
    end

    it "gives all issues for a method" do
      expected = {
        :reek => "found 1 code smells",
        :flog => "complexity is 37.9"}
      @analyzed_problems.method(:problems_with).call(:method, "Client#client_requested_sync").should == expected
      expect(@worst_items[:methods].first[:details]).to eq(expected)
    end

    it "gives all issues for a file" do
      expected = {
        :reek => "found 2 code smells" ,
        :flog => "complexity is 37.9",
        :churn => "detected high level of churn (changed 54 times)"}
      @analyzed_problems.method(:problems_with).call(:file, "lib/client/client.rb").should == expected
      expect(@worst_items[:files].first[:details]).to eq(expected)
    end

    it "provide location for a method" do
      expected = MetricFu::Location.new("lib/client/client.rb",
                              "Client",
                              "Client#client_requested_sync")
      @analyzed_problems.method(:location).call(:method, "Client#client_requested_sync").should == expected
      expect(@worst_items[:methods].first[:location]).to eq(expected)
    end

    it "provides location for a class" do
      expected = MetricFu::Location.new("lib/client/client.rb",
                              "Client",
                              nil)
      @analyzed_problems.method(:location).call(:class, "Client").should == expected
      expect(@worst_items[:classes].first[:location]).to eq(expected)
    end

    it "provides location for a file" do
      expected = MetricFu::Location.new("lib/client/client.rb",
                              nil,
                              nil)
      @analyzed_problems.method(:location).call(:file, "lib/client/client.rb").should == expected
      expect(@worst_items[:files].first[:location]).to eq(expected)
    end

  end

  context "with Saikuro data" do

    before do
      @result_hash = metric_data('hotspots/saikuro.yml')
      @analyzed_problems = analyzed_problems(@result_hash)
      @worst_items = @analyzed_problems.worst_items
    end

    it "gives complexity for method" do
      expected = {
        :saikuro => "complexity is 1.0"
      }
      @analyzed_problems.method(:problems_with).call(:method, "Supr#initialize").should == expected
      expect(@worst_items[:methods].last[:details]).to eq(expected)
    end

    it "gives average complexity for class" do
      expected = {
        :saikuro => "average complexity is 5.0"
      }
      @analyzed_problems.method(:problems_with).call(:class, "Supr").should == expected
      expect(@worst_items[:classes].last[:details]).to eq(expected)
    end

  end

end
