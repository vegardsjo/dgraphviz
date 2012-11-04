/++
+ D interface to the Graphviz graph visualization library
+ 
+ Written by Vegard Sjonfjell <vegardsjo@gmail.com>
+/

module graphviz;

import std.stdio;
import std.string;
import std.array;
import std.algorithm;
import std.conv;

import cgraphviz.graph;
import cgraphviz.gvc;

enum GraphType
{
  graph = AGRAPH,
  graphStrict = AGRAPHSTRICT,
  digraph = AGDIGRAPH,
  digraphStrict = AGDIGRAPHSTRICT
}

string gv_attrAccess(alias gv_var)()
{
  return xformat("
  void opDispatch(string attr)(string value) {
    agsafeset(%s, attr.toStringz, value.toStringz, \"\");
  }
  
  string opDispatch(string attr)() {
    return to!string(agget(gv_var, attr.toStringz));
  }", gv_var);
}

class Graph
{
  graph_t* gv_graph;
  GVC_t* gv_context;
  string layout = "dot";

  static this() {
    aginit();
  }

  this(GraphType type, string name)
  {
    gv_context = gvContext();
    gv_graph = agopen(name.toStringz, type);
  }
  
  this(GraphType type) {
    this(type, "");
  }
  
  ~this()
  {
    gvFreeLayout(gv_context, gv_graph);
    agclose(gv_graph);
  }
  
  Node addNode(string name) {
    return new Node(agnode(gv_graph, name.toStringz));
  }

  Edge addEdge(Node pre, Node post) {
    return new Edge(agedge(gv_graph, pre.gv_node, post.gv_node));
  }
  
  Edge addEdge(Node pre, Node post, string label)
  {
    auto edge = new Edge(agedge(gv_graph, pre.gv_node, post.gv_node));
    agset(edge.gv_edge, "label", label.toStringz);
    return edge;
  }

  void doLayout() {
    gvLayout(gv_context, gv_graph, layout.toStringz);
  }

  void outputFile(string type, string filename) {
    doLayout();
    gvRenderFilename(gv_context, gv_graph, type.toStringz, filename.toStringz);
  }
  
  void outputFp(string type, File file) {
    doLayout();
    gvRender(gv_context, gv_graph, type.toStringz, file.getFP);
  }
  
  mixin(gv_attrAccess!("gv_graph"));
}


class Node
{
  node_t* gv_node;

  this(node_t* gv_node) {
    this.gv_node = gv_node;
  }
  
  mixin(gv_attrAccess!("gv_node"));
}

class Edge
{
  edge_t* gv_edge;

  this(edge_t* gv_edge) {
    this.gv_edge = gv_edge;
  }

  mixin(gv_attrAccess!("gv_edge"));
}

unittest
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
  edge4.label = "OBEY ME, FOR I AM AN EDGE";

  graph.layout = "dot";
  //graph.outputFile("png", "test.png");
  graph.outputFp("dot", stdout);
}

version (test) void main() {}
