# coding: utf-8
class MetricFu::ReekHotspot < MetricFu::Hotspot
  # Note that in practice, the prefix reek__ is appended to each one
  # This was a partially implemented idea to avoid column name collisions
  # but it is only done in the ReekHotspot
  COLUMNS = %w{type_name message value value_description comparable_message}

  def columns
    COLUMNS.map { |column| "#{name}__#{column}" }
  end

  def name
    :reek
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
    data[:matches].each do |match|
      file_path = match[:file_path]
      match[:code_smells].each do |smell|
        location = MetricFu::Location.for(smell[:method])
        smell_type = smell[:type]
        message = smell[:message]
        table << {
          "metric" => name, # important
          "file_path" => file_path, # important
          # NOTE: ReekHotspot is currently different than other hotspots with regard
          # to column name. Note the COLUMNS constant and #columns method
          "reek__message" => message,
          "reek__type_name" => smell_type,
          "reek__value" => parse_value(message),
          "reek__value_description" => build_value_description(smell_type, message),
          "reek__comparable_message" => comparable_message(smell_type, message),
          "class_name" => location.class_name, # important
          "method_name" => location.method_name, # important
        }
      end
    end
  end

  def self.numeric_smell?(type)
    ["Large Class", "Long Method", "Long Parameter List"].include?(type)
  end

  def present_group(group)
    occurences = group.size
    "found #{occurences} code smells"
  end

  private

  def comparable_message(type_name, message)
    if self.class.numeric_smell?(type_name)
      match = message.match(/\d+/)
      if match
        match.pre_match + match.post_match
      else
        message
      end
    else
      message
    end
  end

  def build_value_description(type_name, message)
    item_type = message.match(/\d+ (.*)$/)
    if item_type
      "number of #{item_type[1]} in #{type_name.downcase}"
    else
      nil
    end
  end

  def parse_value(message)
    # mf_debug "parsing #{message}"
    match = message.match(/\d+/)
    if match
      match[0].to_i
    else
      nil
    end
  end
end
