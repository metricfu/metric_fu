MetricFu.metrics_require   { 'reek/reek_grapher' }
module MetricFu
  class ReekBluffGrapher < ReekGrapher
    def title
      'Reek: code smells'
    end
    def data
      @reek_count.map do |name, count|
        [name, count.join(',')]
      end
    end
    def output_filename
      'reek.js'
    end
  end
end
