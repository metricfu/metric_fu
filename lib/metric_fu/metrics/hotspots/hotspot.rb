module MetricFu
  class Hotspot
    def self.metric
      self.name.split('Hotspot')[0].downcase.to_sym
    end
    @analyzers = {}
    def self.analyzers
      @analyzers.values
    end
    def self.analyzer_for_metric(metric)
      mf_debug "Getting analyzer for #{metric}"
      @analyzers.fetch(metric.to_sym) {
        raise MetricFu::AnalysisError, "Unknown metric #{metric}. We only know #{@analyzers.keys.inspect}"
      }
    end
    def self.inherited(subclass)
      mf_debug "Adding #{subclass} to #{@analyzers.inspect}"
      @analyzers[subclass.metric] = subclass.new
    end

    # TODO simplify calculation
    def get_mean(collection)
      collection_length = collection.length
      sum = 0
      sum = collection.inject( nil ) { |sum,x| sum ? sum+x : x }
      (sum.to_f / collection_length.to_f)
    end
  end
end
