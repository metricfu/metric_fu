MetricFu.metrics_require   { 'rcov/rcov_grapher' }
module MetricFu
  class RcovGchartGrapher < RcovGrapher
    def graph!
      url = Gchart.line(
        :size => GCHART_GRAPH_SIZE,
        :title => URI.escape("Rcov: code coverage"),
        :data => self.rcov_percent,
        :max_value => 101,
        :axis_with_labels => 'x,y',
        :axis_labels => [self.labels.values, [0,20,40,60,80,100]],
        :format => 'file',
        :filename => File.join(MetricFu.output_directory, 'rcov.png')
      )
    end
  end
end
