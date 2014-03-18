createGraphElement("canvas");

var chart = new Bluff.Line("graph", "1000x600");
chart.theme_37signals();
chart.tooltips = true;
chart.title_font_size = "24px";
chart.legend_font_size = "12px";
chart.marker_font_size = "10px";
chart.title = graph_title;
for(var i = 0; i < graph_series.length; i++) {
  var serie = graph_series[i];
  chart.data(serie.name, serie.data);
}
chart.labels = graph_labels;
chart.draw();
