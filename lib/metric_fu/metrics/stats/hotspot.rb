class MetricFu::StatsHotspot < MetricFu::Hotspot

  COLUMNS = %w{stat_name stat_value}

  def columns
    COLUMNS
  end

  def name
    :stats
  end

  def map_strategy
    :absent
  end

  def reduce_strategy
    :absent
  end

  def score_strategy
    :absent
  end

  def generate_records(data)
    return [] if data == nil
    data.map do |key, value|
      next if value.kind_of?(Array)
      {
        "metric" => name,
        "stat_name" => key,
        "stat_value" => value
      }
    end.compact
  end

end
