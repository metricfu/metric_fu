MetricFu.metrics_require   { 'roodi/roodi_grapher' }
module MetricFu
  class RoodiBluffGrapher < RoodiGrapher
    def title
      'Roodi: design problems'
    end
    def data
      [
        ['roodi', @roodi_count.join(',')]
      ]
    end
    def output_filename
      'roodi.js'
    end
  end
end
