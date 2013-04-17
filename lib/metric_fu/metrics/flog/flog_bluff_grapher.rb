MetricFu.metrics_require   { 'flog/flog_grapher' }
module MetricFu
  class FlogBluffGrapher < FlogGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Flog: code complexity';
        g.data('average', [#{@flog_average.join(',')}]);
        g.data('top 5% average', [#{@top_five_percent_average.join(',')}])
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'flog.js'), 'w') {|f| f << content }
    end
  end
end
