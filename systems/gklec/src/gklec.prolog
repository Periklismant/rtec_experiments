:- dynamic cached/1, initially/1.

:- discontiguous initially/1, happens/2, delay/3, overrides/3, varVal/2, appVars/2, varValInit/2.

boolean_not(0,1).
boolean_not(1,0).

%======== domain-independent 'happens' ======% 

% There is a tick event at each time-point of the window.
happens(tick,T):-
	endReasoningTime(EndReasoningTime),
	T>=0, T=<EndReasoningTime.

% We compute happens/2 by consulting the cache.
happens(occurs(FX, V), T):-
	cached(happens(occurs(FX, V), T)), 
	!.

%======== Simple feedback loop ==============%

appVars(simple_neg, [x, y]).

varVal(x, 0).
varVal(x, 1).
varVal(y, 0).
varVal(y, 1).

varValInit(x, 0).
varValInit(x, 1).
varValInit(y, 0).
varValInit(y, 1).

% These are commented out because the initial variable values are asserted by the query helper predicates (see the end of the file).
%initially(val(x,0)).
%initially(val(y,0)).

delay(x,incr,2).
delay(x,decr,2).
delay(y,incr,2).
delay(y,decr,2).

/***********************************
 *  Table of variable states *
   
   | x | y | f(x) | f(y) |
   | 0 | 0 |  1   |  0   |
   | 0 | 1 |  0   |  0   |
   | 1 | 0 |  1   |  1   |
   | 1 | 1 |  0   |  1   |

***********************************/

happens(occurs(f(x), V2), 1):-
	initially(val(y, V1)),
	boolean_not(V1, V2), 
	assertz(cached(happens(occurs(f(x), V2), 1))).

happens(occurs(f(y), V), 1):-
	initially(val(x, V)), 
	assertz(cached(happens(occurs(f(y), V), 1))).

happens(occurs(f(x), V2), T):-
	holds(val(y, V1), T),
	boolean_not(V1,V2), 
	assertz(cached(happens(occurs(f(x), V2), T))).

happens(occurs(f(y), V), T):-
	holds(val(x, V), T), 
	assertz(cached(happens(occurs(f(y), V), T))).

%======== IMMUNE_G feedback loop ========%

appVars(immune_g, [h, s]).

varVal(h, 0).
varVal(h, 1).
varVal(h, 2).
varVal(s, 0).
varVal(s, 1).
varVal(s, 2).

varValInit(h, 0).
varValInit(h, 1).
varValInit(s, 0).
varValInit(s, 1).
varValInit(s, 2).

%initially(val(h,0)).
%initially(val(s,0)).

delay(h,incr,1).
delay(h,decr,1).
delay(s,incr,1).
delay(s,decr,2).

/*
has_value(antigen, 1, T):-
    TDivTen is T//10,
    Mod is TDivTen mod 2,
    Mod=1.

has_value(antigen, 0, T):-
    TDivTen is T//10,
    Mod is TDivTen mod 2,
    Mod=0.
*/

/***********************************
 *  Table of variable states *
   
   | h | s | f(h) | f(s) |
   | 0 | 0 |  1   |  0   |
   | 0 | 1 |  0   |  0   |
   | 0 | 2 |  0   |  1   |
   | 1 | 0 |  1   |  1   |
   | 1 | 1 |  1   |  2   |
   | 1 | 2 |  0   |  2   |
   | 2 | 0 |  2   |  1   |
   | 2 | 1 |  2   |  2   |
   | 2 | 2 |  2   |  2   |

 ***********************************/

happens(occurs(f(h), 0), T):-
	holds(val(h, 0), T), 
        pos(val(s, 1), T),
	assertz(cached(happens(occurs(f(h), 0), T))).

happens(occurs(f(h), 0), T):-
	holds(val(h, 1), T), 
	holds(val(s, 2), T), 
	assertz(cached(happens(occurs(f(h), 0), T))).

happens(occurs(f(h), 1), T):-
	holds(val(h, 0), T), 
	holds(val(s, 0), T), 
	assertz(cached(happens(occurs(f(h), 1), T))).
	
happens(occurs(f(h), 1), T):-
	holds(val(h, 1), T), 
	neg(val(s, 2), T), 
	assertz(cached(happens(occurs(f(h), 1), T))).

happens(occurs(f(h), 2), T):-
	holds(val(h, 2), T), 
	assertz(cached(happens(occurs(f(h), 2), T))).


happens(occurs(f(s), 0), T):-
	holds(val(h, 0), T), 
	neg(val(s, 2), T),
	assertz(cached(happens(occurs(f(s), 0), T))).

