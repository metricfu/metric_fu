MetricFu.metrics_require   { 'rcov/rcov_grapher' }
module MetricFu
  class RcovGchartGrapher < RcovGrapher
    def title
      "Rcov: code coverage"
    end
    def data
      self.rcov_percent
    end
    def output_filename
      'rcov.png'
    end
    # overrides method
    def y_axis_scale_options
      {
        :max_value => 101,
        :axis_with_labels => 'x,y',
        :axis_labels => [self.labels.values, [0,20,40,60,80,100]],
      }
    end
  end
end
