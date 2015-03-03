require "spec_helper"
MetricFu.metrics_require { "hotspots/analysis/rankings" }

describe MetricFu::HotspotRankings do
  before do
    enable_hotspots
  end

  # TODO: This helper method is a huge smell. Make unnecessary
  def rankings(result_hash)
    @rankings ||= {}
    @rankings.fetch(result_hash) do
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
      @rankings[result_hash] = rankings
      rankings
    end
  end
  context "with several types of data" do
    it "gives all files, in order, from worst to best" do
      expected = [
        "lib/client/client.rb",
        "lib/client/foo.rb"]
      expect(rankings(result_hash).worst_files).to eq(expected)
    end
    def result_hash
      @result_hash ||= HOTSPOT_DATA["several_metrics.yml"]
    end
  end
  context "with Reek data" do
    before do
      @result_hash = HOTSPOT_DATA["reek.yml"]
    end

    it "gives worst method" do
      expect(rankings(@result_hash).worst_methods[0]).to eq("Client#client_requested_sync")
    end

    it "gives worst class" do
      expect(rankings(@result_hash).worst_classes[0]).to eq("Client")
    end

    it "gives worst file" do
      expect(rankings(@result_hash).worst_files[0]).to eq("lib/client/client.rb")
    end
  end
  context "with Saikuro data" do
    before do
      @result_hash = HOTSPOT_DATA["saikuro.yml"]
    end

    it "gives worst method" do
      expect(rankings(@result_hash).worst_methods[0]).to eq("Supr#self.handle_full_or_hash_option")
    end

    it "gives worst class" do
      expect(rankings(@result_hash).worst_classes[0]).to eq("Bitly")
    end
  end
  context "with Flog data" do
    before do
      @result_hash = HOTSPOT_DATA["flog.yml"]
    end

    it "gives worst method" do
      expect(rankings(@result_hash).worst_methods[0]).to eq("main#none")
    end

    it "gives worst class" do
      expect(rankings(@result_hash).worst_classes[0]).to eq("main")
    end

    it "gives worst file" do
      expect(rankings(@result_hash).worst_files[0]).to eq("lib/generators/rcov.rb:57")
    end
  end

  context "with Roodi data" do
    before do
      @result_hash = HOTSPOT_DATA["roodi.yml"]
    end

    it "gives worst file" do
      expect(rankings(@result_hash).worst_files[0]).to eq("lib/client/client.rb")
    end
  end
end
