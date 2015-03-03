%w(record).each do |path|
  MetricFu.metrics_require   { "hotspots/analysis/#{path}" }
end

module MetricFu
  class Table
    include Enumerable

    def initialize(opts = {})
      @rows = []
      @columns = opts.fetch(:column_names)

      @make_index = opts.fetch(:make_index) { true }
      @metric_index = {}
    end

    def <<(row)
      record = nil
      if row.is_a?(MetricFu::Record)
        record = row
      else
        record = MetricFu::Record.new(row, @columns)
      end
      @rows << record
      updated_key_index(record) if @make_index
    end

    def each
      @rows.each do |row|
        yield row
      end
    end

    def size
      length
    end

    def length
      @rows.length
    end

    def [](index)
      @rows[index]
    end

    def column(column_name)
      arr = []
      @rows.each do |row|
        arr << row[column_name]
      end
      arr
    end

    def group_by_metric
      @metric_index.to_a
    end

    private

    def updated_key_index(record)
      if record.has_key?("metric")
        @metric_index[record.metric] ||= MetricFu::Table.new(column_names: @columns, make_index: false)
        @metric_index[record.metric] << record
      end
    end
  end
end
