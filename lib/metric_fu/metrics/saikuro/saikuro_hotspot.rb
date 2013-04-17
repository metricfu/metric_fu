class SaikuroHotspot < MetricFu::Hotspot
  include MetricFu::HotspotScoringStrategies

  COLUMNS = %w{lines complexity}

  def columns
    COLUMNS
  end

  def name
    :saikuro
  end

  def map(row)
    row.complexity
  end

  def reduce(scores)
    MetricFu::HotspotScoringStrategies.average(scores)
  end

  def score(metric_ranking, item)
    MetricFu::HotspotScoringStrategies.identity(metric_ranking, item)
  end

  def generate_records(data, table)
    return if data == nil
    data[:files].each do |file|
      file_name = file[:filename]
      file[:classes].each do |klass|
        location = MetricFu::Location.for(klass[:class_name])
        offending_class = location.class_name
        klass[:methods].each do |match|
          offending_method = MetricFu::Location.for(match[:name]).method_name
          table << {
            "metric" => name,
            "lines" => match[:lines],
            "complexity" => match[:complexity],
            "class_name" => offending_class,
            "method_name" => offending_method,
            "file_path" => file_name,
          }
        end
      end
    end
  end

  def present_group(group)
    occurences = group.size
    complexity = get_mean(group.column("complexity"))
    "#{"average " if occurences > 1}complexity is %.1f" % complexity
  end

  def present_group_details(group)
    occurences = group.size
    complexity = get_mean(group.column("complexity"))
    "#{"average " if occurences > 1}complexity is %.1f" % complexity
  end

end
