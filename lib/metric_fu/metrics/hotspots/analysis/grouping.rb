%w(table).each do |path|
  MetricFu.metrics_require   { "hotspots/analysis/#{path}" }
end
module MetricFu
  class Grouping
    def initialize(table, opts)
      column_name = opts.fetch(:by)
      hash = {}
      if column_name.to_sym == :metric # special optimized case
        hash = table.group_by_metric
      else
        raise "Unexpected column_name #{column_name}"
      end
      @arr = hash.to_a
    end

    def each
      @arr.each do |value, rows|
        yield value, rows
      end
    end
  end
end
