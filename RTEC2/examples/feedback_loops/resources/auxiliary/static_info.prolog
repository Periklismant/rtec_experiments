:- dynamic variable/1, var_value/2, sign/1.

% Supported feedback loops.
% See 'examples/feedback_loops/resources/patterns/feedback_loops_rules_compiled.prolog' for the event descriptions of these loops.
% See "Learning explanations for biological feedback with delays using an event calculus" for more details.
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

% simple_neg variable-value pairs
var_value(x,0).
var_value(x,1).
var_value(y,0).
var_value(y,1).

% immune_g variable-value pairs
var_value(h,0).
var_value(h,1).
var_value(h,2).
var_value(s,0).
var_value(s,1).
var_value(s,2).

% phage_g variable-value pairs
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

% a variable can increase or decrease
sign(incr).
sign(decr).

% In biological feedback loops, variables are increased or decreased by 1 at a specified time after its corresponding function becomes greater or lesser than its value.
% This temporal delay is declared with the deadline/3 predicate. 
% For example, the value of x increases by one 3 time-points after the value of f(x) becomes greater than x.
% Note that such deadlines may be cancelled. For instance, if the value of f(x) drops below that of x before the 3 time-points pass, the staged increase of x does not take place.
% deadline values for simple_neg
% deadline(Var,Sign,DeadlineLength)
deadline(x,incr,3).
deadline(x,decr,3).
deadline(y,incr,7).
deadline(y,decr,7).

%% This is one of the deadline value combinations learnt in the work of Srinivasan ("Learning explanations for biological feedback with delays using an event calculus")
%% It is presented in the Appendix and its label is: e100_a 
% deadline values for immune_g
deadline(h,incr,1).
deadline(h,decr,1).
deadline(s,incr,1).
deadline(s,decr,2).

%% This is one of the deadline value combinations learnt in the work of Srinivasan ("Learning explanations for biological feedback with delays using an event calculus")
%% It is presented in the Appendix and its label is: phage_4_lysis_1 
% deadline values for phage_g
deadline(cI,incr,3).
deadline(cI,decr,4).
deadline(cro,incr,1).
deadline(cro,decr,1).
deadline(cII,incr,1).
deadline(cII,decr,2).
deadline(n,incr,1).
deadline(n,decr,2).

%boolean_not(?X,?NotX)
boolean_not(0,1).
boolean_not(1,0).

% Returns a possible value combination for the variables of the application App. 
% valsTuple(+App,-ValsList)
valsTuple(App, ValsList):-
	appVars(App, VarsList),
	getVarVals(VarsList, ValsList).

% helper predicate
% getVarVals(+Vars,-Vals)
getVarVals([], []).

getVarVals([Var|RestVars], [Val|RestVals]):-
	var_value(Var, Val),
	getVarVals(RestVars, RestVals).

% Assign a *unique* numerical id to the selected starting state, i.e.,
% the selected combination of initial variable values. 
% WARNING: this predicate works if all possible values are BELOW 10. 
%valsToNum(+Vals, -NumID)
valsToNum(Vals, NumID):-
	valsToNum0(Vals, 1, 0, NumID).

% helper predicate
%valsToNum0(+Vals, +Counter, +CurrentID, +FinalID)
valsToNum0([], _, FinalID, FinalID).
	
valsToNum0([Val|RestVals], Counter, CurrID, Result):-
	ValID is Val*Counter,
	NewID is CurrID + ValID,
	NewCounter is Counter*10,
	valsToNum0(RestVals, NewCounter, NewID, Result). 

% retract the rules declaring the initial values of the selected variables.
% retractInitially(+Vars)
retractInitially([]).

retractInitially([Var|RestVars]):-
	retractall((initiatedAt(val(Var)=_, Ts, 0, Te) :- Ts=<0, 0<Te)),
	retractInitially(RestVars).

% assert the rules declaring the selected initial values of the corresponding variables.
% assertInitially(+Vars)
assertInitially([], []).

assertInitially([Var|RestVars], [Val|RestVals]):-
	assertz((initiatedAt(val(Var)=Val, Ts, 0, Te) :- Ts=<0, 0<Te)),
	assertInitially(RestVars, RestVals).

% declare the variables of the feedback loop (we assert them as entities wrapped in the predicate variable/1)
% assertVariables(+App)
assertVariables(App):-
	appVars(App, Vars),
	assertVariables0(Vars).

% helper predicate
% assertVariables0(+Vars)
assertVariables0([]).

assertVariables0([Var|RestVars]):-
	assertz((variable(Var))),
	assertVariables0(RestVars).

% a grounding of the head of this rule should be provided as a 'goal' to continuousQueries/2 
% in order to specify the name of the feedback loop and the initial values of its variables.
% initialiseLoop(+App, +Vals)
initialiseLoop(App, Vals):-
	appVars(App, Vars), % fetch the variables of the selected feedback loop from appVars/2. These declarations also specify the order of these variables.
	assertVariables(Vars), % assert these variables as entities wrapped in the predicate variable/1.
	retractInitially(Vars), % retract the initial values of variables, in case they were declared in the rules file.
	assertInitially(Vars, Vals). % assert the initial values of variables.
