module MetricFu
  module HotspotScoringStrategies

    def percentile(ranking, item)
      ranking.percentile(item) # per project score percentile
    end

    def identity(ranking, item)
      ranking[item] # Use the score you got (ex flog score of 20 is not bad even if it is the top one in project)
    end

    # present(row)
    # trying to understand what this does. Was hardcoded to return 1
    # is called by map(row) by the reek or roodi metric hotspot
    #   lib/metric_fu/metrics/roodi/roodi_hotspot.rb:16
    #   lib/metric_fu/metrics/reek/reek_hotspot.rb:90
    # which was called by lib/metric_fu/metrics/hotspots/analysis/rankings.rb:50
    # which was called by lib/metric_fu/metrics/hotspots/analysis/table.rb:29
    # which was called by lib/metric_fu/metrics/hotspots/analysis/rankings.rb:47
    # which was called by lib/metric_fu/metrics/hotspots/analysis/rankings.rb:12
    # which was called by lib/metric_fu/metrics/hotspots/hotspot_analyzer.rb:58
    # the row for reek looks like this:
    # #<MetricFu::Record:0x007fd2e38a4360 @data={"metric"=>:reek, "file_path"=>"lib/metric_fu/cli/parser.rb", "reek__message"=>"refers to opt more than self", "reek__type_name"=>"FeatureEnvy", "reek__value"=>nil, "reek__value_description"=>nil, "reek__comparable_message"=>"refers to opt more than self", "class_name"=>"Parser", "method_name"=>"Parser#validate"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>
    # the row for roodi looks like this
    # #<MetricFu::Record:0x007fd2e2628b50 @data={"metric"=>:roodi, "problems"=>"Method \"write\" has 32 lines.  It should have 20 or less.", "file_path"=>"lib/metric_fu/reporting/templates/awesome/awesome_template.rb"}, @columns=["metric", "file_path", "class_name", "method_name", "times_changed", "flay_reason", "flay_matching_reason", "score", "lines", "complexity", "reek__type_name", "reek__message", "reek__value", "reek__value_description", "reek__comparable_message", "percentage_uncovered", "problems", "stat_name", "stat_value"]>
    # If present it's a one, not present it's a zero - For things like Reek that don't have a number
    def present(row)
      !!row ? 1 : 0
    end

    def sum(scores)
      scores.inject(0) {|s,x| s+x}
    end

    def average(scores)
      # remove dependency on statarray
      # scores.to_statarray.mean
      score_length = scores.length
      total = 0
      total= scores.inject( nil ) { |sum,x| sum ? sum+x : x }
      (total.to_f / score_length.to_f)
    end

    extend self
  end
end
