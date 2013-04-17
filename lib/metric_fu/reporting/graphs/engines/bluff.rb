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
  end
end
