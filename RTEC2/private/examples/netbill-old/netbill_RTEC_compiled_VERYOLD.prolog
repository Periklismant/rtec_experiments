
:- ['../../RTEC.prolog'].
:- ['netbill_RTEC_declarations.prolog'].
:- ['../../timeoutTreatment.prolog'].

initiatedAt(quote(_131268,_131269,_131270)=true, _131249, _131250, _131251) :-
     happensAtIE(present_quote(_131268,_131269,_131270,_131281),_131250),
     _131249=<_131250,
     _131250<_131251.

initiatedAt(quote(_131268,_131269,_131270)=false, _131249, _131250, _131251) :-
     happensAtIE(accept_quote(_131269,_131268,_131270),_131250),
     _131249=<_131250,
     _131250<_131251.

initiatedAt(contract(_131268,_131269,_131270)=true, _131249, _131250, _131251) :-
     happensAtIE(accept_quote(_131269,_131268,_131270),_131250),
     _131249=<_131250,
     _131250<_131251,
     holdsAtProcessedSimpleFluent(_131268,quote(_131268,_131269,_131270)=true,_131250),
     \+holdsAtCyclic(_131268,suspended(_131268,merchant)=true,_131250),
     \+holdsAtCyclic(_131269,suspended(_131269,consumer)=true,_131250).

initiatedAt(per(present_quote(_131270,_131271))=true, _131249, -1, _131251) :-
     _131249=< -1,
     -1<_131251.

initiatedAt(per(present_quote(_131270,_131271))=false, _131249, _131250, _131251) :-
     happensAtIE(present_quote(_131270,_131271,_131281,_131282),_131250),
     _131249=<_131250,
     _131250<_131251.

initiatedAt(per(present_quote(_131270,_131271))=true, _131249, _131250, _131251) :-
     happensAtIE(request_quote(_131271,_131270,_131281),_131250),
     _131249=<_131250,
     _131250<_131251.

initiatedAt(obl(send_EPO(_131270,iServer,_131272))=true, _131249, _131250, _131251) :-
     initiatedAt(contract(_131282,_131270,_131272)=true,_131249,_131250,_131251).

initiatedAt(obl(send_goods(_131270,iServer,_131272))=true, _131249, _131250, _131251) :-
     initiatedAt(contract(_131270,_131283,_131272)=true,_131249,_131250,_131251).

initiatedAt(obl(send_EPO(_131270,iServer,_131272))=false, _131249, _131250, _131251) :-
     happensAtIE(send_EPO(_131270,iServer,_131272,_131283),_131250),
     _131249=<_131250,
     _131250<_131251,
     price(_131272,_131283).

initiatedAt(obl(send_goods(_131270,iServer,_131272))=false, _131249, _131250, _131251) :-
     happensAtIE(send_goods(_131270,iServer,_131272,_131283,_131284),_131250),
     _131249=<_131250,
     _131250<_131251,
     decrypt(_131283,_131284,_131303),
     meets(_131303,_131272).

initiatedAt(obl(send_EPO(_131270,iServer,_131272))=false, _131249, _131250, _131251) :-
     initiatedAt(contract(_131282,_131270,_131272)=false,_131249,_131250,_131251).

initiatedAt(obl(send_goods(_131270,iServer,_131272))=false, _131249, _131250, _131251) :-
     initiatedAt(contract(_131270,_131283,_131272)=false,_131249,_131250,_131251).

initiatedAt(suspended(_131268,merchant)=true, _131249, _131250, _131251) :-
     happensAtIE(present_quote(_131268,_131278,_131279,_131280),_131250),
     _131249=<_131250,
     _131250<_131251,
     \+holdsAtProcessedSimpleFluent(_131268,per(present_quote(_131268,_131278))=true,_131250).

initiatedAt(suspended(_131268,merchant)=true, _131249, _131250, _131251) :-
     initiatedAt(contract(_131268,_131283,_131284)=false,_131249,_131250,_131251),
     holdsAtCyclic(_131268,obl(send_goods(_131268,iServer,_131284))=true,_131250).

initiatedAt(suspended(_131268,consumer)=true, _131249, _131250, _131251) :-
     initiatedAt(contract(_131282,_131268,_131284)=false,_131249,_131250,_131251),
     holdsAtCyclic(_131268,obl(send_EPO(_131268,iServer,_131284))=true,_131250).

holdsForSDFluent(pow(accept_quote(_131266,_131267,_131268))=true,_131249) :-
     holdsForProcessedSimpleFluent(_131267,quote(_131267,_131266,_131268)=true,_131274),
     holdsForProcessedSimpleFluent(_131266,suspended(_131266,consumer)=true,_131287),
     holdsForProcessedSimpleFluent(_131267,suspended(_131267,merchant)=true,_131299),
     relative_complement_all(_131274,[_131287,_131299],_131249).

cachingOrder2(_131248, quote(_131248,_131249,_131250)=true) :-
     role_of(_131248,merchant),role_of(_131249,consumer),\+_131248=_131249,goods_description(_131250).

cachingOrder2(_131250, per(present_quote(_131250,_131251))=true) :-
     role_of(_131250,merchant),role_of(_131251,consumer),\+_131251=_131250.

cachingOrder2(_131248, contract(_131248,_131249,_131250)=true) :-
     role_of(_131248,merchant),role_of(_131249,consumer),\+_131248=_131249,goods_description(_131250).

cachingOrder2(_131250, obl(send_EPO(_131250,iServer,_131252))=true) :-
     role_of(_131250,consumer),goods_description(_131252).

cachingOrder2(_131250, obl(send_goods(_131250,iServer,_131252))=true) :-
     role_of(_131250,merchant),goods_description(_131252).

cachingOrder2(_131248, suspended(_131248,_131249)=true) :-
     role_of(_131248,_131249).

cachingOrder2(_131250, pow(accept_quote(_131250,_131251,_131252))=true) :-
     role_of(_131251,merchant),role_of(_131250,consumer),\+_131250=_131251,goods_description(_131252).

maxDuration(quote(_131291,_131292,_131293)=true,quote(_131291,_131292,_131293)=false,5) :- 
     grounding(quote(_131291,_131292,_131293)=true).

maxDuration(contract(_131291,_131292,_131293)=true,contract(_131291,_131292,_131293)=false,5) :- 
     grounding(contract(_131291,_131292,_131293)=true).

maxDurationUE(suspended(_131291,_131292)=true,suspended(_131291,_131292)=false,3) :- 
     grounding(suspended(_131291,_131292)=true).

