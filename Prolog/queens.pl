sel(X, [X|Y], Y).
sel(U, [X|Y], [X|V]) :- sel(U,Y,V).

safe([ ]).
safe([X|Y]) :- check(X,Y), safe(Y).

check(_,[ ]).
check(P, [Q|R]) :- 
	not_on_diag(P,Q), check(P,R).

not_on_diag(p(X1,Y1),p(X2,Y2)) :-
	DX is X1-X2, DY is Y1-Y2, 
	MDY is Y2-Y1, DX=\=DY, DX=\=MDY.

queens(Rows, [Col|RestCols], Points):-
	sel(Row,Rows,RestRows),
	safe([p(Row,Col) | Points]),
	queens(RestRows,RestCols,
		[p(Row,Col) | Points]).

queens( [ ], [ ], Points) :-
	print('Solution: '),print(Points),nl.

?- queens([1,2,3,4,5,6,7,8],
               [1,2,3,4,5,6,7,8], [ ]), fail.
