function createGraphElement(elementType) {
  var graphContainer = document.getElementById("graph_container");

  if(graphContainer) {
    var graphElement = document.createElement(elementType);
    graphElement.setAttribute("id", "graph");
    graphContainer.appendChild(graphElement);
  }
}
