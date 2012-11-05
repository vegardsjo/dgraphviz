all: graphviz.a

graphviz.a: graphviz.d cgraphviz/graph.d cgraphviz/gvc.d cgraphviz/graphviz_wrapper.o
	dmd graphviz.d cgraphviz/graphviz_wrapper.o -L-lgraph -L-lgvc -lib

cgraphviz/graphviz_wrapper.o: cgraphviz/graphviz_wrapper.c
	gcc -c $< -o $@

