module MetricFu
  class HotspotProblems

    def initialize(grouping)
      @grouping = grouping
    end

    def problems
      problems = {}
      @grouping.each do |metric, table|
        problems[metric] = MetricFu::Hotspot.analyzer_for_metric(metric).present_group(table)
      end
      problems
    end

  end
end
