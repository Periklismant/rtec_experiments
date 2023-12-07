initiatedAt(status(_131576)=null, _131581, -1, _131585) :-
     _131581=< -1,
     -1<_131585.

initiatedAt(status(_131264)=proposed, _131286, _131249, _131288) :-
     happensAtIE(propose(_131272,_131264),_131249),_131286=<_131249,_131249<_131288,
     holdsAtCyclic(_131264,status(_131264)=null,_131249).

initiatedAt(status(_131264)=voting, _131286, _131249, _131288) :-
     happensAtIE(second(_131272,_131264),_131249),_131286=<_131249,_131249<_131288,
     holdsAtCyclic(_131264,status(_131264)=proposed,_131249).

initiatedAt(status(_131264)=voted, _131292, _131249, _131294) :-
     happensAtIE(close_ballot(_131272,_131264),_131249),_131292=<_131249,_131249<_131294,
     role_of(_131272,chair),
     holdsAtCyclic(_131264,status(_131264)=voting,_131249).

initiatedAt(status(_131264)=null, _131293, _131249, _131295) :-
     happensAtIE(declare(_131272,_131264,_131274),_131249),_131293=<_131249,_131249<_131295,
     role_of(_131272,chair),
     holdsAtCyclic(_131264,status(_131264)=voted,_131249).

initiatedAt(voted(_131264,_131265)=_131252, _131284, _131249, _131286) :-
     happensAtIE(vote(_131264,_131265,_131252),_131249),_131284=<_131249,_131249<_131286,
     holdsAtProcessedSimpleFluent(_131265,status(_131265)=voting,_131249).

initiatedAt(voted(_131264,_131265)=null, _131276, _131249, _131278) :-
     happensAtProcessedSimpleFluent(_131265,start(status(_131265)=null),_131249),
     _131276=<_131249,
     _131249<_131278.

initiatedAt(outcome(_131264)=_131252, _131289, _131249, _131291) :-
     happensAtIE(declare(_131272,_131264,_131252),_131249),_131289=<_131249,_131249<_131291,
     holdsAtProcessedSimpleFluent(_131264,status(_131264)=voted,_131249),
     role_of(_131272,chair).

initiatedAt(auxPerCloseBallot(_131264)=true, _131275, _131249, _131277) :-
     happensAtProcessedSimpleFluent(_131264,start(status(_131264)=voting),_131249),
     _131275=<_131249,
     _131249<_131277.

initiatedAt(auxPerCloseBallot(_131264)=false, _131275, _131249, _131277) :-
     happensAtProcessedSimpleFluent(_131264,start(status(_131264)=proposed),_131249),
     _131275=<_131249,
     _131249<_131277.

initiatedAt(per(close_ballot(_131266,_131267))=true, _131289, _131249, _131291) :-
     happensAtProcessedSimpleFluent(_131267,end(auxPerCloseBallot(_131267)=true),_131249),_131289=<_131249,_131249<_131291,
     holdsAtProcessedSimpleFluent(_131267,status(_131267)=voting,_131249).

initiatedAt(per(close_ballot(_131266,_131267))=false, _131278, _131249, _131280) :-
     happensAtProcessedSimpleFluent(_131267,start(status(_131267)=voted),_131249),
     _131278=<_131249,
     _131249<_131280.

initiatedAt(obl(declare(_131266,_131267,carried))=true, _131335, _131249, _131337) :-
     happensAtProcessedSimpleFluent(_131267,start(status(_131267)=voted),_131249),_131335=<_131249,_131249<_131337,
     findall(_131286,holdsAtProcessedSimpleFluent(_131286,voted(_131286,_131267)=aye,_131249),_131288),
     length(_131288,_131306),
     findall(_131286,holdsAtProcessedSimpleFluent(_131286,voted(_131286,_131267)=nay,_131249),_131313),
     length(_131313,_131331),
     _131306>=_131331.

initiatedAt(obl(declare(_131266,_131267,carried))=false, _131279, _131249, _131281) :-
     happensAtProcessedSimpleFluent(_131267,start(status(_131267)=null),_131249),
     _131279=<_131249,
     _131249<_131281.

