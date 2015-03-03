class MetricFu::RcovHotspot < MetricFu::Hotspot
  COLUMNS = %w{percentage_uncovered}

  def columns
    COLUMNS
  end

  def name
    :rcov
  end

  def map_strategy
    :percentage_uncovered
  end

  def reduce_strategy
    :average
  end

  def score_strategy
    :identity
  end

  def generate_records(data, table)
    return if data == nil
    data.each do |file_name, info|
      next if (file_name == :global_percent_run) || (info[:methods].nil?)
      info[:methods].each do |method_name, percentage_uncovered|
        location = MetricFu::Location.for(method_name)
        table << {
          "metric" => :rcov,
          "file_path" => file_name,
          "class_name" => location.class_name,
          "method_name" => location.method_name,
          "percentage_uncovered" => percentage_uncovered
        }
      end
    end
  end

  def present_group(group)
    occurences = group.size
    average_code_uncoverage = get_mean(group.column("percentage_uncovered"))
    "#{'average ' if occurences > 1}uncovered code is %.1f%" % average_code_uncoverage
  end
end
