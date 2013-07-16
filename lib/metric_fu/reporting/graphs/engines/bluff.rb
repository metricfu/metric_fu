module MetricFu
  class Grapher
    BLUFF_GRAPH_SIZE = "1000x600"
    BLUFF_DEFAULT_OPTIONS = <<-EOS
      var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"
    EOS
    def graph!
      title = send(:title)
      data = send(:data)
      labels = MultiJson.dump(@labels)
      output_filename = send(:output_filename)
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = '#{title}';
        #{build_data(data)}
        g.labels = #{labels};
        g.draw();
      EOS
      File.open(File.join(self.output_directory, output_filename), 'w') {|f| f << content }
    end
    private
    def build_data(data)
      Array(data).map do |label, datum|
        "g.data('#{label}', [#{datum}]);"
      end.join("\n")
    end
  end
end
