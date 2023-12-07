:- ['mini-ctm-rules-compiled.prolog'].
:- ['mini-ctm-declarations.prolog'].
:- ['mini-ctm-vehicles.prolog'].
:- ['mini-ctm-narrative.prolog'].
:- ['RTEC.prolog'].

performER(WM, Step) :-
	open('outputEntities.txt', write, StreamOE),
	initialiseRecognition(unordered, nopreprocessing, 1),
	updateSDE( 0, WM ),
	eventRecognition( Step, WM ),
	write( 'ER: ' ), write(Step), write(' '), write(WM), nl, 
	write(StreamOE, 'Query Time: '), write(StreamOE, Step), nl(StreamOE),
	findall((E,L1), (outputEntity(E), happensAt(E,L1)), CC1),
	findall((F=V,L2), (outputEntity(F=V), holdsFor(F=V,L2)), CC2),
	forall(member(C1, CC1), (write(StreamOE, C1), nl(StreamOE))),
	forall(member(C2, CC2), (write(StreamOE, C2), nl(StreamOE))).

