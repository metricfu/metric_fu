module MetricFu
  class HotspotGroupings

    def initialize(table, opts)
      @table, @opts = table, opts
    end

    def get_grouping
      MetricFu::Grouping.new(@table, @opts)
    end

  end
end
