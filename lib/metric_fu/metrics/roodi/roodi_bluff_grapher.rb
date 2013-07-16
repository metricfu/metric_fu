MetricFu.metrics_require   { 'roodi/roodi_grapher' }
module MetricFu
  class RoodiBluffGrapher < RoodiGrapher
    def graph!
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Roodi: design problems';
        g.data('roodi', [#{@roodi_count.join(',')}]);
        g.labels = #{MultiJson.dump(@labels)};
        g.draw();
      EOS
      File.open(File.join(self.output_directory, 'roodi.js'), 'w') {|f| f << content }
    end
  end
end
