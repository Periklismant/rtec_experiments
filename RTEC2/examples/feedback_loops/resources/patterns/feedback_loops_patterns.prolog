/**************************************************************************
     * Modelling Biological Feedback Loops using Kinetic Logic *

 * The values of system variables, such as 'x' and 'y', are described with 
 * the fluent val/2. val(x)=v denotes that the variable 'x' has the value 'v'.

 * Variable values are subject to change according to the structure and the 
 * dynamic of the feedback loop. 
 * 
 * In general: x'(t) = fx(x,y,t) - x(t),
 *     where x(t) is the value of x at timepoint t, 
 *           fx(x,y,t) is the functions which regulates changes in the value of 'x'
 *           and x'(t) denotes a future increase/decrease in the value of 'x'.     
 * 
 * if x'(t)>0 (resp. '<'), then x(t')=x(t)+1 (resp. '-'), where t'=t + dx{+} (resp. '{-}')
 * unless the change is cancelled.
 *
 * A change is cancelled if the value of function fx changes between t and t'.

 * These functions are represented using fluents.
 * holdsAt(f(x)=v,t) denotes that fx(x,y,t)=v at time-point t.
 
 ** Each feedback loop must have distinct variable names ** 
 **************************************************************************/

/****************************
 * Loop Dependent Fluents   *
 ****************************/

/*********************************
*   Function value calculation   *
**********************************/

%% Events are generated based on the current values of the variables of the system.

%% These rules are specific to the structure and the parameters (eg deadline values).
%% of each feedback loop

%%% Test Cases %%%

/****************************
 *   SIMPLE NEGATIVE LOOP   *
 ****************************/

/***********************************
 *   2-variable negative loop  *

      /---- '+' --->\             
     x               y
      \<--- '-' ----/

 ***********************************/

%% Variables: 'x' and 'y'
%% Values: 'x' <- '0' or '1'
%%         'y' <- '0' or '1'

%initially(val(x)=0).

%initially(val(y)=0).

%initiatedAt(F=V, Ts, 0, Te):-
%   Ts=<0, 0<Te, !, initially(F=V).

