MetricFu.metrics_require   { 'rcov/rcov_grapher' }
module MetricFu
  class RcovBluffGrapher < RcovGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Rcov: code coverage';
        g.data('rcov', [#{@rcov_percent.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'rcov.js'), 'w') {|f| f << content }
    end
  end
end
