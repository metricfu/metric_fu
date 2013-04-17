module MetricFu
  class HotspotProblems

    def initialize(grouping, details, exclude_details)
      @grouping, @details, @exclude_details = grouping, details, exclude_details
    end

    def problems
      problems = {}
      @grouping.each do |metric, table|
        if @details == :summary || @exclude_details.include?(metric)
          problems[metric] = MetricFu::Hotspot.analyzer_for_metric(metric).present_group(table)
        else
          problems[metric] = MetricFu::Hotspot.analyzer_for_metric(metric).present_group_details(table)
        end
      end
      problems
    end

  end
end
