MetricFu.metrics_require   { 'cane/cane_grapher' }
module MetricFu
  class CaneBluffGrapher < CaneGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Cane: code quality threshold violations';
        g.data('cane', [#{@cane_violations.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'cane.js'), 'w') {|f| f << content }
    end
  end
end
