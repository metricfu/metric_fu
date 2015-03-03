require "forwardable"
module MetricFu
  class Ranking
    extend Forwardable

    def initialize
      @items_to_score = {}
    end

    def top
      sorted_items
    end

    def percentile(item)
      index = sorted_items.index(item)
      worse_item_count = (length - (index + 1))
      worse_item_count.to_f / length
    end

    def_delegator :@items_to_score, :has_key?, :scored?
    def_delegators :@items_to_score, :[], :[]=, :length, :each, :delete, :fetch

    private

    def sorted_items
      @sorted_items ||= @items_to_score.sort_by { |_item, score| -score }.map { |item, _score| item }
    end
  end
end
