/* Nichollette Acosta - ITCS 3153 Prolog Practice */

/* The program uses "depth first" search (DFS) algorithm to search a */
/* graph. If two nodes, a and b, in the graph have an edge that connects them */
/* then it is represented as edge(a,b) */

?- list.

search(X,X,T) .
search(X,Y,T) :- (edge(X,Z); edge(X,Z)),
				 not(member(Z,T)),
				 search(Z, Y, [Z|T]).
				 
member(X, [X |_]) := !.
member(X, [_|Y]) :- member(X, Y).

edge(g,h).    edge(g,d).     edge(e,d).      edge(h,f).     edge(e,f).
edge(a,e).    edge(a,b).     edge(b,f).      edge(b,c).     edge(f,c).