class MetricFu::FlogHotspot < MetricFu::Hotspot
  COLUMNS = %w{score}

  def columns
    COLUMNS
  end

  def name
    :flog
  end

  def map_strategy
    :score
  end

  def reduce_strategy
    :average
  end

  def score_strategy
    :identity
  end

  def generate_records(data, table)
    return if data == nil
    Array(data[:method_containers]).each do |method_container|
      Array(method_container[:methods]).each do |entry|
        file_path = entry[1][:path].sub(%r{^/}, "") if entry[1][:path]
        location = MetricFu::Location.for(entry.first)
        table << {
          "metric" => name,
          "score" => entry[1][:score],
          "file_path" => file_path,
          "class_name" => location.class_name,
          "method_name" => location.method_name
        }
      end
    end
  end

  def present_group(group)
    occurences = group.size
    complexity = get_mean(group.column("score"))
    "#{'average ' if occurences > 1}complexity is %.1f" % complexity
  end
end
