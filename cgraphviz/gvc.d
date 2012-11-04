module cgraphviz.gvc;
import cgraphviz.graph;
import std.stdint;
import std.c.stdio;

alias void GVC_t;

extern (C):
extern GVC_t* gvContext();
extern char** gvcInfo(GVC_t* gvc);
extern char* gvcVersion(GVC_t* gvc);
extern char* gvcBuildDate(GVC_t* gvc);
extern int gvParseArgs(GVC_t*, int, char**);
extern graph_t* gvNextInputGraph(GVC_t* gvc);
extern graph_t* gvPluginsGraph(GVC_t* gvc);
extern int gvLayout(GVC_t* gvc, graph_t* graph, const char* engine);
extern int gvLayoutJobs(GVC_t* gvc, graph_t* graph);
extern void attach_attrs(graph_t* graph);
extern int gvRender(GVC_t* gvc, graph_t* graph, const char* format, FILE* out_fp);
extern int gvRenderFilename(GVC_t* gvc, graph_t* graph, const char* format, const char* filename);
extern int gvRenderContext(GVC_t* gvc, graph_t* graph, const char* format, void* context);
extern int gvRenderData(GVC_t* gvc, graph_t* graph, const char* format, char** result, uint32_t* length);
extern int gvRenderJobs(GVC_t* gvc, graph_t* graph);
extern int gvFreeLayout(GVC_t* gvc, graph_t* graph);
extern void gvFinalize(GVC_t* gvc);
extern int gvFreeContext(GVC_t* gvc);
