MetricFu.metrics_require   { 'hotspots/hotspot_analyzer' }
module MetricFu

  class Hotspots < Generator

    def initialize(options={})
      super
    end

    def self.verify_dependencies!
      true
    end

    def emit
      @analyzer = MetricFu::HotspotAnalyzer.new(MetricFu.report.report_hash)
    end

    def analyze
      @hotspots = @analyzer && @analyzer.hotspots || {}
    end

    def to_h
      {:hotspots => @hotspots}
    end
  end

end
