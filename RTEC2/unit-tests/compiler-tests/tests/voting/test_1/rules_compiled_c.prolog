:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(status(_197958)=null, _197963, -1, _197967) :-
     _197963=< -1,
     -1<_197967.

initiatedAt(status(_197966)=null, _197971, -1, _197975) :-
     _197971=< -1,
     -1<_197975.

initiatedAt(status(_131566)=proposed, _131594, _131549, _131596) :-
     user:happensAt(propose(_131577,_131566),_131549),
     user:holdsAt(_131566,status(_131566)=null,_131549).

initiatedAt(status(_131566)=voting, _131594, _131549, _131596) :-
     user:happensAt(second(_131577,_131566),_131549),
     user:holdsAt(_131566,status(_131566)=proposed,_131549).

initiatedAt(status(_131566)=voted, _131603, _131549, _131605) :-
     user:happensAt(close_ballot(_131577,_131566),_131549),
     user:role_of(_131577,chair),
     user:holdsAt(_131566,status(_131566)=voting,_131549).

initiatedAt(status(_131566)=null, _131604, _131549, _131606) :-
     user:happensAt(declare(_131577,_131566,_131579),_131549),
     user:role_of(_131577,chair),
     user:holdsAt(_131566,status(_131566)=voted,_131549).

initiatedAt(voted(_131566,_131567)=_131552, _131592, _131549, _131594) :-
     user:happensAt(vote(_131566,_131567,_131552),_131549),
     user:holdsAt(status(_131567)=voting,_131549).

initiatedAt(voted(_131566,_131567)=null, _131581, _131549, _131583) :-
     user:happensAt(start(status(_131567)=null),_131549).

initiatedAt(outcome(_131566)=_131552, _131600, _131549, _131602) :-
     user:happensAt(declare(_131577,_131566,_131552),_131549),
     user:holdsAt(status(_131566)=voted,_131549),
     user:role_of(_131577,chair).

initiatedAt(auxPerCloseBallot(_131566)=true, _131580, _131549, _131582) :-
     user:happensAt(start(status(_131566)=voting),_131549).

initiatedAt(auxPerCloseBallot(_131566)=false, _131580, _131549, _131582) :-
     user:happensAt(start(status(_131566)=proposed),_131549).

initiatedAt(per(close_ballot(_131568,_131569))=true, _131597, _131549, _131599) :-
     user:happensAt(end(auxPerCloseBallot(_131569)=true),_131549),
     user:holdsAt(status(_131569)=voting,_131549).

initiatedAt(per(close_ballot(_131568,_131569))=false, _131583, _131549, _131585) :-
     user:happensAt(start(status(_131569)=voted),_131549).

initiatedAt(obl(declare(_131568,_131569,carried))=true, _131649, _131549, _131651) :-
     user:happensAt(start(status(_131569)=voted),_131549),
     findall(_131591,holdsAtProcessedSimpleFluent(_131591,voted(_131591,_131569)=aye,_131549),_131593),
     user:length(_131593,_131614),
     findall(_131591,holdsAtProcessedSimpleFluent(_131591,voted(_131591,_131569)=nay,_131549),_131621),
     user:length(_131621,_131642),
     user: (_131614>=_131642).

initiatedAt(obl(declare(_131568,_131569,carried))=false, _131584, _131549, _131586) :-
     user:happensAt(start(status(_131569)=null),_131549).

initiatedAt(sanctioned(_131566)=true, _131595, _131549, _131597) :-
     user:happensAt(close_ballot(_131566,_131578),_131549),
     \+user:holdsAt(per(close_ballot(_131566,_131578))=true,_131549).

initiatedAt(sanctioned(_131566)=true, _131613, _131549, _131615) :-
     user:happensAt(end(status(_131582)=voted),_131549),
     \+user:happensAt(declare(_131566,_131582,carried),_131549),
     user:holdsAt(obl(declare(_131566,_131582,carried))=true,_131549).

initiatedAt(sanctioned(_131566)=true, _131615, _131549, _131617) :-
     user:happensAt(end(status(_131582)=voted),_131549),
     \+user:happensAt(declare(_131566,_131582,not_carried),_131549),
     \+user:holdsAt(obl(declare(_131566,_131582,carried))=true,_131549).

terminatedAt(outcome(_131566)=_131552, _131580, _131549, _131582) :-
     user:happensAt(start(status(_131566)=proposed),_131549).

holdsForSDFluent(pow(propose(_131568,_131569))=true,_131549) :-
     user:holdsFor(status(_131569)=null,_131549).

holdsForSDFluent(pow(second(_131568,_131569))=true,_131549) :-
     user:holdsFor(status(_131569)=proposed,_131549).

holdsForSDFluent(pow(vote(_131568,_131569))=true,_131549) :-
     user:holdsFor(status(_131569)=voting,_131549).

holdsForSDFluent(pow(close_ballot(_131568,_131569))=true,_131549) :-
     user:holdsFor(status(_131569)=voting,_131549).

holdsForSDFluent(pow(declare(_131568,_131569))=true,_131549) :-
     user:holdsFor(status(_131569)=voted,_131549).

cachingOrder2(_131548, status(_131548)=null) :-
     user:queryMotion(_131548).

cachingOrder2(_131548, status(_131548)=proposed) :-
     user:queryMotion(_131548).

cachingOrder2(_131548, status(_131548)=voting) :-
     user:queryMotion(_131548).

cachingOrder2(_131548, status(_131548)=voted) :-
     user:queryMotion(_131548).

cachingOrder2(_131548, voted(_131548,_131549)=aye) :-
     user:role_of(_131548,voter),user:queryMotion(_131549).

cachingOrder2(_131548, voted(_131548,_131549)=nay) :-
     user:role_of(_131548,voter),user:queryMotion(_131549).

cachingOrder2(_131548, outcome(_131548)=carried) :-
     user:queryMotion(_131548).

cachingOrder2(_131548, outcome(_131548)=not_carried) :-
     user:queryMotion(_131548).

cachingOrder2(_131548, auxPerCloseBallot(_131548)=true) :-
     user:queryMotion(_131548).

cachingOrder2(_131550, per(close_ballot(_131550,_131551))=true) :-
     user:role_of(_131550,chair),user:queryMotion(_131551).

cachingOrder2(_131550, obl(declare(_131550,_131551,carried))=true) :-
     user:role_of(_131550,chair),user:queryMotion(_131551).

cachingOrder2(_131548, sanctioned(_131548)=true) :-
     user:role_of(_131548,chair).