happens(occurs(f(s), 1), T):-
	holds(val(h, 0), T), 
	holds(val(s, 2), T), 
	assertz(cached(happens(occurs(f(s), 1), T))).

happens(occurs(f(s), 1), T):-
	pos(val(h, 1), T), 
	holds(val(s, 0), T), 
	assertz(cached(happens(occurs(f(s), 1), T))).

happens(occurs(f(s), 2), T):-
	pos(val(h, 1), T), 
	pos(val(s, 1), T), 
	assertz(cached(happens(occurs(f(s), 2), T))).

%======== PHAGE_G feedback loop ========%

appVars(phage_g, [cI, cro, cII, n]).

varVal(cI, 0).
varVal(cI, 1).
varVal(cI, 2).
varVal(cro, 0).
varVal(cro, 1).
varVal(cro, 2).
varVal(cro, 3).
varVal(cII, 0).
varVal(cII, 1).
varVal(n, 0).
varVal(n, 1).

varValInit(cI, 0).
varValInit(cI, 1).
varValInit(cI, 2).
varValInit(cro, 0).
varValInit(cro, 1).
varValInit(cro, 2).
varValInit(cro, 3).
varValInit(cII, 0).
varValInit(cII, 1).
varValInit(n, 0).
varValInit(n, 1).

%initially(val(cI,0)).
%initially(val(cro,0)).
%initially(val(cII,0)).
%initially(val(n,0)).

delay(cI,incr,3).
delay(cI,decr,4).
delay(cro,incr,1).
delay(cro,decr,1).
delay(cII,incr,1).
delay(cII,decr,2).
delay(n,incr,1).
delay(n,decr,2).

/***********************************
 *  Table of variable states *
   
   | cI | cro | cII  |  n   | f(cI) | f(cro) | f(cII) | f(n)
   | 0  | 0   |  0   |  0   |  	2   |   3    |   0    |  1  
   | 0  | 0   |  0   |  1   |   2   |   3    |   1    |  1
   | 0  | 0   |  1   |  0   |   2   |   3    |   0    |  1
   | 0  | 0   |  1   |  1   |   2   |   3    |   1    |  1
   | 0  | 1   |  0   |  0   |   0   |   3    |   0    |  1 	
   | 0  | 1   |  0   |  1   |   0   |   3    |   1    |  1
   | 0  | 1   |  1   |  0   |   0   |   3    |   0    |  1
   | 0  | 1   |  1   |  1   |   0   |   3    |   1    |  1
   | 0  | 2   |  0   |  0   |   0   |   3    |   0    |  0 	
   | 0  | 2   |  0   |  1   |   0   |   3    |   1    |  0
   | 0  | 2   |  1   |  0   |   0   |   3    |   0    |  0
   | 0  | 2   |  1   |  1   |   0   |   3    |   1    |  0
   | 0  | 3   |  0   |  0   |   0   |   2    |   0    |  0 	
   | 0  | 3   |  0   |  1   |   0   |   2    |   0    |  0
   | 0  | 3   |  1   |  0   |   0   |   2    |   0    |  0
   | 0  | 3   |  1   |  1   |   0   |   2    |   0    |  0
   | 1  | 0   |  0   |  0   |   2   |   3    |   0    |  0 	
   | 1  | 0   |  0   |  1   |   2   |   3    |   1    |  0
   | 1  | 0   |  1   |  0   |   2   |   3    |   0    |  0
   | 1  | 0   |  1   |  1   |   2   |   3    |   1    |  0
   | 1  | 1   |  0   |  0   |   0   |   3    |   0    |  0 	
   | 1  | 1   |  0   |  1   |   0   |   3    |   1    |  0
   | 1  | 1   |  1   |  0   |   0   |   3    |   0    |  0
   | 1  | 1   |  1   |  1   |   0   |   3    |   1    |  0
   | 1  | 2   |  0   |  0   |   0   |   3    |   0    |  0 	
   | 1  | 2   |  0   |  1   |   0   |   3    |   1    |  0
   | 1  | 2   |  1   |  0   |   0   |   3    |   0    |  0
   | 1  | 2   |  1   |  1   |   0   |   3    |   1    |  0
   | 1  | 3   |  0   |  0   |   0   |   2    |   0    |  0 	
   | 1  | 3   |  0   |  1   |   0   |   2    |   0    |  0
   | 1  | 3   |  1   |  0   |   0   |   2    |   0    |  0
   | 1  | 3   |  1   |  1   |   0   |   2    |   0    |  0
   | 2  | 0   |  0   |  0   |   2   |   0    |   0    |  0 	
   | 2  | 0   |  0   |  1   |   2   |   0    |   0    |  0
   | 2  | 0   |  1   |  0   |   2   |   0    |   0    |  0
   | 2  | 0   |  1   |  1   |   2   |   0    |   0    |  0
   | 2  | 1   |  0   |  0   |   0   |   0    |   0    |  0 	
   | 2  | 1   |  0   |  1   |   0   |   0    |   0    |  0
   | 2  | 1   |  1   |  0   |   0   |   0    |   0    |  0
   | 2  | 1   |  1   |  1   |   0   |   0    |   0    |  0
   | 2  | 2   |  0   |  0   |   0   |   0    |   0    |  0 	
   | 2  | 2   |  0   |  1   |   0   |   0    |   0    |  0
   | 2  | 2   |  1   |  0   |   0   |   0    |   0    |  0
   | 2  | 2   |  1   |  1   |   0   |   0    |   0    |  0
   | 2  | 3   |  0   |  0   |   0   |   0/2  |   0    |  0 	
   | 2  | 3   |  0   |  1   |   0   |   0/2  |   0    |  0
   | 2  | 3   |  1   |  0   |   0   |   0/2  |   0    |  0
   | 2  | 3   |  1   |  1   |   0   |   0/2  |   0    |  0

 ***********************************/
