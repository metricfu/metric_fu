module MetricFu
  class HotspotAnalyzedProblems


    def initialize(hotspot_rankings, analyzer_tables)
      @hotspot_rankings = hotspot_rankings
      @analyzer_tables = analyzer_tables
    end
    def worst_items
      worst_items = {}
      worst_items[:files]   = worst(@hotspot_rankings.worst_files,   :file)
      worst_items[:classes] = worst(@hotspot_rankings.worst_classes, :class)
      worst_items[:methods] = worst(@hotspot_rankings.worst_methods, :method)
      worst_items
    end

    private

    # @param rankings [Array<MetricFu::HotspotRankings>]
    # @param granularity [Symbol] one of :class, :method, :file
    def worst(rankings,granularity)
      rankings.map do |ranked_item_name|
        location = location(granularity, ranked_item_name)
        details = problems_with(granularity, ranked_item_name)
        {:location => location, :details =>  details}
      end
    end

    # @todo redo as item,value, options = {}
    # Note that the other option for 'details' is :detailed (this isn't
    # at all clear from this method itself
    def problems_with(item, value)
      sub_table = get_sub_table(item, value)
      #grouping = Ruport::Data::Grouping.new(sub_table, :by => 'metric')
      grouping = get_grouping(sub_table, :by => 'metric')
      MetricFu::HotspotProblems.new(grouping).problems
    end

    def location(item, value)
      sub_table = get_sub_table(item, value)
      assert_sub_table_has_data(item, sub_table, value)
      first_row = sub_table[0]
      case item
      when :class
        MetricFu::Location.get(first_row.file_path, first_row.class_name, nil)
      when :method
        MetricFu::Location.get(first_row.file_path, first_row.class_name, first_row.method_name)
      when :file
        MetricFu::Location.get(first_row.file_path, nil, nil)
      else
        raise ArgumentError, "Item must be :class, :method, or :file"
      end
    end

    def assert_sub_table_has_data(item, sub_table, value)
      if (sub_table.length==0)
        raise MetricFu::AnalysisError, "The #{item.to_s} '#{value.to_s}' does not have any rows in the analysis table"
      end
    end

    def get_sub_table(item, value)
      tables = @analyzer_tables.tables_for(item)
      tables[value]
    end

    def get_grouping(table, opts)
      MetricFu::HotspotGroupings.new(table, opts).get_grouping
    end

  end
end
