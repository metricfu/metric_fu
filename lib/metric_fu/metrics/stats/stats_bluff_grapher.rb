MetricFu.metrics_require   { 'stats/stats_grapher' }
module MetricFu
  class StatsBluffGrapher < StatsGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Stats: LOC & LOT';
        g.data('LOC', [#{@loc_counts.join(',')}]);
        g.data('LOT', [#{@lot_counts.join(',')}])
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'stats.js'), 'w') {|f| f << content }
    end
  end
end