happens(occurs(f(cI), 2), T):-
	neg(val(cro, 1), T),
	assertz(cached(happens(occurs(f(cI), 2), T))).

happens(occurs(f(cI), 0), T):-
	pos(val(cro, 1), T), 
	assertz(cached(happens(occurs(f(cI), 0), T))).

happens(occurs(f(cro), 3), T):-
	neg(val(cI, 2), T),
	neg(val(cro, 3), T), 
	assertz(cached(happens(occurs(f(cro), 3), T))).

happens(occurs(f(cro), 0), T):-
	pos(val(cI, 2), T), 
	assertz(cached(happens(occurs(f(cro), 0), T))).
	
happens(occurs(f(cro), 2), T):-
	pos(val(cro, 3), T), 
        neg(val(cI, 2), T),
	assertz(cached(happens(occurs(f(cro), 2), T))).

happens(occurs(f(cII), 0), T):-
	neg(val(n, 1), T), 
	assertz(cached(happens(occurs(f(cII), 0), T))).

happens(occurs(f(cII), 1), T):-
	neg(val(cI, 2), T),
	neg(val(cro, 3), T),
	pos(val(n, 1), T), 
	assertz(cached(happens(occurs(f(cII), 1), T))).

happens(occurs(f(cII), 0), T):-
	pos(val(cI, 2), T), 
	assertz(cached(happens(occurs(f(cII), 0), T))).

happens(occurs(f(cII), 0), T):-
	pos(val(cro, 3), T), 
	assertz(cached(happens(occurs(f(cII), 0), T))).

happens(occurs(f(n), 1), T):-
	neg(val(cI, 1), T),
	neg(val(cro, 2), T), 
	assertz(cached(happens(occurs(f(n), 1), T))).

happens(occurs(f(n), 0), T):-
	pos(val(cI, 1), T),
	assertz(cached(happens(occurs(f(n), 0), T))).

happens(occurs(f(n), 0), T):-
	pos(val(cro, 2), T),
	assertz(cached(happens(occurs(f(n), 0), T))).

%======== domain-independent 'pos/neg' ======%

pos(val(Var, V),T):-
	holds(val(Var, V1), T), 
	V1 >= V. 
	
neg(val(Var, V),T):-
	holds(val(Var, V1), T), 
	V1 < V.

%======== domain-independent 'holds' ========%

holds(val(X, V), T):-
	cached(holds(val(X, V), T)), 
	!.

holds(val(X,V), 0):-
	initially(val(X,V)), 
	assertz(cached(holds(val(X, V), 0))).

holds(val(X,V), Tk):-
	Tk>0,
	happens(tick,Tk),
	initiates(Event,val(X,V),[Ti,Tk]),
	\+ clipped(Event,val(X,V),[Ti,Tk]),
	assertz(cached(holds(val(X, V), Tk))).

clipped(Event, val(X,V), [Ti,Tk]):-
	terminates(Event, val(X,V),[Ti,Tk]).

%======== domain-independent 'initiates' ====%

initiates(_, val(X,Vk), [_, T]):-
	T=<0, !,
	initially(val(X, Vk)).

