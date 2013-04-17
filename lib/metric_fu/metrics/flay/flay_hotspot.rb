class FlayHotspot < MetricFu::Hotspot
  include MetricFu::HotspotScoringStrategies

  COLUMNS = %w{flay_reason flay_matching_reason}

  def columns
    COLUMNS
  end

  def name
    :flay
  end

  def map(row)
    MetricFu::HotspotScoringStrategies.present(row)
  end

  def reduce(scores)
    MetricFu::HotspotScoringStrategies.sum(scores)
  end

  def score(metric_ranking, item)
    MetricFu::HotspotScoringStrategies.percentile(metric_ranking, item)
  end

  def generate_records(data, table)
    return if data==nil
    Array(data[:matches]).each do |match|
      problems  = match[:reason]
      matching_reason = problems.gsub(/^[0-9]+\) /,'').gsub(/\:[0-9]+/,'')
      files     = []
      locations = []
      match[:matches].each do |file_match|
        file_path = file_match[:name].sub(%r{^/},'')
        locations << "#{file_path}:#{file_match[:line]}"
        files     << file_path
      end
      files = files.uniq
      files.each do |file|
        table << {
          "metric" => self.name,
          "file_path" => file,
          "flay_reason" => problems+" files: #{locations.join(', ')}",
          "flay_matching_reason" => matching_reason
        }
      end
    end
  end

  def present_group(group)
    occurences = group.size
    "found #{occurences} code duplications"
  end

  def present_group_details(group)
    occurences = group.size
    message = "found #{occurences} code duplications<br/>"
    group.each do |item|
      problem    = item.data["flay_reason"]
      problem    = problem.gsub(/^[0-9]*\)/,'')
      problem    = problem.gsub(/files\:/,' <br>&nbsp;&nbsp;&nbsp;files:')
      message << "* #{problem}<br/>"
    end
    message
  end

end
