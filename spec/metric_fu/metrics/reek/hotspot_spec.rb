require 'spec_helper'
MetricFu.metrics_require { 'hotspots/metric' }
MetricFu.metrics_require { 'hotspots/hotspot' }
MetricFu.metrics_require { 'hotspots/analysis/record' }
MetricFu.metrics_require { 'reek/hotspot' }
describe MetricFu::ReekHotspot do
  let(:data) do
    {
      "metric"=>:reek,
      "file_path"=>"lib/metric_fu.rb",
      "reek__message"=>"doesn't depend on instance state",
      "reek__type_name"=>"UtilityFunction",
      "reek__value"=>nil,
      "reek__value_description"=>nil,
      "reek__comparable_message"=>"doesn't depend on instance state",
      "class_name"=>"MetricFu",
      "method_name"=>"MetricFu#current_time"
    }
  end
  let(:row) do MetricFu::Record.new(data, :unused_variable) end
  # TODO: This naming could be more clear
  let(:analyzer) do MetricFu::ReekHotspot.new end
  let(:tool_table) do
    table = MetricFu::Table.new(:column_names => analyzer.columns)
    table << row
    table
  end
  let(:tool_tables) do {:reek => tool_table} end
  let(:metric_violations) do tool_tables[analyzer.name] end

  it "ranks and calculates reek hotspot scores" do
    granularity = 'file_path'
    metric_ranking = build_metric_ranking(metric_ranking, granularity)
    test_metric_ranking(metric_ranking, granularity)

    items_to_score = reek_items_to_score
    master_ranking = build_master_ranking(items_to_score)
    test_calculate_score(master_ranking, items_to_score)
  end

  def build_metric_ranking(metric_ranking, granularity)
    metric_ranking = MetricFu::Ranking.new
    metric_violations.each do |row|
      location = row[granularity]
      expect(location).to eq(data["file_path"])
      metric_ranking[location] ||= []
      mapped_row = analyzer.map(row)
      expect(mapped_row).to eq(1) # present
      metric_ranking[location] << mapped_row
    end
    metric_ranking
  end
  def test_metric_ranking(metric_ranking, granularity)
    metric_ranking.each do |item, scores|
      expect(item).to eq(data["file_path"])
      expect(scores).to eq([1])
      reduced_score = analyzer.reduce(scores)
      expect(reduced_score).to eq(1) # sum
      metric_ranking[item] = reduced_score
    end
  end
  def build_master_ranking(items_to_score)
    master_ranking = MetricFu::Ranking.new
    items_to_score.each do |location, score|
      master_ranking[location] = score
    end
    master_ranking
  end
  def test_calculate_score(master_ranking, items_to_score)
    item = 'lib/metric_fu.rb'
    sorted_items = master_ranking.send(:sorted_items)
    index = sorted_items.index(item)
    expect(index).to eq(21)
    length = items_to_score.size
    expect(length).to eq(45)

    adjusted_index = index + 1
    worse_item_count = length - adjusted_index

    score = Float(worse_item_count) / length

    expect(analyzer.score(master_ranking, item)).to eq(score) # percentile
    expect(master_ranking.percentile(item)).to eq(score)
    expect(MetricFu::HotspotScoringStrategies.percentile(master_ranking, item)).to eq(score)
  end

  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:58:in `calculate_metric_scores'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:46:in `calculate_score_for_granularity'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:41:in `block in calculate_scores_by_granularities'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:40:in `each'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:40:in `calculate_scores_by_granularities'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:18:in `block in calculate_scores'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:17:in `each'
  # lib/metric_fu/metrics/hotspots/analysis/rankings.rb:17:in `calculate_scores'
  # lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:57:in `setup'
  # lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:25:in `initialize'
  # lib/metric_fu/metrics/hotspots/generator.rb:22:in `new'
  # lib/metric_fu/metrics/hotspots/generator.rb:22:in `analyze'
  # lib/metric_fu/generator.rb:107:in `generate_result'
  # lib/metric_fu/reporting/result.rb:50:in `add'
  # lib/metric_fu/run.rb:19:in `block in measure'
  # lib/metric_fu/run.rb:17:in `each'
  # lib/metric_fu/run.rb:17:in `measure'
  # lib/metric_fu/run.rb:8:in `run'
  # lib/metric_fu/cli/helper.rb:18:in `run'
  # lib/metric_fu/cli/client.rb:18:in `run'
  def reek_items_to_score
    {
      "lib/metric_fu.rb"=>4,
      "lib/metric_fu/cli/client.rb"=>1,
      "lib/metric_fu/cli/helper.rb"=>5,
      "lib/metric_fu/cli/parser.rb"=>33,
      "lib/metric_fu/configuration.rb"=>4,
      "lib/metric_fu/constantize.rb"=>8,
      "lib/metric_fu/data_structures/line_numbers.rb"=>11,
      "lib/metric_fu/data_structures/location.rb"=>7,
      "lib/metric_fu/data_structures/sexp_node.rb"=>5,
      "lib/metric_fu/environment.rb"=>4,
      "lib/metric_fu/errors/analysis_error.rb"=>1,
      "lib/metric_fu/formatter.rb"=>1,
      "lib/metric_fu/formatter/html.rb"=>11,
      "lib/metric_fu/formatter/syntax.rb"=>2,
      "lib/metric_fu/formatter/yaml.rb"=>1,
      "lib/metric_fu/gem_run.rb"=>3,
      "lib/metric_fu/gem_version.rb"=>5,
      "lib/metric_fu/generator.rb"=>7,
      "lib/metric_fu/io.rb"=>5,
      "lib/metric_fu/loader.rb"=>6,
      "lib/metric_fu/logger.rb"=>4,
      "lib/metric_fu/logging/mf_debugger.rb"=>2,
      "lib/metric_fu/metric.rb"=>7,
      "lib/metric_fu/metrics/cane/generator.rb"=>6,
      "lib/metric_fu/metrics/cane/grapher.rb"=>2,
      "lib/metric_fu/metrics/cane/metric.rb"=>2,
      "lib/metric_fu/metrics/cane/violations.rb"=>7,
      "lib/metric_fu/metrics/churn/generator.rb"=>3,
      "lib/metric_fu/metrics/churn/hotspot.rb"=>9,
      "lib/metric_fu/metrics/churn/metric.rb"=>1,
      "lib/metric_fu/metrics/flay/generator.rb"=>4,
      "lib/metric_fu/metrics/flay/grapher.rb"=>2,
      "lib/metric_fu/metrics/flay/hotspot.rb"=>5,
      "lib/metric_fu/metrics/flay/metric.rb"=>1,
      "lib/metric_fu/metrics/flog/generator.rb"=>11,
      "lib/metric_fu/metrics/flog/grapher.rb"=>11,
      "lib/metric_fu/metrics/flog/hotspot.rb"=>8,
      "lib/metric_fu/metrics/flog/metric.rb"=>1,
      "lib/metric_fu/metrics/hotspots/analysis/analyzed_problems.rb"=>1,
      "lib/metric_fu/metrics/hotspots/analysis/analyzer_tables.rb"=>8,
      "lib/metric_fu/metrics/hotspots/analysis/grouping.rb"=>1,
      "lib/metric_fu/metrics/hotspots/analysis/groupings.rb"=>1,
      "lib/metric_fu/metrics/hotspots/analysis/problems.rb"=>2,
      "lib/metric_fu/metrics/hotspots/analysis/ranked_problem_location.rb"=>5,
      "lib/metric_fu/metrics/hotspots/analysis/ranking.rb"=>1,
    }
  end
end
