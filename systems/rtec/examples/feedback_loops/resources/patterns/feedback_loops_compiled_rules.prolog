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

/***********************************
 *  Table of variable states *
   
   | x | y | f(x) | f(y) |
   | 0 | 0 |  1   |  0   |
   | 0 | 1 |  0   |  0   |
   | 1 | 0 |  1   |  1   |
   | 1 | 1 |  0   |  1   |

 ***********************************/
%% function values are generated based on the current state.
%
%initially(val(x)=0).
%initially(val(y)=0).
%initiatedAt(val(x)=0,-1,-1,0).
%initiatedAt(val(y)=0,-1,-1,0).

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

% persistAll(+FVPList, +T)
% Matches if for every FVP U in FVPList, we have:
%  U holds at T and it is not terminated at T or
%  U is initiated at T.
persistAll([], _).
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

% initiatedAtCyclicAny0(+FVPList, PrevFVPs, +Ts, -T, +Te)
% Matches if there is a time-point T between Ts and Te, for which there is some FVP in FVPList, such that FVP is initiated at T while the remaining FVPs persist at T.
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

%initiatedAt(antigen=1, _, T, _):-
    %TDivTen is T//10,
    %Mod is TDivTen mod 2,
    %Mod=1.

%initiatedAt(antigen=0, _, T, _):-
    %TDivTen is T//10,
    %Mod is TDivTen mod 2,
    %Mod=0.

%antigen(1, T):-
    %TDivTen is T//10,
    %write(TDivTen),nl,
    %Mod is TDivTen mod 2,
    %Mod=1.


%initially(val(h)=2).
%initially(val(s)=0).

%initiatedAt(val(h)=2,-1,-1,0).
%initiatedAt(val(s)=0,-1,-1,0).

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

initiatedAt(f(h)=0, Ts, T, Te) :-
     var_value(s, Vals), Vals>0,
     initiatedAtCyclicAny([val(h)=0, val(s)=Vals], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(h)=0, Ts, T, Te) :-
     initiatedAtCyclicAny([val(h)=1, val(s)=2], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(h)=1, Ts, T, Te) :-
     initiatedAtCyclicAny([val(h)=0, val(s)=0], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(h)=1, Ts, T, Te) :-
     var_value(s, Vals), Vals<2,
     initiatedAtCyclicAny([val(h)=1, val(s)=Vals], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(h)=2, Ts, T, Te) :-
      initiatedAtCyclic(h, val(h)=2, Ts, T, Te), Ts=<T, T<Te.


initiatedAt(f(s)=0, Ts, T, Te) :-
    var_value(s, Vals), Vals<2,
    initiatedAtCyclicAny([val(h)=0, val(s)=Vals], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(s)=1, Ts, T, Te) :-
    initiatedAtCyclicAny([val(h)=0, val(s)=2], Ts, T, Te), Ts=<T, T<Te.
        
initiatedAt(f(s)=1, Ts, T, Te) :-
    var_value(h, Vh), Vh>0,
    initiatedAtCyclicAny([val(h)=Vh, val(s)=0], Ts, T, Te), Ts=<T, T<Te.

initiatedAt(f(s)=2, Ts, T, Te) :-
    var_value(h, Vh), Vh>0,
    var_value(s, Vs), Vs>0,
    initiatedAtCyclicAny([val(h)=Vh, val(s)=Vs], Ts, T, Te), Ts=<T, T<Te.

/****************************
 *       PHAGE_G LOOP       *
 ****************************/

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

%initiatedAt(val(cI)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(cro)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(cII)=0, Ts, 0, Te) :- Ts=<0, 0<Te.