initiates(occurs(f(X),Vi), val(X,Vk), [Ti,Tk]):-
	delay(X, incr, D),
	Ti is Tk - D,
	Ti>0,
	happens(occurs(f(X),Vi), Ti),
	rate(X, Tk, D, Ri),
	Ri>0,
	rate(X, Tk, 1, RkMinusOne),
	RkMinusOne > 0,
	TkMinusOne is Tk - 1,
	holds(val(X,VkAtPrev), TkMinusOne),
	Vk is VkAtPrev + 1.

initiates(occurs(f(X),Vi), val(X,Vk), [Ti,Tk]):-
	delay(X, decr, D),
	Ti is Tk - D,
	Ti>0,
	happens(occurs(f(X),Vi), Ti),
	rate(X, Tk, D, Ri),
	Ri<0,
	rate(X, Tk, 1, RkMinusOne),
	RkMinusOne < 0,
	TkMinusOne is Tk - 1,
	holds(val(X,VkAtPrev), TkMinusOne),
	Vk is VkAtPrev - 1.

initiates(tick, val(X,V), [Ti, Tk]):-
	Ti is Tk - 1,
	Ti >= 0,
	happens(tick, Ti),
	holds(val(X,V), Ti).

rate(X, T, D, R):-
	Td is T - D,
	Td>0,
	happens(occurs(f(X), V1), Td),
	holds(val(X, V), Td),
	R is V1 - V. 

%======== domain-independent 'terminates' ===%

terminates(occurs(f(X), _Vi), val(X, _Vk), [Ti, Tk]):-
	TkMinusOne is Tk - 1, 
	TkMinusOne > 0,
	fchanges(f(X), Ti, TkMinusOne). % removed cut.

terminates(tick, val(X, Vk), [TkMinusOne, Tk]):-
	TkMinusOne is Tk - 1,
	TkMinusOne > 0,
	initiates(occurs(f(X),Vi), val(X,Vk2), [Ti, Tk]), \+Vk2=Vk,
	\+ terminates(occurs(f(X), Vi), val(X, Vk2), [Ti, Tk]).

fchanges(f(X), T1, T2):-
	T1 =< T2, 
	happens(occurs(f(X), V1), T1),
	happens(occurs(f(X), V2), T2),
	\+V1=V2, !.
	
fchanges(f(X), T1, T2):-
	T1<T2,
	T is T1 + 1, 
	fchanges(f(X), T, T2).

%========= UTILS ================% 

handleProlog(yap, cputime) :-
	current_prolog_flag(dialect, yap).
handleProlog(swi, runtime) :-
	current_prolog_flag(dialect, swi).

getCPUtime(T):-
	current_prolog_flag(dialect, Prolog),
	handleProlog(Prolog, TimeOption),
	statistics(TimeOption, [T,_]).

%========= QUERIES ===============% 

runQueryForAllInitCombinations([], _, _, _).

runQueryForAllInitCombinations([InitValsList|RestInitValsLists], App, EndTime, TimesFileStream):-
	assertInits(App, InitValsList),
        write('\t\t\tInitial values:'),
	findall(_, (initially(val(F,V)), write(' '), write(F), write('='), write(V)),_), 
        nl,
	produceLogFileInits(App, EndTime, InitValsList, LogFile),
        %write('Logfile: '), write(LogFile), nl,
	getCPUtime(Tstart),
	query(App, EndTime, LogFile),
	getCPUtime(Tend),
	Tdiff is Tend - Tstart,
        write('\t\t\tReasoning time: '), write(Tdiff), write('ms'), nl,
	write(TimesFileStream, Tdiff), nl(TimesFileStream),
	retractInits(App),
	retractAllCached,
	runQueryForAllInitCombinations(RestInitValsLists, App, EndTime, TimesFileStream).

runQueryAllInits(App, EndTime):-
	retractInits(App),
	retractAllCached,
	produceTimesFile(App, EndTime, TimesFile),
	open(TimesFile, write, TimesFileStream),
	findall(InitValsList, valsTuple(App, InitValsList), ListOfInitValsLists),
	runQueryForAllInitCombinations(ListOfInitValsLists, App, EndTime, TimesFileStream),
	close(TimesFileStream).

query(App, EndTime, LogFile):-
	open(LogFile, write, LogFileStream),
	write(LogFileStream, 'Application: '), write(LogFileStream, App), nl(LogFileStream),
	write(LogFileStream, 'Running Feedback Loop for all time-points in (0, '), write(LogFileStream, EndTime), write(LogFileStream, '].'), nl(LogFileStream),
	assertz(endReasoningTime(EndTime)),
	appVars(App, Vars),
	getCPUtime(Tstart),
	runQueries(Vars, 1, EndTime, LogFileStream),
	getCPUtime(Tend),
	Tdiff is Tend - Tstart, 
	nl(LogFileStream),
	write(LogFileStream, 'Execution Time for '), write(LogFileStream, EndTime), write(LogFileStream, ' time-points is: '), write(LogFileStream, Tdiff), nl(LogFileStream),
	close(LogFileStream),
	retract(endReasoningTime(EndTime)).

