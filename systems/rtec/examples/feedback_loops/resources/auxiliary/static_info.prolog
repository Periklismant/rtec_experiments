appVars(simple_neg, [x, y]).
appVars(immune_g, [h, s]).
appVars(phage_g, [cI, cro, cII, n]).

%variable(x).
%variable(y).

%variable(h).
%variable(s).

%variable(cI).
%variable(cro).
%variable(cII).
%variable(n).

var_value(x,0).
var_value(x,1).
var_value(y,0).
var_value(y,1).

var_value(h,0).
var_value(h,1).
var_value(h,2).
var_value(s,0).
var_value(s,1).
var_value(s,2).

var_value(cI,0).
var_value(cI,1).
var_value(cI,2).
var_value(cro,0).
var_value(cro,1).
var_value(cro,2).
var_value(cro,3).
var_value(cII,0).
var_value(cII,1).
var_value(n,0).
var_value(n,1).

sign(incr).
sign(decr).

deadline(x,incr,2).
deadline(x,decr,2).
deadline(y,incr,2).
deadline(y,decr,2).

%deadline(h,incr,6).
%deadline(h,decr,6).
%deadline(s,incr,6).
%deadline(s,decr,6).


%% e100_a
deadline(h,incr,1).
deadline(h,decr,1).
deadline(s,incr,1).
deadline(s,decr,2).

%deadline(cI,incr,2).
%deadline(cI,decr,2).
%deadline(cro,incr,2).
%deadline(cro,decr,2).
%deadline(cII,incr,2).
%deadline(cII,decr,2).
%deadline(n,incr,2).
%deadline(n,decr,2).

%% phage_4_immune
%% phage_4_lysis_1, first choice
deadline(cI,incr,3).
deadline(cI,decr,4).
deadline(cro,incr,1).
deadline(cro,decr,1).
deadline(cII,incr,1).
deadline(cII,decr,2).
deadline(n,incr,1).
deadline(n,decr,2).

boolean_not(0,1).
boolean_not(1,0).

getVarVals([], []).

getVarVals([Var|RestVars], [Val|RestVals]):-
	var_value(Var, Val),
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

retractInitially([]).

retractInitially([Var|RestVars]):-
	retractall((initiatedAt(val(Var)=_, Ts, 0, Te) :- Ts=<0, 0<Te)),
	retractInitially(RestVars).

assertInitially([], []).

assertInitially([Var|RestVars], [Val|RestVals]):-
	assertz((initiatedAt(val(Var)=Val, Ts, 0, Te) :- Ts=<0, 0<Te)),
	assertInitially(RestVars, RestVals).

assertVariables0([]).

assertVariables0([Var|RestVars]):-
	assertz((variable(Var))),
	assertVariables0(RestVars).

assertVariables(App):-
	appVars(App, Vars),
	assertVariables0(Vars).
