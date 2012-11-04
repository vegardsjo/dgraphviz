import graphviz;

void main()
{
  auto graph = new Graph(GraphType.digraph);

  auto node1 = graph.addNode("Node 1");
  node1.style = "filled";
  node1.fillcolor = "red";

  auto node2 = graph.addNode("Node 2");
  node2.label = " ♖ ";

  auto edge1 = graph.addEdge(node1, node1);
  auto edge2 = graph.addEdge(node1, node2);
  auto edge3 = graph.addEdge(node2, node1);

  auto edge4 = graph.addEdge(node2, node2);
  edge4.color = "magenta";
  edge4.label = "  OBEY ME, FOR I AM AN EDGE  ";

  graph.layout = "dot";
  graph.outputFile("svg", "test2.svg");
}
