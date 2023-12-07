initiatedAt(status(_131451)=null, _131456, -1, _131460) :-
     _131456=< -1,
     -1<_131460.

initiatedAt(status(_131139)=proposed, _131160, _131124, _131162) :-
     happensAtIE(propose(_131147,_131139),_131124),_131160=<_131124,_131124<_131162,
     %write('proposed'), nl,
     %write(_131160), write(' '), write(_131124), write(' '), write(_131162), nl, nl,
     holdsAtCyclic(_131139,status(_131139)=null,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(status(_131139)=voting, _131160, _131124, _131162) :-
     happensAtIE(second(_131147,_131139),_131124),_131160=<_131124,_131124<_131162,
     %write('voting'), nl,
     %write(_131160), write(' '), write(_131124), write(' '), write(_131162), nl, nl,
     holdsAtCyclic(_131139,status(_131139)=proposed,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(status(_131139)=voted, _131166, _131124, _131168) :-
     happensAtIE(close_ballot(_131147,_131139),_131124),_131166=<_131124,_131124<_131168,
     role_of(_131147,chair),
     %write('voted'), nl,
     %write(_131166), write(' '), write(_131124), write(' '), write(_131168), nl, nl,
     holdsAtCyclic(_131139,status(_131139)=voting,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(status(_131139)=null, _131167, _131124, _131169) :-
     happensAtIE(declare(_131147,_131139,_131149),_131124),_131167=<_131124,_131124<_131169,
     role_of(_131147,chair),
     %write('null'), nl,
     %write(_131167), write(' '), write(_131124), write(' '), write(_131169), nl, nl,
     holdsAtCyclic(_131139,status(_131139)=voted,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(voted(_131139,_131140)=_131127, _131159, _131124, _131161) :-
     happensAtIE(vote(_131139,_131140,_131127),_131124),_131159=<_131124,_131124<_131161,
     holdsAtProcessedSimpleFluent(_131140,status(_131140)=voting,_131124).

initiatedAt(voted(_131139,_131140)=null, _131151, _131124, _131153) :-
     happensAtProcessedSimpleFluent(_131140,start(status(_131140)=null),_131124),
     _131151=<_131124,
     _131124<_131153.

initiatedAt(outcome(_131139)=_131127, _131164, _131124, _131166) :-
     happensAtIE(declare(_131147,_131139,_131127),_131124),_131164=<_131124,_131124<_131166,
     holdsAtProcessedSimpleFluent(_131139,status(_131139)=voted,_131124),
     role_of(_131147,chair).

terminatedAt(outcome(_131139)=_131127, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(status(_131139)=proposed),_131124),
     _131150=<_131124,
     _131124<_131152.

initiatedAt(auxPerCloseBallot(_131139)=true, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(status(_131139)=voting),_131124),
     _131150=<_131124,
     _131124<_131152,
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(auxPerCloseBallot(_131139)=false, _131150, _131124, _131152) :-
     happensAtProcessedSimpleFluent(_131139,start(status(_131139)=proposed),_131124),
     _131150=<_131124,
     _131124<_131152,
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(per(close_ballot(_131141,_131142))=true, _131164, _131124, _131166) :-
     happensAtProcessedSimpleFluent(_131142,end(auxPerCloseBallot(_131142)=true),_131124),_131164=<_131124,_131124<_131166,
     holdsAtProcessedSimpleFluent(_131142,status(_131142)=voting,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(per(close_ballot(_131141,_131142))=false, _131153, _131124, _131155) :-
     happensAtProcessedSimpleFluent(_131142,start(status(_131142)=voted),_131124),
     _131153=<_131124,
     _131124<_131155,
     updateVariableTemp(computed_initiations_non_extensible, 1).


% the cachingOrder2/2 definition of auxMotionOutcomeEvent should appear right after that of the voted fluent.

% auxMotionOutcomeEvent(M,carried) is an output entity/event
happensAtEv(auxMotionOutcomeEvent(M,carried), T) :-
     happensAtProcessedSimpleFluent(M, start(status(M)=voted), T),
     findall(V, holdsAtProcessedSimpleFluent(V, voted(V,M)=aye, T), AyeList), length(AyeList, AL), 
     findall(V, holdsAtProcessedSimpleFluent(V, voted(V,M)=nay, T), NayList), length(NayList, NL),
     % standing rules: simple majority
     AL>=NL.


initiatedAt(obl(declare(_C,M,carried))=true, T1, T, T2) :-
     % fetch the cached time-points of the output entity below
     happensAtProcessed(M, auxMotionOutcomeEvent(M,carried), T),
     T1 =< T, T< T2.

initiatedAt(obl(declare(_C,M,carried))=false, T1, T, T2) :-
     happensAtProcessedSimpleFluent(M, start(status(M)=null), T),
     T1 =< T, T< T2.
/*
initiatedAt(obl(declare(_131141,_131142,carried))=true, _131210, _131124, _131212) :-
     happensAtProcessedSimpleFluent(_131142,start(status(_131142)=voted),_131124),_131210=<_131124,_131124<_131212,
     findall(_131161,holdsAtProcessedSimpleFluent(_131161,voted(_131161,_131142)=aye,_131124),_131163),
     length(_131163,_131181),
     findall(_131161,holdsAtProcessedSimpleFluent(_131161,voted(_131161,_131142)=nay,_131124),_131188),
     length(_131188,_131206),
     _131181>=_131206.

initiatedAt(obl(declare(_131141,_131142,carried))=false, _131154, _131124, _131156) :-
     happensAtProcessedSimpleFluent(_131142,start(status(_131142)=null),_131124),
     _131154=<_131124,
     _131124<_131156.
*/

initiatedAt(sanctioned(_131139)=true, _131162, _131124, _131164) :-
     happensAtIE(close_ballot(_131139,_131148),_131124),_131162=<_131124,_131124<_131164,
     \+holdsAtProcessedSimpleFluent(_131139,per(close_ballot(_131139,_131148))=true,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(sanctioned(_131139)=true, _131177, _131124, _131179) :-
     happensAtProcessedSimpleFluent(_131152,end(status(_131152)=voted),_131124),_131177=<_131124,_131124<_131179,
     \+happensAtIE(declare(_131139,_131152,carried),_131124),
     holdsAtProcessedSimpleFluent(_131139,obl(declare(_131139,_131152,carried))=true,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).

initiatedAt(sanctioned(_131139)=true, _131179, _131124, _131181) :-
     happensAtProcessedSimpleFluent(_131152,end(status(_131152)=voted),_131124),_131179=<_131124,_131124<_131181,
     \+happensAtIE(declare(_131139,_131152,not_carried),_131124),
     \+holdsAtProcessedSimpleFluent(_131139,obl(declare(_131139,_131152,carried))=true,_131124),
     updateVariableTemp(computed_initiations_non_extensible, 1).


%holdsForSDFluent(pow(propose(_131141,_131142))=true,_131124) :-
%     holdsForProcessedSimpleFluent(_131142,status(_131142)=null,_131124).

%holdsForSDFluent(pow(second(_131141,_131142))=true,_131124) :-
%     holdsForProcessedSimpleFluent(_131142,status(_131142)=proposed,_131124).

%holdsForSDFluent(pow(vote(_131141,_131142))=true,_131124) :-
%     holdsForProcessedSimpleFluent(_131142,status(_131142)=voting,_131124).

%holdsForSDFluent(pow(close_ballot(_131141,_131142))=true,_131124) :-
%     holdsForProcessedSimpleFluent(_131142,status(_131142)=voting,_131124).

%holdsForSDFluent(pow(declare(_131141,_131142))=true,_131124) :-
%     holdsForProcessedSimpleFluent(_131142,status(_131142)=voted,_131124).

cachingOrder2(_131123, status(_131123)=proposed) :-
     queryMotion(_131123).

cachingOrder2(_131123, status(_131123)=voting) :-
     queryMotion(_131123).

cachingOrder2(_131123, status(_131123)=voted) :-
     queryMotion(_131123).

cachingOrder2(_131123, status(_131123)=null) :-
     queryMotion(_131123).

cachingOrder2(_131141, pow(propose(_131141,_131142))=true) :-
     person(_131141), queryMotion(_131142).

cachingOrder2(_131141, pow(second(_131141,_131142))=true) :-
     person(_131141), queryMotion(_131142).

cachingOrder2(_131141, pow(vote(_131141,_131142))=true) :-
     person(_131141), role_of(_131141,voter), queryMotion(_131142).

cachingOrder2(_131141, pow(close_ballot(_131141,_131142))=true) :-
     person(_131141), role_of(_131141,chair), queryMotion(_131142).

cachingOrder2(_131141, pow(declare(_131141,_131142))=true) :-
     person(_131141), role_of(_131141,chair), queryMotion(_131142).

cachingOrder2(_131123, voted(_131123,_131124)=aye) :-
     person(_131123),role_of(_131123,voter),queryMotion(_131124).

cachingOrder2(_131123, voted(_131123,_131124)=nay) :-
     person(_131123),role_of(_131123,voter),queryMotion(_131124).

cachingOrder2(M, auxMotionOutcomeEvent(M, Outcome)):-
     queryMotion(M).

cachingOrder2(_131123, outcome(_131123)=carried) :-
     queryMotion(_131123).

cachingOrder2(_131123, outcome(_131123)=not_carried) :-
     queryMotion(_131123).

cachingOrder2(_131123, auxPerCloseBallot(_131123)=true) :-
     queryMotion(_131123).

cachingOrder2(_131125, per(close_ballot(_131125,_131126))=true) :-
     person(_131125),role_of(_131125,chair),queryMotion(_131126).

cachingOrder2(_131125, obl(declare(_131125,_131126,carried))=true) :-
     person(_131125),role_of(_131125,chair),queryMotion(_131126).

cachingOrder2(_131123, sanctioned(_131123)=true) :-
     person(_131123),role_of(_131123,chair).

initDeadlines(Mult) :- 
     StatusDeadline is Mult * 10,
     nb_setval(statusDeadline, StatusDeadline),
     AuxPerDeadline is Mult * 8,
     nb_setval(auxPerDeadline, AuxPerDeadline),
     SanctionedDeadline is Mult * 4,
     nb_setval(sanctionedDeadline, SanctionedDeadline).

maxDuration(status(_131176)=proposed,status(_131176)=null, StatusDeadline) :- 
     nb_getval(statusDeadline, StatusDeadline), motion(_131176).

maxDuration(status(_131176)=voting,status(_131176)=voted, StatusDeadline) :- 
     nb_getval(statusDeadline, StatusDeadline), motion(_131176).

maxDuration(status(_131176)=voted,status(_131176)=null, StatusDeadline) :- 
     nb_getval(statusDeadline, StatusDeadline), motion(_131176).

maxDuration(auxPerCloseBallot(_131176)=true,auxPerCloseBallot(_131176)=false, AuxPerDeadline) :- 
     nb_getval(auxPerDeadline, AuxPerDeadline), motion(_131176).

maxDuration(sanctioned(_131176)=true,sanctioned(_131176)=false, SanctionedDeadline) :- 
     nb_getval(sanctionedDeadline, SanctionedDeadline), role_of(_131176,chair).

