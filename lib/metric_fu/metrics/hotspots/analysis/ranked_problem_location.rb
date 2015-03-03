MetricFu.lib_require { "errors/analysis_error" }
MetricFu.metrics_require { "hotspots/analysis/problems" }
module MetricFu
  class HotspotRankedProblemLocation
    MetricFu.data_structures_require { "location" }
    attr_reader :sub_table, :granularity
    def initialize(sub_table, granularity)
      @sub_table = sub_table
      @granularity = granularity
    end

    def to_hash
      {
        "location" => location.to_hash,
        "details" =>  stringify_keys(problems),
      }
    end

    def stringify_keys(hash)
      result = {}
      hash.each do |key, value|
        result[key.to_s] = value
      end
      result
    end

    # @todo redo as item,value, options = {}
    # Note that the other option for 'details' is :detailed (this isn't
    # at all clear from this method itself
    def problems
      @problems ||= MetricFu::HotspotProblems.new(sub_table).problems
    end

    def location
      @location ||= case granularity
                    when :class  then class_location
                    when :method then method_location
                    when :file   then file_location
                    else              raise ArgumentError, "Item must be :class, :method, or :file"
                    end
    end

    def file_path
      first_row.file_path
    end

    def class_name
      first_row.class_name
    end

    def method_name
      first_row.method_name
    end

    def file_location
      MetricFu::Location.get(file_path, nil, nil)
    end

    def method_location
      MetricFu::Location.get(file_path, class_name, method_name)
    end

    def class_location
      MetricFu::Location.get(file_path, class_name, nil)
    end

    def first_row
      assert_sub_table_has_data
      @first_row ||= sub_table[0]
    end

    def assert_sub_table_has_data
      if (sub_table.length == 0)
        raise MetricFu::AnalysisError, "The #{item} '#{value}' does not have any rows in the analysis table"
      end
    end
  end
end
