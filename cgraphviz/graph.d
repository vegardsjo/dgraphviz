module cgraphviz.graph;

import std.stdint;
import std.c.stdio;

// Wrapper of init function
extern (C) void aginit_wrapper();
alias aginit_wrapper aginit;

alias void Agraph_t;
alias void Agnode_t;
alias void Agedge_t;
alias void Agsym_t;

alias Agraph_t graph_t;
alias Agnode_t node_t;
alias Agedge_t edge_t;
alias Agsym_t attrsym_t;

const string TAIL_ID = "tailport";
const string HEAD_ID = "headport";

const long AGFLAG_DIRECTED = 1<<0;
const long AGFLAG_STRICT = 1<<1;
const long AGFLAG_METAGRAPH = 1<<2;

const long AGRAPH = 0;
const long AGRAPHSTRICT = AGRAPH | AGFLAG_STRICT;
const long AGDIGRAPH = AGFLAG_DIRECTED;
const long AGDIGRAPHSTRICT = AGDIGRAPH | AGFLAG_STRICT;
const long AGMETAGRAPH = AGFLAG_DIRECTED | AGFLAG_STRICT | AGFLAG_METAGRAPH;

//long AG_IS_DIRECTED(g)  ((g)->kind & AGFLAG_DIRECTED)
//long AG_IS_STRICT(g)    ((g)->kind & AGFLAG_STRICT)
//long AG_IS_METAGRAPH(g)  ((g)->kind & AGFLAG_METAGRAPH)

//#define aginit()      aginitlib(sizeof(Agraph_t),sizeof(Agnode_t),sizeof(Agedge_t))
//#define agobjkind(p)    ((agobjkind_t)(((Agraph_t*)(p))->tag))
//#define agmetanode(g)    ((g)->meta_node)

enum agobjkind_t { AGNODE = 1, AGEDGE, AGGRAPH };
enum agerrlevel_t { AGWARN, AGERR, AGMAX, AGPREV };

alias char* function(char* ubuf, int n, FILE* fp) gets_f;
alias int function(char*) agusererrf;

extern (C):
extern char* agstrcanon(const char*, const char*);
extern char* agcanonical(const char*);
extern char* agcanon(const char*);
extern int aghtmlstr(const char* s);
extern char* agget(void*, const char*);
extern char* agxget(void*, int);
extern int agset(void*, const char*, const char*);
extern int agsafeset(void*, const char*, const char*, const char*);
extern int agxset(void*, int, const char*);
extern int agindex(void*, const char*);

//extern void aginitlib(int, int, int);
extern void* agopen(const char*, int);
extern void* agsubg(Agraph_t*, const char*);
extern void* agfindsubg(Agraph_t*, const char*);
extern void agclose(Agraph_t*);
extern void* agread(FILE*);
extern void* agread_usergets(FILE*, gets_f);
extern void agreadline(int);
extern void agsetfile(const char*);
extern void* agmemread(const char*);
extern void agsetiodisc(
        char* function(char* s, int size, FILE* stream) myfgets,
        size_t function (const void* ptr, size_t size, size_t nmemb, FILE* stream) myfwrite,
        int function(FILE* stream) myferror
);

extern int agputs(const char* s, FILE* fp);
extern int agputc(int c, FILE* fp);
extern int agwrite(void*, FILE*);
extern int agerrors();
extern int agreseterrors();
extern void* agprotograph();
extern void* agprotonode(Agraph_t*);
extern void* agprotoedge(Agraph_t*);
extern void* agusergraph(Agraph_t*);
extern int agnnodes(Agraph_t*);
extern int agnedges(Agraph_t*);

extern void aginsert(Agraph_t*, void*);
extern void agdelete(Agraph_t*, void*);
extern int agcontains(Agraph_t*, void*);

extern Agnode_t* agnode(Agraph_t*, const char*);
extern Agnode_t* agfindnode(Agraph_t*, const char*);
extern Agnode_t* agfstnode(Agraph_t*);
extern Agnode_t* agnxtnode(Agraph_t*, Agnode_t*);
extern Agnode_t* aglstnode(Agraph_t*);
extern Agnode_t* agprvnode(Agraph_t*, Agnode_t*);

extern Agedge_t* agedge(Agraph_t*, Agnode_t*, Agnode_t*);
extern Agedge_t* agfindedge(Agraph_t*, Agnode_t*, Agnode_t*);
extern Agedge_t* agfstedge(Agraph_t*, Agnode_t*);
extern Agedge_t* agnxtedge(Agraph_t*, Agedge_t*, Agnode_t*);
extern Agedge_t* agfstin(Agraph_t*, Agnode_t*);
extern Agedge_t* agnxtin(Agraph_t*, Agedge_t*);
extern Agedge_t* agfstout(Agraph_t*, Agnode_t*);
extern Agedge_t* agnxtout(Agraph_t*, Agedge_t*);

extern Agsym_t* agattr(void*, const char*, const char*);
extern Agsym_t* agraphattr(Agraph_t*, const char*, const char*);
extern Agsym_t* agnodeattr(Agraph_t*, const char*, const char*);
extern Agsym_t* agedgeattr(Agraph_t*, const char*, const char*);
extern Agsym_t* agfindattr(void*, const char*);
extern Agsym_t* agfstattr(void*);
extern Agsym_t* agnxtattr(void*, Agsym_t*);
extern Agsym_t* aglstattr(void*);
extern Agsym_t* agprvattr(void*, Agsym_t*);
extern int agcopyattr(void*, void*);  

extern agerrlevel_t agerrno;
extern void agseterr(agerrlevel_t);
extern char* aglasterr();
extern int agerr(agerrlevel_t level, const char* fmt, ...);
extern void agerrorf(const char* fmt, ...);
extern void agwarningf(const char* fmt, ...);
    
extern char* agstrdup(const char*);
extern char* agstrdup_html(const char* s);
extern void agstrfree(const char*);

extern agusererrf agseterrf(agusererrf);
