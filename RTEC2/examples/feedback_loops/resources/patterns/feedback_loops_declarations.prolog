/******************************************* DECLARATIONS ***************************
 1. Declare the entities of the event description: 
	-events (event/1), 
	-simple fluents (simpleFluent/1), and
	-statically determined fluents (sDFluent/1).
 2. For each entity, state if it is input (inputEntity/1) or output (outputEntity/1). 
	-Simple fluents are, by definition, output entities and must be declared so.
 3. For each entity, state its index (index/2). 
	-A fluent F must have the same index in all fluent-value pairs F=V.
 Note: All values V of a simple fluent F must be explicitly declared by means of:
	-simpleFluent/1
	-outputEntity/1
	-index/2.
 4. For input entities expressed as statically determined fluents, state whether:
	-The fluent instances will be reported as time-points (points/1) or intervals;
	 by default, RTEC assumes that fluent instances are reported as intervals
	 (in this case no declarations are necessary).
	-The list of intervals of the input entity will be constructed by 
	 collecting individual intervals (collectIntervals/1), or built from 
	 time-points (buildFromPoints/1). If no declarations are provided here,
	 then the input entity may not participate in the specification of 
	 output entities. 	 
 5. Specify the grounding of each fluent and output entity expressed as event.
 6. Declare the order of caching of output entities.
 *************************************************************************************/

%%% specific for boolean values (Naive Kinetic Logic).

%event(tick).			
%inputEntity(tick).		
%index(tick, tick). 

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

% For input entities expressed as statically determined fluents, state whether 
% the fluent instances will be reported as time-points (points/1) or intervals.
% By default, RTEC assumes that fluent instances are reported as intervals
% (in this case no declarations are necessary).
% This part of the declarations is used by the data loader.

% No points/1 declarations are necessary in this application.


% For input entities expressed as statically determined fluents, state whether 
% the list of intervals of the input entity will be constructed by 
% collecting individual intervals (collectIntervals/1), or built from 
% time-points (buildFromPoints/1). If no declarations are provided for some,
% input entity, then the input entity may not participate in the specification of 
% output entities. 

% No collectIntervals/1 or buildFromPoints/1 declarations are necessary in this application.


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

/*
cyclic(c1, val(_)=0).
cyclic(c1, val(_)=1).
cyclic(c1, f(_)=0).
cyclic(c1, f(_)=1).
cyclic(c1, order(_,_)=pending).
cyclic(c1, order(_,_)=cancelled).
cyclic(c1, order(_,_)=fulfilled).

cycle(Index, [CHead|CTail]):-
	deriveCycle(Index, [], [CHead|CTail]).

deriveCycle(_Index, C, C).

deriveCycle(Index, CSoFar, [FVP|CTail]):-
	cyclic(Index, FVP),
	\+ member(FVP, CSoFar),
	deriveCycle(Index, [FVP|CSoFar], CTail).
*/

% Define the groundings of the fluents and output entities/events:

:- dynamic variable/1, var_value/2, sign/1.

grounding(val(Var)=Val):- variable(Var), var_value(Var,Val).
grounding(f(Var)=Val):- variable(Var), var_value(Var,Val).
grounding(order(Var,Sign)=pending):- variable(Var), sign(Sign).
grounding(order(Var,Sign)=cancelled):- variable(Var), sign(Sign).
grounding(order(Var,Sign)=fulfilled):- variable(Var), sign(Sign).
grounding(lastChange(Var)=incr):- variable(Var).
grounding(lastChange(Var)=decr):- variable(Var).

% Declare the order of caching of output entities.

% =================== cycle ================== % 
cachingOrder(val(_)=0).
cachingOrder(val(_)=1). 
cachingOrder(val(_)=2). 
cachingOrder(f(_)=0).
cachingOrder(f(_)=1).
cachingOrder(f(_)=2). 
cachingOrder(order(_,_)=pending).
cachingOrder(order(_,_)=cancelled).
cachingOrder(order(_,_)=fulfilled).
cachingOrder(lastChange(_)=incr).
cachingOrder(lastChange(_)=decr).