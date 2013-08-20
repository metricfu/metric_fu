require 'spec_helper'

describe MetricFu::HotspotRankings do

  def rankings(result_hash)
    @rankings ||= {}
    @rankings.fetch(result_hash) do
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
      @rankings[result_hash] = rankings
      rankings
    end
  end
  context "with several types of data" do
    it "gives all files, in order, from worst to best" do
      expected = [
                  "lib/client/client.rb",
                  "lib/client/foo.rb"]
      rankings(result_hash).worst_files.should == expected
    end
    def result_hash
      @result_hash ||= metric_data('hotspots/several_metrics.yml')
    end
  end
  context "with Reek data" do

    before do
      @result_hash = metric_data('hotspots/reek.yml')
    end

    it "gives worst method" do
      rankings(@result_hash).worst_methods(1).should == ["Client#client_requested_sync"]
    end

    it "gives worst class" do
      rankings(@result_hash).worst_classes(1).should == ["Client"]
    end

    it "gives worst file" do
      rankings(@result_hash).worst_files(1).should == ["lib/client/client.rb"]
    end

  end
  context "with Saikuro data" do

    before do
      @result_hash = metric_data('hotspots/saikuro.yml')
    end

    it "gives worst method" do
      rankings(@result_hash).worst_methods(1).should == ["Supr#self.handle_full_or_hash_option"]
    end

    it "gives worst class" do
      rankings(@result_hash).worst_classes(1).should == ["Bitly"]
    end

  end
  context "with Flog data" do

    before do
      @result_hash = metric_data('hotspots/flog.yml')
    end

    it "gives worst method" do
      rankings(@result_hash).worst_methods(1).should == ["main#none"]
    end

    it "gives worst class" do
      rankings(@result_hash).worst_classes(1).should == ["main"]
    end

    it "gives worst file" do
      rankings(@result_hash).worst_files(1).should == ["lib/generators/rcov.rb:57"]
    end

  end

  context "with Roodi data" do

    before do
      @result_hash = metric_data('hotspots/roodi.yml')
    end

    it "gives worst file" do
      rankings(@result_hash).worst_files(1).should == ["lib/client/client.rb"]
    end

  end
end
