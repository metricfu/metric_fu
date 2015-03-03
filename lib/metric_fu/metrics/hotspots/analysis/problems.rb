MetricFu.metrics_require { "hotspots/analysis/groupings" }
module MetricFu
  class HotspotProblems
    def initialize(sub_table)
      @grouping = group_by(sub_table, "metric")
    end

    def problems
      problems = {}
      @grouping.each do |metric, table|
        problems[metric] = MetricFu::Hotspot.analyzer_for_metric(metric).present_group(table)
      end
      problems
    end

    def group_by(sub_table, by = "metric")
      MetricFu::HotspotGroupings.new(sub_table, by: by).get_grouping
    end
  end
end