checkAllVars([], _, _).
checkAllVars([Var|RestVars], T, LogFileStream):-
	findall(Val, (varVal(Var, Val), 
					holds(val(Var, Val), T), write(LogFileStream, 'holdsAt(val('), write(LogFileStream, Var), write(LogFileStream, ','), 
					write(LogFileStream, Val), write(LogFileStream, '),'), write(LogFileStream, T), write(LogFileStream, ').'), nl(LogFileStream)), _),
	checkAllVars(RestVars, T, LogFileStream).

checkAllFVars([], _, _).
checkAllFVars([Var|RestVars], T, LogFileStream):-
	findall(Val, (varVal(Var, Val), 
					happens(occurs(f(Var), Val), T), write(LogFileStream, 'happens(occurs(f('), write(LogFileStream, Var), 
					write(LogFileStream, '),'), write(LogFileStream, Val), write(LogFileStream, '),'), write(LogFileStream, T), 
					write(LogFileStream, ').'), nl(LogFileStream)), _),
	checkAllFVars(RestVars, T, LogFileStream).

runQueries(_, T, Tend, _):-
	T>Tend, !.

runQueries(Vars, T, Tend, LogFileStream):-
	checkAllVars(Vars, T, LogFileStream),
	checkAllFVars(Vars, T, LogFileStream),
	Tnext is T + 1,
	runQueries(Vars, Tnext, Tend, LogFileStream).

%========= QUERY HELPERS =========% 

retractAllCached:-
	retractall((cached(_))).

assertAllVarInits([], []).

assertAllVarInits([Var|RestVars], [Val|RestVals]):-
	assertz(initially(val(Var,Val))),
	assertAllVarInits(RestVars, RestVals).

assertInits(App, InitValsList):-
	appVars(App, VarsList),
	assertAllVarInits(VarsList, InitValsList).

retractAllVarInits([]).

retractAllVarInits([Var|RestVars]):-
	retractall((initially(val(Var,_)))),
	retractAllVarInits(RestVars).

retractInits(App):-
	appVars(App, VarsList),
	retractAllVarInits(VarsList).

getVarVals([], []).

getVarVals([Var|RestVars], [Val|RestVals]):-
	varValInit(Var, Val),
	getVarVals(RestVars, RestVals).

valsTuple(App, ValsList):-
	appVars(App, VarsList),
	getVarVals(VarsList, ValsList).

valsToNum0([], _, NumID, NumID).
	
valsToNum0([Val|RestVals], Counter, CurrNum, Result):-
	ValID is Val*Counter,
	NextCurrNum is CurrNum + ValID,
	NewCounter is Counter*10,
	valsToNum0(RestVals, NewCounter, NextCurrNum, Result). 

valsToNum(Vals, NumID):-
	valsToNum0(Vals, 1, 0, NumID).

produceLogFileInits(App, EndTime, InitValsList, LogFile):-
	atom_concat('../../../logs/gklec/results-', App, LogFilePrefix0),
	atom_concat(LogFilePrefix0, '-', LogFilePrefix1),
	atom_number(EndTimeStr, EndTime),
	atom_concat(LogFilePrefix1, EndTimeStr, LogFilePrefix2),
	atom_concat(LogFilePrefix2, '-', LogFilePrefix3),
	valsToNum(InitValsList, NumID),
	atom_number(NumIDStr, NumID),
	atom_concat(LogFilePrefix3, NumIDStr, LogFile0),
	atom_concat(LogFile0, '.txt', LogFile).

produceLogFile(App, EndTime, LogFile):-
	atom_concat('../../../logs/gklec/results-', App, LogFilePrefix0),
	atom_concat(LogFilePrefix0, '-', LogFilePrefix1),
	atom_number(EndTimeStr, EndTime),
	atom_concat(LogFilePrefix1, EndTimeStr, LogFilePrefix2),
	atom_concat(LogFilePrefix2, '.txt', LogFile).

produceTimesFile(App, EndTime, TimesFile):-
	atom_concat('../../../logs/gklec/times-', App, TimesFilePrefix0),
	atom_concat(TimesFilePrefix0, '-', TimesFilePrefix1),
	atom_number(EndTimeStr, EndTime),
	atom_concat(TimesFilePrefix1, EndTimeStr, TimesFilePrefix2),
	atom_concat(TimesFilePrefix2, '.txt', TimesFile).


