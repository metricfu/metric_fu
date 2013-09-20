MetricFu.metrics_require   { 'hotspots/hotspot_analyzer' }
module MetricFu

  class HotspotsGenerator < Generator

    def self.metric
      :hotspots
    end

    def initialize(options={})
      super
    end

    def emit
      # no-op
    end

    def analyze
      analyzer = MetricFu::HotspotAnalyzer.new(MetricFu.result.result_hash)
      @hotspots = analyzer.hotspots
    end

    def to_h
      result = {:hotspots => {}}
      @hotspots.each do |granularity, hotspots|
        result[:hotspots][granularity.to_s] = hotspots.map(&:to_hash)
      end
      result
    end
  end

end
