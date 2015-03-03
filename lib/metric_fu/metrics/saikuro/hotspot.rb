class MetricFu::SaikuroHotspot < MetricFu::Hotspot
  COLUMNS = %w{lines complexity}

  def columns
    COLUMNS
  end

  def name
    :saikuro
  end

  def map_strategy
    :complexity
  end

  def reduce_strategy
    :average
  end

  def score_strategy
    :identity
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
    "#{'average ' if occurences > 1}complexity is %.1f" % complexity
  end
end