initiatedAt(sanctioned(_131264)=true, _131287, _131249, _131289) :-
     happensAtIE(close_ballot(_131264,_131273),_131249),_131287=<_131249,_131249<_131289,
     \+holdsAtProcessedSimpleFluent(_131264,per(close_ballot(_131264,_131273))=true,_131249).

initiatedAt(sanctioned(_131264)=true, _131302, _131249, _131304) :-
     happensAtProcessedSimpleFluent(_131277,end(status(_131277)=voted),_131249),_131302=<_131249,_131249<_131304,
     \+ (happensAtIE(declare(_131264,_131277,carried),_131249),_131302=<_131249,_131249<_131304),
     holdsAtProcessedSimpleFluent(_131264,obl(declare(_131264,_131277,carried))=true,_131249).

initiatedAt(sanctioned(_131264)=true, _131304, _131249, _131306) :-
     happensAtProcessedSimpleFluent(_131277,end(status(_131277)=voted),_131249),_131304=<_131249,_131249<_131306,
     \+ (happensAtIE(declare(_131264,_131277,not_carried),_131249),_131304=<_131249,_131249<_131306),
     \+holdsAtProcessedSimpleFluent(_131264,obl(declare(_131264,_131277,carried))=true,_131249).

terminatedAt(outcome(_131264)=_131252, _131275, _131249, _131277) :-
     happensAtProcessedSimpleFluent(_131264,start(status(_131264)=proposed),_131249),
     _131275=<_131249,
     _131249<_131277.

holdsForSDFluent(pow(propose(_131266,_131267))=true,_131249) :-
     holdsForProcessedSimpleFluent(_131267,status(_131267)=null,_131249).

holdsForSDFluent(pow(second(_131266,_131267))=true,_131249) :-
     holdsForProcessedSimpleFluent(_131267,status(_131267)=proposed,_131249).

holdsForSDFluent(pow(vote(_131266,_131267))=true,_131249) :-
     holdsForProcessedSimpleFluent(_131267,status(_131267)=voting,_131249).

holdsForSDFluent(pow(close_ballot(_131266,_131267))=true,_131249) :-
     holdsForProcessedSimpleFluent(_131267,status(_131267)=voting,_131249).

holdsForSDFluent(pow(declare(_131266,_131267))=true,_131249) :-
     holdsForProcessedSimpleFluent(_131267,status(_131267)=voted,_131249).

cachingOrder2(_131248, status(_131248)=null) :-
     queryMotion(_131248).

cachingOrder2(_131248, status(_131248)=proposed) :-
     queryMotion(_131248).

cachingOrder2(_131248, status(_131248)=voting) :-
     queryMotion(_131248).

cachingOrder2(_131248, status(_131248)=voted) :-
     queryMotion(_131248).

cachingOrder2(_131248, voted(_131248,_131249)=aye) :-
     role_of(_131248,voter),queryMotion(_131249).

cachingOrder2(_131248, voted(_131248,_131249)=nay) :-
     role_of(_131248,voter),queryMotion(_131249).

cachingOrder2(_131248, outcome(_131248)=carried) :-
     queryMotion(_131248).

cachingOrder2(_131248, outcome(_131248)=not_carried) :-
     queryMotion(_131248).

cachingOrder2(_131248, auxPerCloseBallot(_131248)=true) :-
     queryMotion(_131248).

cachingOrder2(_131250, per(close_ballot(_131250,_131251))=true) :-
     role_of(_131250,chair),queryMotion(_131251).

cachingOrder2(_131250, obl(declare(_131250,_131251,carried))=true) :-
     role_of(_131250,chair),queryMotion(_131251).

cachingOrder2(_131248, sanctioned(_131248)=true) :-
     role_of(_131248,chair).

maxDuration(status(_131291)=proposed,status(_131291)=null,10) :- 
     motion(_131291).

maxDuration(status(_131291)=voting,status(_131291)=voted,10) :- 
     motion(_131291).

maxDuration(status(_131291)=voted,status(_131291)=null,10) :- 
     motion(_131291).

maxDuration(auxPerCloseBallot(_131291)=true,auxPerCloseBallot(_131291)=false,8) :- 
     motion(_131291).

maxDuration(sanctioned(_131291)=true,sanctioned(_131291)=false,4) :- 
     role_of(_131291,chair).