%initiatedAt(val(n)=0, Ts, 0, Te) :- Ts=<0, 0<Te.
%
%initially(val(cI)=2).
%initially(val(cro)=0).
%initially(val(cII)=1).
%initially(val(n)=0).
%
%initiatedAt(val(cI)=2,-1,-1,0).
%initiatedAt(val(cro)=0,-1,-1,0).
%initiatedAt(val(cII)=1,-1,-1,0).
%initiatedAt(val(n)=0,-1,-1,0).

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
   var_value(cI, VcI), VcI<2,
   initiatedAtCyclicAny([val(cro)=3, val(cI)=VcI], Ts, T, Te), Ts=<T, T<Te.

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
   var_value(cI, VcI), VcI<1,
   var_value(cro, Vcro), Vcro<2,
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
     initiatedAtCyclic(Var, order(Var, incr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, VarVal),
     holdsAtCyclic(Var, val(Var)=VarVal, T),
     var_value(Var, FVarVal),
     holdsAtCyclic(Var, f(Var)=FVarVal, T),
     Rate is FVarVal - VarVal, 
     Rate>0,
     ValNew is VarVal + 1.


initiatedAt(val(Var)=ValNew, Ts, T, Te):-
   Val is ValNew - 1,
   var_value(Var, Val),
   initiatedAtPrev(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
   holdsAtCyclic(Var, lastChange(Var)=incr, T), 
   var_value(Var, FVarVal),
   holdsAtCyclic(Var, f(Var)=FVarVal, T),
   Rate is FVarVal - Val, 
   Rate>0, 
   ValNew is Val + 1, 
   var_value(Var, ValNew),
   prevTimePoint(T, Tprev),
   var_value(Var, FVarVal2),
   holdsAtCyclic(Var, f(Var)=FVarVal2, Tprev), FVarVal2=FVarVal.


initiatedAt(val(Var)=ValNew, Ts, T, Te) :-
    initiatedAtCyclic(Var, order(Var, decr)=fulfilled, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, VarVal),
     holdsAtCyclic(Var,val(Var)=VarVal,T),
     var_value(Var, FVarVal),
     holdsAtCyclic(Var,f(Var)=FVarVal,T),
     Rate is FVarVal - VarVal, 
     Rate<0,
     ValNew is VarVal - 1. 

initiatedAt(val(Var)=ValNew, Ts, T, Te):-
   Val is ValNew + 1,
   var_value(Var, Val),
   initiatedAtPrev(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
   holdsAtCyclic(Var, lastChange(Var)=decr, T),
   var_value(Var, FVarVal),
   holdsAtCyclic(Var, f(Var)=FVarVal, T),
   Rate is FVarVal - Val, 
   Rate<0, 
   ValNew is Val - 1, 
   var_value(Var, ValNew),
   prevTimePoint(T, Tprev),
   var_value(Var, FVarVal2),
   holdsAtCyclic(Var, f(Var)=FVarVal2, Tprev), FVarVal2=FVarVal.

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
     Rate is FVal - Val, 
     Rate>0.

initiatedAt(order(Var, incr)=pending, Ts, T, Te) :-
     var_value(Var, FVal), 
     initiatedAtCyclic(Var, f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, Val),
     holdsAtCyclic(Var,val(Var)=Val,T),
     Rate is FVal - Val, 
     Rate>0.

initiatedAt(order(Var, incr)=pending, Ts, T, Te) :-
     var_value(Var, Val), 
     initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, FVal),
     holdsAtCyclic(Var, f(Var)=FVal,T),
     Rate is FVal - Val, 
     Rate>0.

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
     Rate is FVal - Val, 
     Rate<0.

initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
     var_value(Var, FVal),
     initiatedAtCyclic(Var, f(Var)=FVal, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, Val),
     holdsAtCyclic(Var,val(Var)=Val,T),
     \+ terminatedAtCyclic(Var, val(Var)=Val, T),
     Rate is FVal - Val, 
     Rate<0.

initiatedAt(order(Var,decr)=pending, Ts, T, Te) :-
     var_value(Var, Val),
     initiatedAtCyclic(Var, val(Var)=Val, Ts, T, Te), Ts=<T, T<Te,
     var_value(Var, FVal),
     holdsAtCyclic(Var,f(Var)=FVal,T),
     \+ terminatedAtCyclic(Var, f(Var)=FVal, T),
     Rate is FVal - Val, 
     Rate<0.

initiatedAt(order(Var, Sign)=cancelled, Ts, T, Te) :-
     var_value(Var, Vf),
     initiatedAtCyclic(Var, f(Var)=Vf,Ts,T,Te), Ts=<T, T<Te,
     holdsAtCyclic(Var, order(Var,Sign)=pending, T),
     \+ initiatedAtCyclic(Var, order(Var,Sign)=pending, T), 
     var_value(Var,Vfcurr),
     holdsAtCyclic(Var, f(Var)=Vfcurr,T),
     Vf\=Vfcurr.

initiatedAt(order(Var, Sign)=cancelled, Ts, T, Te) :-
     var_value(Var, Vf),
     initiatedAtCyclic(Var, f(Var)=Vf,Ts,T,Te), Ts=<T, T<Te,
     holdsAtCyclic(Var, order(Var,Sign)=pending, T),
     \+ initiatedAtCyclic(Var, order(Var,Sign)=pending, T), 
     var_value(Var,Vfcurr),
     holdsAtCyclic(Var, f(Var)=Vfcurr,T),
     Vf\=Vfcurr.

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
 cachingOrder2(Var, order(Var,Sign)=pending):-
     variable(Var), sign(Sign).
 cachingOrder2(Var, order(Var,Sign)=cancelled):- 
    variable(Var), sign(Sign).
 cachingOrder2(Var, order(Var,Sign)=fulfilled):- 
  variable(Var), sign(Sign).
 cachingOrder2(Var, lastChange(Var)=incr):-  
       variable(Var).
  cachingOrder2(Var, lastChange(Var)=decr):-  
      variable(Var).

simpleFluent(val(_)=0).				
outputEntity(val(_)=0).		
index(val(Var)=0, Var). 

simpleFluent(val(_)=1).				
outputEntity(val(_)=1).		
index(val(Var)=1, Var). 

simpleFluent(val(_)=2).				
outputEntity(val(_)=2).		
index(val(Var)=2, Var). 

simpleFluent(val(_)=3).				
outputEntity(val(_)=3).		
index(val(Var)=3, Var). 

simpleFluent(f(_)=0).				
outputEntity(f(_)=0).		
index(f(Var)=0, Var).

simpleFluent(f(_)=1).				
outputEntity(f(_)=1).		
index(f(Var)=1, Var).

simpleFluent(f(_)=2).				
outputEntity(f(_)=2).		
index(f(Var)=2, Var).

simpleFluent(f(_)=3).				
outputEntity(f(_)=3).		
index(f(Var)=3, Var).

simpleFluent(order(_,_)=pending).				
outputEntity(order(_,_)=pending).		
index(order(Var,_)=pending, Var). 

simpleFluent(order(_,_)=cancelled).				
outputEntity(order(_,_)=cancelled).		
index(order(Var,_)=cancelled, Var). 

simpleFluent(order(_,_)=fulfilled).				
outputEntity(order(_,_)=fulfilled).		
index(order(Var,_)=fulfilled, Var). 

simpleFluent(lastChange(_)=incr).				
outputEntity(lastChange(_)=incr).		
index(lastChange(Var)=incr, Var). 

simpleFluent(lastChange(_)=decr).				
outputEntity(lastChange(_)=decr).		
index(lastChange(Var)=decr, Var). 

cyclic(val(_)=0).
cyclic(val(_)=1).
cyclic(val(_)=2).
cyclic(val(_)=3).
cyclic(f(_)=0).
cyclic(f(_)=1).
cyclic(f(_)=2).
cyclic(f(_)=3).
cyclic(order(_,_)=pending).
cyclic(order(_,_)=cancelled).
cyclic(order(_,_)=fulfilled).
cyclic(lastChange(_)=incr).
cyclic(lastChange(_)=decr).

grounding(val(Var)=Val):- variable(Var), var_value(Var,Val).
grounding(f(Var)=Val):- variable(Var), var_value(Var,Val).
grounding(order(Var,Sign)=pending):- variable(Var), sign(Sign).
grounding(order(Var,Sign)=cancelled):- variable(Var), sign(Sign).
grounding(order(Var,Sign)=fulfilled):- variable(Var), sign(Sign).
grounding(lastChange(Var)=incr):- variable(Var).
grounding(lastChange(Var)=decr):- variable(Var).


fi(order(Var,Sign)=pending,order(Var,Sign)=fulfilled, D) :- 
     deadline(Var,Sign,D).

