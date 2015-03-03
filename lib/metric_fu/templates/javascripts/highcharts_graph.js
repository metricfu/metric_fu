createGraphElement("div");

if(document.getElementById('graph')) {
  var chart = new Highcharts.Chart({
    chart: {
      animation: false,
      renderTo: 'graph'
    },
    legend: {
      align: 'center',
      verticalAlign: 'top',
      y: 25
    },
    plotOptions: {
      line: {
        animation: false,
        lineWidth: 3,
        marker: {
          radius: 6
        },
        pointPlacement: 'on'
      }
    },
    title: {
      text: graph_title
    },
    xAxis: {
      categories: graph_labels,
      tickmarkPlacement: 'on'
    },
    yAxis: {
      maxPadding: 0,
      min: 0,
      minPadding: 0
    },
    series: graph_series
  });
}
