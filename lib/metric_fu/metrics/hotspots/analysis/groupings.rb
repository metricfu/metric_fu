module MetricFu
  class HotspotGroupings

    def initialize(table, opts)
      @table, @opts = table, opts
    end
    def get_grouping
      #Ruport::Data::Grouping.new(table, opts)
      MetricFu::Grouping.new(@table, @opts)
      #@grouping_cache ||= {}
      #@grouping_cache.fetch(grouping_key(table,opts)) do
      #  @grouping_cache[grouping_key(table,opts)] = Ruport::Data::Grouping.new(table, opts)
      #end
    end

    # UNUSED
    # def grouping_key(table, opts)
    #   "table #{table.object_id} opts #{opts.inspect}"
    # end
  end
end
