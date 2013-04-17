MetricFu.metrics_require   { 'rails_best_practices/rails_best_practices_grapher' }
module MetricFu
  class RailsBestPracticesBluffGrapher < RailsBestPracticesGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Rails Best Practices: design problems';
        g.data('rails_best_practices', [#{@rails_best_practices_count.join(',')}]);
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'rails_best_practices.js'), 'w') {|f| f << content }
    end
  end
end
