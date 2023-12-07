event(propose(_,_)).			inputEntity(propose(_,_)).			index(propose(Ag,_), Ag). 		%key(propose(_,_), 1).
event(second(_,_)).				inputEntity(second(_,_)).			index(second(Ag,_), Ag). 		%key(second(_,_), 2).
event(vote(_,_,_)).				inputEntity(vote(_,_,_)).			index(vote(Ag,_,_), Ag). 		%key(vote(_,_,_), 3).
event(close_ballot(_,_)).		inputEntity(close_ballot(_,_)).		index(close_ballot(Ag,_), Ag). 	%key(close_ballot(_,_), 4).
event(declare(_,_,_)).			inputEntity(declare(_,_,_)).		index(declare(Ag,_,_), Ag). 	%key(declare(_,_,_), 5).

simpleFluent(status(_)=null).				outputEntity(status(_)=null).				index(status(M)=null, M).					%key(status(_)=null, 6).
simpleFluent(status(_)=proposed).			outputEntity(status(_)=proposed).			index(status(M)=proposed, M).				%key(status(_)=proposed, 7).
simpleFluent(status(_)=voting).				outputEntity(status(_)=voting).				index(status(M)=voting, M).					%key(status(_)=voting, 8).
simpleFluent(status(_)=voted).				outputEntity(status(_)=voted).				index(status(M)=voted, M).					%key(status(_)=voted, 9).
simpleFluent(outcome(_)=carried).		outputEntity(outcome(_)=carried).		index(outcome(M)=carried, M).
simpleFluent(outcome(_)=not_carried).		outputEntity(outcome(_)=not_carried).		index(outcome(M)=not_carried, M).

sDFluent(pow(propose(_))=true).		outputEntity(pow(propose(_))=true).		index(pow(propose(M))=true, M).
sDFluent(pow(propose(_))=false).		outputEntity(pow(propose(_))=false).		index(pow(propose(M))=false, M).
sDFluent(pow(second(_))=true).		outputEntity(pow(second(_))=true).		index(pow(second(M))=true, M).
sDFluent(pow(second(_))=false).		outputEntity(pow(second(_))=false).		index(pow(second(M))=false, M).
sDFluent(pow(vote(_))=true).			outputEntity(pow(vote(_))=true).		index(pow(vote(M))=true, M).
sDFluent(pow(vote(_))=false).			outputEntity(pow(vote(_))=false).		index(pow(vote(M))=false, M).
sDFluent(pow(close_ballot(_))=true).		outputEntity(pow(close_ballot(_))=true).	index(pow(close_ballot(M))=true, M).
sDFluent(pow(close_ballot(_))=false).		outputEntity(pow(close_ballot(_))=false).	index(pow(close_ballot(M))=false, M).
sDFluent(pow(declare(_))=true).		outputEntity(pow(declare(_))=true).		index(pow(declare(M))=true, M).
sDFluent(pow(declare(_))=false).		outputEntity(pow(declare(_))=false).		index(pow(declare(M))=false, M).

cyclic(status(_)=null).
cyclic(status(_)=proposed).
cyclic(status(_)=voting).
cyclic(status(_)=voted).

% Define the groundings of the fluents and output entities/events:

grounding(status(M)=null)			:- queryMotion(M).
grounding(status(M)=proposed)			:- queryMotion(M).
grounding(status(M)=voting)			:- queryMotion(M).
grounding(status(M)=voted)			:- queryMotion(M).
grounding(outcome(M)=carried)			:- queryMotion(M).
grounding(outcome(M)=not_carried)		:- queryMotion(M).
grounding(pow(propose(M))=true)		:- queryMotion(M).
grounding(pow(second(M))=true)		:- queryMotion(M).
grounding(pow(vote(M))=true)			:- queryMotion(M).
grounding(pow(close_ballot(M))=true)		:- queryMotion(M).
grounding(pow(declare(M))=true)		:- queryMotion(M).


% =================== cycle ================== % 
cachingOrder(status(_)=null). 
cachingOrder(status(_)=proposed).
cachingOrder(status(_)=voting).
cachingOrder(status(_)=voted).
cachingOrder(outcome(_)=carried).		% depends on status(M)
cachingOrder(outcome(_)=not_carried).		% depends on status(M)
cachingOrder(pow(propose(_))=true).		% depends on status(M)
cachingOrder(pow(second(_))=true).		% depends on status(M)
cachingOrder(pow(vote(_))=true).		% depends on status(M)
cachingOrder(pow(close_ballot(_))=true).	% depends on status(M)
cachingOrder(pow(declare(_))=true).		% depends on status(M) 