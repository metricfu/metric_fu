class MetricFu::FlayHotspot < MetricFu::Hotspot
  COLUMNS = %w{flay_reason flay_matching_reason}

  def columns
    COLUMNS
  end

  def name
    :flay
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
    Array(data[:matches]).each do |match|
      problems  = match[:reason]
      matching_reason = problems.gsub(/^[0-9]+\) /, "").gsub(/\:[0-9]+/, "")
      files     = []
      locations = []
      match[:matches].each do |file_match|
        file_path = file_match[:name].sub(%r{^/}, "")
        locations << "#{file_path}:#{file_match[:line]}"
        files     << file_path
      end
      files = files.uniq
      files.each do |file|
        table << {
          "metric" => name,
          "file_path" => file,
          "flay_reason" => problems + " files: #{locations.join(', ')}",
          "flay_matching_reason" => matching_reason
        }
      end
    end
  end

  def present_group(group)
    occurences = group.size
    "found #{occurences} code duplications"
  end
end
