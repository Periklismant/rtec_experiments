% the predicate below works under the assumption that the lists of 
% initiating and terminating points are temporally sorted

makeIntervalsFromSEPoints([Ts], EPoints, [Period]) :-
	member(Tf, EPoints), 
	Ts<Tf, !,  
	Period = (Ts,Tf).

makeIntervalsFromSEPoints([Ts], _EPoints, [Period]) :- !,
	Period = (Ts,inf).    % simpler to deal with than since(Ts).

makeIntervalsFromSEPoints([Ts,Tnext|MoreTs], EPoints, [Period|MorePeriods]) :-
	member(Tf, EPoints), 
	Ts<Tf,
	(
		Tf<Tnext,
		Period=(Ts,Tf),
		append( _, [Tf|MoreEPoints], EPoints ), !,
		makeIntervalsFromSEPoints([Tnext|MoreTs], MoreEPoints, MorePeriods)
		;
		% U is neither initiated nor terminated between Ts and Tnext
		% need to amalgamate (Ts,Tnext) with next period found
		% Period=(Ts,Tf)
		% makeIntervalsFromSEPoints([Tnext|MoreTs], U, [(Tnext,Tf)|MorePeriods])	
		Period=(Ts,Tf), 
		MorePeriods=MoreX, 
        	append( _, [Tf|MoreEPoints], EPoints ), !,
		makeIntervalsFromSEPoints([Tnext|MoreTs], [Tf|MoreEPoints], [(Tnext,Tf)|MoreX])
	).

makeIntervalsFromSEPoints([Ts,_Tnext|_MoreTs], _EPoints, [(Ts,inf)]).
