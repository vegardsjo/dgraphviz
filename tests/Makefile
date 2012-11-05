all: funnygraph

funnygraph: funnygraph.d ../graphviz.a
	dmd -I.. $@ ../graphviz.a -L-lgraph -L-lgvc
