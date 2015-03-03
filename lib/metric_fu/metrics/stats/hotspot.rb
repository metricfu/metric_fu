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

  def generate_records(data, table)
    return if data == nil
    data.each do |key, value|
      next if value.is_a?(Array)
      table << {
        "metric" => name,
        "stat_name" => key,
        "stat_value" => value
      }
    end
  end
end
