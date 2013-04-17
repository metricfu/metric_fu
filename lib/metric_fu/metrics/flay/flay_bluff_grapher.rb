MetricFu.metrics_require   { 'flay/flay_grapher' }
module MetricFu
  class FlayBluffGrapher < FlayGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Flay: duplication';
        g.data('flay', [#{@flay_score.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'flay.js'), 'w') {|f| f << content }
    end
  end
end
