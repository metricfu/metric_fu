class MetricFu::RoodiHotspot < MetricFu::Hotspot
  COLUMNS = %w{problems}

  def columns
    COLUMNS
  end

  def name
    :roodi
  end

  def map_strategy
    :present
  end

  def reduce_strategy
    :sum
  end

  def score_strategy
    :percentile
  end

  def generate_records(data, table)
    return if data == nil
    Array(data[:problems]).each do |problem|
      table << {
        "metric" => name,
        "problems" => problem[:problem],
        "file_path" => problem[:file]
      }
    end
  end

  def present_group(group)
    occurences = group.size
    "found #{occurences} design problems"
  end
end
