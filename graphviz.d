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

mixin template AttrAccess(alias gv_var)
{
  void opDispatch(string attr)(string value) {
    agsafeset(gv_var, attr.toStringz, value.toStringz, "");
  }
  
  string opDispatch(string attr)() {
    return to!string(agget(gv_var, attr.toStringz));
  }
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
  
  mixin AttrAccess!("gv_graph");
}


class Node
{
  node_t* gv_node;

  this(node_t* gv_node) {
    this.gv_node = gv_node;
  }
  
  mixin AttrAccess!("gv_node");
}

class Edge
{
  edge_t* gv_edge;

  this(edge_t* gv_edge) {
    this.gv_edge = gv_edge;
  }

  mixin AttrAccess!("gv_edge");
}
