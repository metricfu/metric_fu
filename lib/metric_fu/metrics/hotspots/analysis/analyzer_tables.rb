module MetricFu
  class AnalyzerTables
    %w(table).each do |path|
      MetricFu.metrics_require   { "hotspots/analysis/#{path}" }
    end

    def initialize(analyzer_columns)
      @columns = analyzer_columns
    end

    def generate_records
      build_lookups!
      process_rows!
    end

    def tool_tables
      @tool_tables ||= make_table_hash(@columns)
    end

    def table
      @table ||= make_table(@columns)
    end

    def tables_for(item)
      {
        class: @class_tables,
        method: @method_tables,
        file: @file_tables,
        tool: @tool_tables
      }.fetch(item) do
        raise ArgumentError, "Item must be :class, :method, or :file, but was #{item}"
      end
    end

    private

    def make_table(columns)
      MetricFu::Table.new(column_names: columns)
    end

    def make_table_hash(columns)
      Hash.new { |hash, key|
        hash[key] = make_table(columns)
      }
    end

    # COLLECT AND PROCESS RAW HOTSPOT METRICS
    def build_lookups!
      @class_and_method_to_file ||= {}
      # Build a mapping from [class,method] => filename
      # (and make sure the mapping is unique)
      table.each do |row|
        # We know that Saikuro provides the wrong data
        # TODO inject Saikuro reference
        next if row["metric"] == :saikuro
        key = [row["class_name"], row["method_name"]]
        file_path = row["file_path"]
        @class_and_method_to_file[key] ||= file_path
      end
    end

    # COLLECT AND PROCESS RAW HOTSPOT METRICS
    def process_rows!
      # Correct incorrect rows in the table
      table.each do |row|
        row_metric = row["metric"] # perf optimization
        # TODO inject Saikuro reference
        if row_metric == :saikuro
          fix_row_file_path!(row)
        end
        tool_tables[row_metric] << row
        file_tables[row["file_path"]] << row
        class_tables[row["class_name"]] << row
        method_tables[row["method_name"]] << row
      end
    end

    # COLLECT AND PROCESS RAW HOTSPOT METRICS
    def fix_row_file_path!(row)
      # We know that Saikuro rows are broken
      # next unless row['metric'] == :saikuro
      key = [row["class_name"], row["method_name"]]
      current_file_path = row["file_path"].to_s
      correct_file_path = @class_and_method_to_file[key]
      if !correct_file_path.nil? && correct_file_path.include?(current_file_path)
        row["file_path"] = correct_file_path
      else
        # There wasn't an exact match, so we can do a substring match
        matching_file_path = file_paths.detect {|file_path|
          !file_path.nil? && file_path.include?(current_file_path)
        }
        if matching_file_path
          row["file_path"] = matching_file_path
        end
      end
    end

    def file_paths
      @file_paths ||= @table.column("file_path").uniq
    end

    def file_tables
      @file_tables  ||= make_table_hash(@columns)
    end

    def class_tables
      @class_tables  ||= make_table_hash(@columns)
    end

    def method_tables
      @method_tables ||= make_table_hash(@columns)
    end
  end
end