%initiatedAt(val(x)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(y)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%% Deadlines: dx+ = 2, dx- = 2
%%            dy+ = 2, dy- = 2 

/***********************************
 *  Table of variable states *
   
   | x | y | f(x) | f(y) |
   | 0 | 0 |  1   |  0   |
   | 0 | 1 |  0   |  0   |
   | 1 | 0 |  1   |  1   |
   | 1 | 1 |  0   |  1   |

 ***********************************/
%% function values are generated based on the current state.

%% f(x) = not(y)
initiatedAt(f(x)=Vfx, Ts, T, Te) :-
     %write('\tf(x)='), write(Vfx), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl, 
     boolean_not(Vfx, Vy),
     %happensAtProcessedSimpleFluent(y, start(val(y)=Vy), T),
     %write('\t\tquerying: val(y)='), write(Vy), nl,
     initiatedAtCyclic(y, val(y)=Vy, Ts, T, Te), Ts=<T, T<Te.
     %write('\t\tval(y)='), write(Vy), write(' initiates at T='), write(T), nl,
     %write('\tf(x)='), write(Vfx), write(' between '), write(Ts), write(' and '), write(Te),  write(' at '), write(T), nl.

%% f(y) = x 
initiatedAt(f(y)=Vx, Ts, T, Te) :-
     %write('\tf(y)='), write(Vx), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl, 
     %happensAtProcessedSimpleFluent(x, start(val(x)=Vx), T),
     %write('\t\tquerying: val(x)='), write(Vx), nl,
     initiatedAtCyclic(x, val(x)=Vx, Ts, T, Te), Ts=<T, T<Te.
     %write('\t\tval(x)='), write(Vx), write(' initiates at T='), write(T), nl,
     %write('\tf(y)='), write(Vx), write(' between '), write(Ts), write(' and '), write(Te), write(' at '), write(T), nl. 


/****************************
 *      IMMUNE_G LOOP       *
 ****************************/

persistAll([], _).

/*persistAll([FVP|RestFVPs], T):-
     indexOf(Index, FVP),
        %write('\t\t\t\tin persistAll for '), write(FVP), write(' at '), write(T), nl,
     (holdsAtCyclic(Index, FVP, T),
        %write('\t\t\t\t it holds!'), nl,
     \+ terminatedAtCyclic(Index, FVP, T)
     ;
      initiatedAtCyclic(Index, FVP, T)),
        %write('\t\t\t\t it is not broken!'), nl,
     persistAll(RestFVPs, T).
*/

persistAll([FVP|RestFVPs], T):-
     indexOf(Index, FVP),
        %write('\t\t\t\tin persistAll for '), write(FVP), write(' at '), write(T), nl,
     holdsAtCyclic(Index, FVP, T),
        %write('\t\t\t\t it holds!'), nl,
     \+ terminatedAtCyclic(Index, FVP, T), !, 
     persistAll(RestFVPs, T).

persistAll([FVP|RestFVPs], T):-
     indexOf(Index, FVP),
     initiatedAtCyclic(Index, FVP, T),
     persistAll(RestFVPs, T).

%initiatedAtCyclicAny0([], _, _, _, _):- !, fail. 

initiatedAtCyclicAny0([FVP|RestFVPs], PrevFVPs, Ts, T, Te):-
     indexOf(Index, FVP),
        %write('\t\t\tquerying initiatedAtCyclic for '), write(FVP), nl,
     %initiatedAtCached(FVP, Ts, T, Te), Ts=<T, T<Te,
     initiatedAtCyclic(Index, FVP, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\t\tinitiatedAtCyclic '), write(FVP), write(' at '), write(T), nl,
     %nextTimePoint(T, Tnext),
     append(RestFVPs, PrevFVPs, AllRestFVPs),
        %write('\t\t\tCheck whether the remaining FVPs: '), write(AllRestFVPs), write('persist'), nl,
     persistAll(AllRestFVPs, T),
        %write('\t\t\tThey persist!'), nl, 
      !.

initiatedAtCyclicAny0([FVP|RestFVPs], PrevFVPs, Ts, T, Te):-
     initiatedAtCyclicAny0(RestFVPs, [FVP|PrevFVPs], Ts, T, Te).

initiatedAtCyclicAny(FVPList, Ts, T, Te):-
     initiatedAtCyclicAny0(FVPList, [], Ts, T, Te).

antigen(_, 1).

%initially(val(h)=0).

%initially(val(s)=0).

%initiatedAt(val(h)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(s)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

% removed antigen param

%initiatedAt(f(h)=0, Ts, T, Te) :-
%     write('\tf(h)=0'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
%     var_value(h, Valh), Valh<2,
%     initiatedAtCyclic(h, val(h)=Valh, Ts, T, Te), Ts=<T, T>Te, antigen(T, 0).

initiatedAt(f(h)=0, Ts, T, Te) :-
        %write('\tf(h)=0'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(h, Valh), Valh<2,
        %write('\t\tinitiatedCyclicAny for '), write('val(s)=2'), write(' and '), write('val(h)='), write(Valh), nl, 
     initiatedAtCyclicAny([val(s)=2, val(h)=Valh], Ts, T, Te), Ts=<T, T<Te.
        %write('\t\tsucceeded initiatedCyclicAny for '), write(val(s)=2), write(' and '), write(val(h)=Valh), write(' at T='), write(T), nl.
     %initiatedAtCyclic(s, val(s)=2, Ts, T, Te), Ts=<T, T>Te,
     %nextTimePoint(T, Tnext),
     %holdsAtCyclic(h, val(h)=Valh, Tnext).

initiatedAt(f(h)=2, Ts, T, Te) :-
        %write('\tf(h)=2'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
        %write('\t\tinitiatedCyclic for '), write(val(h)=2), nl,
      initiatedAtCyclic(h, val(h)=2, Ts, T, Te), Ts=<T, T<Te.
      %initiatedAtCached(val(h)=2, Ts, T, Te), Ts=<T, T<Te.
        %write('\t\tsucceeded initiatedCyclic for '), write(val(h)=2), write(' at T='), write(T), nl. 


initiatedAt(f(h)=1, Ts, T, Te) :-
        %write('\tf(h)=1'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(s, Vs), Vs<2,
     var_value(h, Vh), Vh<2,
        %write('\t\tinitiatedCyclicAny for '), write('val(s)='), write(Vs), write(' and '), write('val(h)='), write(Vh), nl, 
     initiatedAtCyclicAny([val(s)=Vs, val(h)=Vh], Ts, T, Te), Ts=<T, T<Te.
        %write('\t\tsucceeded initiatedCyclicAny for '), write('val(s)='), write(Vs), write(' and '), write('val(h)='), write(Vh), write(' at T='), write(T), nl.

     %nextTimePoint(T, Tnext),
     %holdsAtCyclic(h, val(h)=Vh, T).

initiatedAt(f(s)=2, Ts, T, Te) :-
        %write('\tf(s)=2'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(s, Vs), Vs>=1,
        %write('\t\tinitiatedCyclic for '), write('val(s)=2'), nl,
    initiatedAtCyclic(s, val(s)=Vs, Ts, T, Te), Ts=<T, T<Te.
    %initiatedAtCached(val(s)=Vs, Ts, T, Te), Ts=<T, T<Te.
        %write('\t\tsucceeded initiatedCyclic for '), write('val(s)=2'), write(' at T='), write(T), nl. 


initiatedAt(f(s)=1, Ts, T, Te) :-
        %write('\tf(s)=1'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(h, Vh), Vh>=1,
        %write('\t\tinitiatedCyclicAny for '), write('val(s)=0 and '), write('val(h)='), write(Vh), nl, 
     initiatedAtCyclicAny([val(s)=0, val(h)=Vh], Ts, T, Te), Ts=<T, T<Te.
        %write('\t\tsucceeded initiatedCyclicAny for '),  write('val(s)=0 and '), write('val(h)='), write(Vh), write(' at T='), write(T), nl.


initiatedAt(f(s)=0, Ts, T, Te) :-
        %write('\tf(s)=0'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
        %write('\t\tinitiatedCyclicAny for '), write('val(s)=0 and '), write('val(h)=0'), nl, 
    initiatedAtCyclicAny([val(s)=0, val(h)=0], Ts, T, Te), Ts=<T, T<Te.
        %write('\t\tsucceeded initiatedCyclicAny for '),  write('val(s)=0 and '), write('val(h)=0'), write(' at T='), write(T), nl.

/****************************
 *       PHAGE_G LOOP       *
 ****************************/

%initiatedAt(val(cI)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(cro)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(cII)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(n)=0, Ts, 0, Te) :- Ts=<0, 0<Te.


initiatedAt(f(cI)=2, Ts, T, Te) :-
   initiatedAtCyclic(cro, val(cro)=0, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cI)=0, Ts, T, Te) :-
   var_value(cro, Vcro), Vcro>=1,
   initiatedAtCyclic(cro, val(cro)=Vcro, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cro)=3, Ts, T, Te) :-
   var_value(cI, VcI), VcI<2,
   var_value(cro, Vcro), Vcro<3,
   initiatedAtCyclicAny([val(cI)=VcI, val(cro)=Vcro], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cro)=0, Ts, T, Te) :-
   var_value(cI, VcI), VcI>=2,
   initiatedAtCyclic(cI, val(cI)=VcI, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cro)=2, Ts, T, Te) :-
   initiatedAtCyclic(cro, val(cro)=3, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cII)=0, Ts, T, Te) :-
   initiatedAtCyclic(n, val(n)=0, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cII)=1, Ts, T, Te) :-
   var_value(cI, VcI), VcI<2,
   var_value(cro, Vcro), Vcro<3,
   var_value(n, Vn), Vn>=1,
   initiatedAtCyclicAny([val(n)=Vn, val(cI)=VcI, val(cro)=Vcro], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cII)=0, Ts, T, Te) :-
   var_value(cI, VcI), VcI>=2,
   initiatedAtCyclic(cI, val(cI)=VcI, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(cII)=0, Ts, T, Te) :-
   initiatedAtCyclic(cro, val(cro)=3, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(n)=1, Ts, T, Te) :-
      %write('\tf(n)=1'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
   var_value(cI, VcI), VcI<1,
   var_value(cro, Vcro), Vcro<2,
      %write('\t\tinitiatedCyclicAny for '), write('val(cI)='), write(VcI), write(' and '), write('val(cro)='), write(Vcro), nl, 
   initiatedAtCyclicAny([val(cI)=VcI, val(cro)=Vcro], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(n)=0, Ts, T, Te) :-
      %write('\tf(n)=0'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
   var_value(cI, VcI), VcI>=1,
   initiatedAtCyclic(cI, val(cI)=VcI, Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(n)=0, Ts, T, Te) :-
      %write('\tf(n)=0'), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
   var_value(cro, Vcro), Vcro>=2,
   initiatedAtCyclic(cro, val(cro)=Vcro, Ts, T, Te), Ts=<T, T<Te.

/****************************
 * function value inertia   *
 ****************************/

% --- input events report changes in function values
% Note that holdsAt(f(X)=V, T) is true at the subsequent time-point
% after happensAt(f(X,V), T).

/****************************
 * Loop Independent Fluents *
 ****************************/

%% These rules model Kinetic Logic and are applied regardless of the structure
%% of the feedback loop under consideration.

/****************************
 *  variable value change   *
 ****************************/

initiatedAt(val(Var)=ValNew, Ts, T, Te) :-
        %write('\tval('), write(Var), write(')='), write(ValNew), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
        %write('\t\tquerying: order('), write(Var), write(', incr)=fulfilled'), nl,
     initiatedAtCyclic(Var, order(Var, incr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
     %initiatedAtCached(order(Var, incr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\torder=fulfilled matched at T='), write(T), nl,
     var_value(Var, VarVal),
        %write('\t\tquerying: val('), write(Var), write(')='), write(VarVal), write(' at '), write(T), nl,
     holdsAtCyclic(Var, val(Var)=VarVal, T),
        %write('\t\tval('), write(Var), write(')='), write(VarVal), write(' at '), write(T), nl,
     var_value(Var, FVarVal),
        %write('\t\tquerying: f('), write(Var), write(')='), write(FVarVal), write(' at '), write(T), nl,
     holdsAtCyclic(Var, f(Var)=FVarVal, T),
        %write('\t\tf('), write(Var), write(')='), write(FVarVal), write(' at '), write(T), nl,
     Rate is FVarVal - VarVal, 
     Rate>0,
        %write('\tval('), write(Var), write(')='), write(ValNew), write(' at T='), write(T), nl, 
     ValNew is VarVal + 1. 
     %write('\t\tf matched!'), nl,
     %write('\tval('), write(Var), write(')=1 between '), write(Ts), write(' and '), write(Te), write(' at '), write(T), nl. 


initiatedAt(val(Var)=ValNew, Ts, T, Te):-
   Val is ValNew - 1,
   var_value(Var, Val),
   initiatedAtPrev(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
   holdsAtCyclic(Var, lastChange(Var)=incr, T), 
   %holdsAtCyclic(Var, order(Var, incr)=fulfilled, T), 
   %\+ holdsAtCyclic(Var, order(Var, decr)=fulfilled, T),
   var_value(Var, FVarVal),
   holdsAtCyclic(Var, f(Var)=FVarVal, T),
   Rate is FVarVal - Val, 
   Rate>0, 
   ValNew is Val + 1, 
   var_value(Var, ValNew),
   prevTimePoint(T, Tprev),
   var_value(Var, FVarVal2),
   %initiatedAtCyclic(Var, f(Var)=FVarVal2, Tprev), FVarVal2=FVarVal.
   holdsAtCyclic(Var, f(Var)=FVarVal2, Tprev), FVarVal2=FVarVal.


initiatedAt(val(Var)=ValNew, Ts, T, Te) :-
        %write('\tval('), write(Var), write(')='), write(ValNew), write(' between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
        %write('\t\tquerying: order('), write(Var), write(', decr)=fulfilled'), nl,
    initiatedAtCyclic(Var, order(Var, decr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
    %initiatedAtCached(order(Var, decr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\torder=fulfilled matched at T='), write(T), nl,
     var_value(Var, VarVal),
        %write('\t\tquerying: val('), write(Var), write(')='), write(VarVal), write(' at '), write(T), nl,
     holdsAtCyclic(Var,val(Var)=VarVal,T),
        %write('\t\tval('), write(Var), write(')='), write(VarVal), write(' at '), write(T), nl,
     var_value(Var, FVarVal),
        %write('\t\tquerying: f('), write(Var), write(')='), write(FVarVal), write(' at '), write(T), nl,
     holdsAtCyclic(Var,f(Var)=FVarVal,T),
        %write('\t\tf('), write(Var), write(')='), write(FVarVal), write(' at '), write(T), nl,
     Rate is FVarVal - VarVal, 
     Rate<0,
        %write('\tval('), write(Var), write(')='), write(ValNew), write(' at T='), write(T), nl, 
     ValNew is VarVal - 1. 
     %write('\t\tf matched!'), nl,
     %write('\tval('), write(Var), write(')=0 between '), write(Ts), write(' and '), write(Te), write(' at '), write(T), nl.

initiatedAt(val(Var)=ValNew, Ts, T, Te):-
   Val is ValNew + 1,
   var_value(Var, Val),
   initiatedAtPrev(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
   holdsAtCyclic(Var, lastChange(Var)=decr, T), 
   %holdsAtCyclic(Var, order(Var, decr)=fulfilled, T), 
   %\+ holdsAtCyclic(Var, order(Var, incr)=fulfilled, T),
   var_value(Var, FVarVal),
   holdsAtCyclic(Var, f(Var)=FVarVal, T),
   Rate is FVarVal - Val, 
   Rate<0, 
   ValNew is Val - 1, 
   var_value(Var, ValNew),
   prevTimePoint(T, Tprev),
   var_value(Var, FVarVal2),
   %initiatedAtCyclic(Var, f(Var)=FVarVal2, Tprev), FVarVal2=FVarVal.
   holdsAtCyclic(Var, f(Var)=FVarVal2, Tprev), FVarVal2=FVarVal.

/*
initiatedAt(val(Var)=ValNew, Ts, Tnext, Te):-
   initiatedAtCyclic(Var, order(Var, decr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
   nextTimePoint(T, Tnext), 
   var_value(Var, VarVal),
     %write('\t\tquerying: val('), write(Var), write(')='), write(VarVal), write(' at '), write(T), nl,
   holdsAtCyclic(Var, val(Var)=VarVal, Tnext),
     %write('\t\tval('), write(Var), write(')='), write(VarVal), write(' at '), write(T), nl,
   var_value(Var, FVarVal),
     %write('\t\tquerying: f('), write(Var), write(')='), write(FVarVal), write(' at '), write(T), nl,
   holdsAtCyclic(Var, f(Var)=FVarVal, Tnext),
     %write('\t\tf('), write(Var), write(')='), write(FVarVal), write(' at '), write(T), nl,
   Rate is FVarVal - VarVal, 
   Rate<0,
     %write('\tval('), write(Var), write(')='), write(ValNew), write(' at T='), write(T), nl, 
   ValNew is VarVal - 1. 
*/

/************************************************
 *  Order to change the value of a variable     *
 ***********************************************/

% If the value of the function is greater than the value 
% of the corresponding variable, then an order to increase
% the value of the variable by 1 is staged at time-point T.

% This order is fulfilled, i.e. the value of x increases by 1,
% at time-point T + dx{+}, unless it is cancelled at some time-point
% in [T, T + dx{+} - 1].

initiatedAt(order(Var,incr)=pending, Ts, T, Te) :-
     var_value(Var, FVal),
     var_value(Var, Val),
     initiatedAtCyclic(Var, f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
     initiatedAtCyclic(Var, val(Var)=Val, T),
     Rate is FVal - Val, 
     Rate>0.

initiatedAt(order(Var,incr)=pending, Ts, T, Te) :-
     var_value(Var, FVal),
     var_value(Var, Val), 
     initiatedAtCyclicAny([val(Var)=Var, f(Var)=FVal], Ts, T, Te), Ts=<T, T<Te,
     %initiatedAtCyclic(Var, val(Var)=Val, T),
     Rate is FVal - Val, 
     Rate>0.

/*
initiatedAt(order(Var,incr)=pending, Ts, T, Te) :-
     var_value(Var, FVal),
     var_value(Var, Val),
     initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
     initiatedAtCyclic(Var, f(Var)=FVal, T),
     Rate is FVal - Val, 
     Rate>0.
*/
initiatedAt(order(Var, incr)=pending, Ts, T, Te) :-
        %write('\torder('), write(Var), write(', incr)=pending between '), write(Ts), write(','), write(Te), write(' ? '), nl,
     var_value(Var, FVal), 
        %write('\t\tquerying: f('), write(Var), write(')='), write(FVal), nl,
     initiatedAtCyclic(Var, f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
      %initiatedAtCached(f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\tinitiatedAtCyclic(f('), write(Var), write(')='), write(FVal), write(' at T='), write(T), nl,     
     var_value(Var, Val),
        %write('\t\tquerying: val('), write(Var), write(')='), write(Val), nl,
     holdsAtCyclic(Var,val(Var)=Val,T),
        %write('\t\tval('), write(Var), write(')='), write(Val), write(' at T='), write(T), nl,
     Rate is FVal - Val, 
     Rate>0.

initiatedAt(order(Var, incr)=pending, Ts, T, Te) :-
        %write('\torder('), write(Var), write(', incr)=pending between '), write(Ts), write(','), write(Te), write(' ? '), nl,
     var_value(Var, Val), 
        %write('\t\tquerying: f('), write(Var), write(')='), write(FVal), nl,
     initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
      %initiatedAtCached(f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\tinitiatedAtCyclic(f('), write(Var), write(')='), write(FVal), write(' at T='), write(T), nl,     
     var_value(Var, FVal),
        %write('\t\tquerying: val('), write(Var), write(')='), write(Val), nl,
     holdsAtCyclic(Var, f(Var)=FVal,T),
        %write('\t\tval('), write(Var), write(')='), write(Val), write(' at T='), write(T), nl,
     Rate is FVal - Val, 
     Rate>0.
        %write('\torder('), write(Var), write(', incr)=pending  at T='), write(T), nl. 
          %write('\t\tval('), write(Var), write(')='), write(Val), write(' at T='), write(T), nl.
          %write('\torder('), write(Var), write(', incr)=pending between '), write(Ts), write(','), write(Te), write(' at '), write(T), nl.


/*
initiatedAt(order(Var, incr)=pending, Ts, T, Te) :-
          write('\torder('), write(Var), write(', incr)=pending between '), write(Ts), write(','), write(Te), write(' ? '), nl,
     var_value(Var, Val),
     initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, FVal),
     holdsAtCyclic(Var,f(FVal)=1,T),
     Rate is FVal - Val, 
     Rate>0. 
*/

initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
     var_value(Var, FVal),
     var_value(Var, Val),
     initiatedAtCyclic(Var, f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
     initiatedAtCyclic(Var, val(Var)=Val, T),
     Rate is FVal - Val, 
     Rate<0.


initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
     var_value(Var, FVal),
     var_value(Var, Val),
     Val>FVal, 
     initiatedAtCyclicAny([val(Var)=Val, f(Var)=FVal], Ts, T, Te), Ts=<T, T<Te,
     %initiatedAtCyclicAny(Var, f(Var)=FVal, T).
     Rate is FVal - Val, 
     Rate<0.

initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
        %write('\torder('), write(Var), write(', decr)=pending between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(Var, FVal),
        %write('\t\tquerying: f('), write(Var), write(')='), write(FVal), nl,
     initiatedAtCyclic(Var, f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
     %initiatedAtCached(f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\tinitiatedCyclic(f('), write(Var), write(')='), write(FVal), write(' at T='), write(T), nl,
     var_value(Var, Val),
        %write('\t\tquerying: val('), write(Var), write(')='), write(Val), nl,
     holdsAtCyclic(Var,val(Var)=Val,T),
     \+ terminatedAtCyclic(Var, val(Var)=Val, T),
        %write('\t\tval('), write(Var), write(')='), write(Val), write(' at T='), write(T), nl,
     Rate is FVal - Val, 
     Rate<0.
        %write('\torder('), write(Var), write(', decr)=pending  at T='), write(T), nl. 
          %write('\t\tval('), write(Var), write(')='), write('1'), write(' at T='), write(T), nl,
          %write('\torder('), write(Var), write(', decr)=pending between '), write(Ts), write(' and '), write(Te), write(' at '), write(T),  nl.
initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
        %write('\torder('), write(Var), write(', decr)=pending between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(Var, Val),
        %write('\t\tquerying: f('), write(Var), write(')='), write(FVal), nl,
     initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
     %initiatedAtCached(f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\tinitiatedCyclic(f('), write(Var), write(')='), write(FVal), write(' at T='), write(T), nl,
     var_value(Var, FVal),
        %write('\t\tquerying: val('), write(Var), write(')='), write(Val), nl,
     holdsAtCyclic(Var,f(Var)=FVal,T),
     \+ terminatedAtCyclic(Var, f(Var)=FVal, T),
        %write('\t\tval('), write(Var), write(')='), write(Val), write(' at T='), write(T), nl,
     Rate is FVal - Val, 
     Rate<0.

/*
initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
          write('\torder('), write(Var), write(', decr)=pending between '), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(Var, Val),
     initiatedAtCyclic(Var, val(Var)=1, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, FVal),
     holdsAtCyclic(Var,f(Var)=0,T),
     Rate is FVal - Val, 
     Rate<0. 
     */

initiatedAt(order(Var, Sign)=cancelled, Ts, T, Te) :-
        %write('\torder('), write(Var), write(','), write(Sign), write(')=cancelled between'), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(Var, Vf),
        %write('\t\tquerying: f('), write(Var), write(')='), write(Vf), nl,
     initiatedAtCyclic(Var, f(Var)=Vf,Ts,T,Te), Ts=<T, T<Te,
     %initiatedAtCached(f(Var)=Vf, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\tinitiatedAtCyclic(f('), write(Var), write(')='), write(Vf), write(') at T='), write(T), nl,
     holdsAtCyclic(Var, order(Var,Sign)=pending, T),
     \+ initiatedAtCyclic(Var, order(Var,Sign)=pending, T), 
     var_value(Var,Vfcurr),
        %write('\t\tquerying: f('), write(Var), write(')='), write(Vfcurr), nl,
     holdsAtCyclic(Var, f(Var)=Vfcurr,T),
        %write('\t\tf('), write(Var), write(')='), write(Vfcurr), write(' at T='), write(T), nl,
     Vf\=Vfcurr.
        %write('\torder('), write(Var), write(','), write(Sign), write(')=cancelled at T='), write(T), nl.
     %write('\t\tval('), write(Var), write(')='), write(Vfcurr), write(' at T='), write(T), nl,
     %write('\torder('), write(Var), write(','), write(Sign), write(')=cancelled between'), write(Ts), write(' and '), write(Te), write(' at '), write(T), nl.

initiatedAt(order(Var, Sign)=cancelled, Ts, T, Te) :-
        %write('\torder('), write(Var), write(','), write(Sign), write(')=cancelled between'), write(Ts), write(' and '), write(Te), write(' ? '), nl,
     var_value(Var, Vf),
        %write('\t\tquerying: f('), write(Var), write(')='), write(Vf), nl,
     initiatedAtCyclic(Var, f(Var)=Vf,Ts,T,Te), Ts=<T, T<Te,
     %initiatedAtCached(f(Var)=Vf, Ts, T, Te), Ts=<T, T<Te,
        %write('\t\tinitiatedAtCyclic(f('), write(Var), write(')='), write(Vf), write(') at T='), write(T), nl,
     holdsAtCyclic(Var, order(Var,Sign)=pending, T),
     \+ initiatedAtCyclic(Var, order(Var,Sign)=pending, T), 
     var_value(Var,Vfcurr),
        %write('\t\tquerying: f('), write(Var), write(')='), write(Vfcurr), nl,
     holdsAtCyclic(Var, f(Var)=Vfcurr,T),
        %write('\t\tf('), write(Var), write(')='), write(Vfcurr), write(' at T='), write(T), nl,
     Vf\=Vfcurr.

/*
terminatedAt(order(Var, incr)=fulfilled, Ts, T, T):-
   initiatedAtCyclic(Var, order(Var, decr)=fulfilled, Ts, T, Te), Ts=<T, T<Te.


terminatedAt(order(Var, decr)=fulfilled, Ts, T, T):-
   initiatedAtCyclic(Var, order(Var, incr)=fulfilled, Ts, T, Te), Ts=<T, T<Te.
*/
/*
initiatedAt(order(Var, Sign)=stopChange, Ts, T, Te) :-
    var_value(Var, Vf),
        %write('\t\tquerying: f('), write(Var), write(')='), write(Vf), nl,
   initiatedAtCyclic(Var, f(Var)=Vf,Ts,T,Te), Ts=<T, T<Te,
     
    var_value(Var, V), 
   holdsAtCyclic(Var, val(Var)=V, T),
        %write('\t\tf('), write(Var), write(')='), write(Vfcurr), write(' at T='), write(T), nl,
   Rate is Vf - V, Rate=0.

initiatedAt(order(Var, Sign)=stopChange, Ts, T, Te) :-
    var_value(Var, V),
        %write('\t\tquerying: f('), write(Var), write(')='), write(Vf), nl,
   initiatedAtCyclic(Var, val(Var)=V,Ts,T,Te), Ts=<T, T<Te,
     
    var_value(Var, Vf), 
   holdsAtCyclic(Var, f(Var)=Vf, T),
        %write('\t\tf('), write(Var), write(')='), write(Vfcurr), write(' at T='), write(T), nl,
   Rate is Vf - V, Rate=0.
   */

initiatedAt(lastChange(Var)=incr, Ts, T, Te):-
   var_value(Var, Val),
   initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
   OldVal is Val - 1,
   var_value(Var, OldVal),
   holdsAtCyclic(Var, val(Var)=OldVal, T).

initiatedAt(lastChange(Var)=decr, Ts, T, Te):-
   var_value(Var, Val),
   initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
   OldVal is Val + 1,
   var_value(Var, OldVal),
   holdsAtCyclic(Var, val(Var)=OldVal, T).

cachingOrder2(Var, val(Var)=Val) :-
     variable(Var), var_value(Var,Val).
cachingOrder2(Var, f(Var)=Val):- 
     variable(Var), var_value(Var,Val).
%cachingOrder2(Var, order(Var,Sign)=pending):-
%     variable(Var), sign(Sign).
%cachingOrder2(Var, order(Var,Sign)=cancelled):- 
%     variable(Var), sign(Sign).
%cachingOrder2(Var, order(Var,Sign)=fulfilled):- 
%     variable(Var), sign(Sign).
%cachingOrder2(Var, lastChange(Var)=incr):-  
%      variable(Var).
%cachingOrder2(Var, lastChange(Var)=decr):-  
%      variable(Var).


%cachingOrder2(x, val(x)=1).
%cachingOrder2(y, f(y)=1).
%cachingOrder2(y, val(y)=1).
%cachingOrder2(x, f(x)=0).
%cachingOrder2(x, val(x)=0).
%cachingOrder2(y, f(y)=0).
%cachingOrder2(y, val(y)=0).
%cachingOrder2(x, f(x)=1).
%cachingOrder2(Var, f(Var)=Val):- 
%     variable(Var), var_value(Var,Val).


maxDuration(order(Var,Sign)=pending,order(Var,Sign)=fulfilled, D) :- 
     deadline(Var,Sign,D).
     %write('\t\tmaxDuration for: '), write(Var), write(' '), write(Sign), write(' '), write(D), nl.

%maxDuration(order(Var,Sign)=fulfilled,order(Var,Sign)=fulfilled, 1).


/*
computeCycleIncremental(Tstart, Tend):-
	Tstart>Tend, !, 
          write('making intervals...'), nl, 
     makeIntervalsCycle,
          write('made intervals.'), nl.

computeCycleIncremental(Tstart, Tend):-
	T is Tstart + 1,
     Tmod is T mod 100,
     (Tmod=0 -> (getCPUtime(Time, always), write('computing starting and ending points for T = '), write(T), nl, write('Time: '), write(Time), nl); true),
	findall(OE, (cachingOrder2(Index,OE), 
				%write('computing starting point for: '), write(OE), write(' at '), write(Tstart), nl, 
				initiatedAtCyclic(Index,OE,Tstart, _, T),
		          %write('computing ending point for: '), write(OE), write(' at '), write(Tstart), nl, 
		        terminatedAtCyclic(Index,OE,Tstart, _, T)
		        ), _),
	computeCycleIncremental(T, Tend).


makeIntervalsCycle:-
	%initTime(InitTime),
	findall(F=V,  
		(cachingOrder2(Index,F=V), 
			%isThereASimpleFPList(Index, F=V, ExtendedPList), % we kept simpleFPList just for ExtendedPList
			%write('ExtendedPList = '), write(ExtendedPList), nl,
			%setTheSceneSimpleFluent(ExtendedPList, F=V, InitTime, StPoint), % then, we use ExtendedPList to 
			%write('StPoint = '), write(StPoint), nl,
			%write('creating intervals for: '), write(F=V), nl,
			storedCyclicPoints(Index, F=V, StoredPoints),
			%write('StoredPoints0 = '), write(StoredPoints0), nl,
		    %addFirstPoint(StPoint, StoredPoints0, StoredPoints),
		     %write('Stored Points: '), nl,
		     %write('\tstoredCyclicPoints: '), write(StoredPoints), nl,
			intervalsFromStoredPoints(StoredPoints, -1, Intervals)
			%write('\tresp. Intervals: '), write(Intervals), nl
			%write('\tRestrictedPeriods: '), write(RestrictedPeriods), nl,
			%write('\tExtension: '), write(Extension), nl
		), _).

preprocessCycles:-
	initTime(InitTime),
	InitTimePlusOne is InitTime + 1,
	findall(F=V,  
		(cachingOrder2(Index,F=V), 
			isThereASimpleFPList(Index, F=V, ExtendedPList), % we kept simpleFPList just for ExtendedPList
			%write('ExtendedPList = '), write(ExtendedPList), nl,
			setTheSceneSimpleFluent(ExtendedPList, F=V, InitTime, StPoint), % then, we use ExtendedPList to 
			%write('StPoint = '), write(StPoint), nl,
			addFirstCyclicPoint(Index, F=V, InitTimePlusOne, StPoint)
		), _).

addFirstCyclicPoint(Index, F=V, InitTimePlusOne, []) :- 
	addCyclicPoint(Index, F=V, InitTimePlusOne, f).

addFirstCyclicPoint(Index, F=V, InitTimePlusOne, [_]):-
	addCyclicPoint(Index, F=V, InitTimePlusOne, t).
*/
