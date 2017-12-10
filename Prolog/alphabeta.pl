/* alpha is the minimal value of max nodes; already guaranteed to achieve,
   beta is the maximum (worst) value of min nodes; guaranteed to achieve 
   Root's backed-up value is in the interval [alpha,beta]  */
/* Interval gets smaller as search progresses */

alphabeta(Pos,Alpha,Beta,GoodPos,Val) :-
   moves(Pos,PosList), !,    /*user-provided*/
   boundedbest(PosList,Alpha,Beta,GoodPos,Val).
alphabeta(Pos,_,_,_,Val) :- staticval(Pos,Val).  /*user-provided*/

boundedbest([Pos | PosList], Alpha, Beta, GoodPos, GoodVal) :-
   alphabeta(Pos,Alpha, Beta, _, Val),
   goodenough(PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal).

goodenough([],_,_,Pos,Val,Pos,Val) :- !.
goodenough(_, _Alpha, Beta, Pos, Val, Pos, Val) :-
   min_to_move(Pos), Val>Beta, !.    /*Maximizer attained upper bound*/
goodenough(_,Alpha,_Beta,Pos,Val,Pos,Val) :- 
   max_to_move(Pos), Val<Alpha, !.   /*Minimizer attained lower bound*/

goodenough(PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal) :-
   newbounds(Alpha, Beta, Pos,Val, NewAlpha, NewBeta),
   boundedbest(PosList, NewAlpha, NewBeta, Pos1, Val1),
   betterof(Pos, Val, Pos1, Val1, GoodPos, GoodVal).

newbounds(Alpha, Beta, Pos, Val, Val, Beta) :-
   min_to_move(Pos), Val>Alpha, !.   /*Maximizer increased the lower bound*/
newbounds(Alpha,Beta, Pos, Val, Alpha, Val) :- 
   max_to_move(Pos), Val<Beta, !.    /*Minimizer decreased the upper bound*/
newbounds(Alpha, Beta,_,_,Alpha, Beta).

betterof(Pos, Val, _Pos1, Val1, Pos, Val) :-
   min_to_move(Pos), Val>Val1, !.
betterof(Pos, Val, _Pos1, Val1, Pos,Val) :-
   max_to_move(Pos), Val<Val1, !.
betterof(_,_,Pos1,Val1,Pos1,Val1).
