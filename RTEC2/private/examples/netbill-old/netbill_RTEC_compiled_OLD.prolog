initiatedAt(quote(_131264,_131265,_131266)=true, _131275, _131249, _131277) :-
     happensAtIE(present_quote(_131264,_131265,_131266,_131274),_131249),
     _131275=<_131249,
     _131249<_131277.

initiatedAt(quote(_131264,_131265,_131266)=false, _131274, _131249, _131276) :-
     happensAtIE(accept_quote(_131265,_131264,_131266),_131249),
     _131274=<_131249,
     _131249<_131276.

initiatedAt(contract(_131264,_131265,_131266)=true, _131318, _131249, _131320) :-
     happensAtIE(accept_quote(_131265,_131264,_131266),_131249),_131318=<_131249,_131249<_131320,
     holdsAtProcessedSimpleFluent(_131264,quote(_131264,_131265,_131266)=true,_131249),
     \+holdsAtCyclic(_131264,suspended(_131264,merchant)=true,_131249),
     \+holdsAtCyclic(_131265,suspended(_131265,consumer)=true,_131249).

initiatedAt(per(present_quote(_131266,_131267))=false, _131276, _131249, _131278) :-
     happensAtIE(present_quote(_131266,_131267,_131274,_131275),_131249),
     _131276=<_131249,
     _131249<_131278.

initiatedAt(per(present_quote(_131266,_131267))=true, _131275, _131249, _131277) :-
     happensAtIE(request_quote(_131267,_131266,_131274),_131249),
     _131275=<_131249,
     _131249<_131277.

initiatedAt(obl(send_EPO(_131266,iServer,_131268))=false, _131286, _131249, _131288) :-
     happensAtIE(send_EPO(_131266,iServer,_131268,_131279),_131249),_131286=<_131249,_131249<_131288,
     price(_131268,_131279).

initiatedAt(obl(send_goods(_131266,iServer,_131268))=false, _131294, _131249, _131296) :-
     happensAtIE(send_goods(_131266,iServer,_131268,_131279,_131280),_131249),_131294=<_131249,_131249<_131296,
     decrypt(_131279,_131280,_131287),
     meets(_131287,_131268).

initiatedAt(suspended(_131264,merchant)=true, _131291, _131249, _131293) :-
     happensAtIE(present_quote(_131264,_131274,_131275,_131276),_131249),_131291=<_131249,_131249<_131293,
     holdsAtProcessedSimpleFluent(_131264,per(present_quote(_131264,_131274))=false,_131249).

initiatedAt(obl(send_EPO(_131270,iServer,_131272))=true, _131249, _131250, _131251) :-
     initiatedAt(contract(_131282,_131270,_131272)=true,_131249,_131250,_131251).

initiatedAt(obl(send_goods(_131270,iServer,_131272))=true, _131249, _131250, _131251) :-
     initiatedAt(contract(_131270,_131283,_131272)=true,_131249,_131250,_131251).

initiatedAt(obl(send_EPO(_131270,iServer,_131272))=false, _131249, _131250, _131251) :-
     initiatedAt(contract(_131282,_131270,_131272)=false,_131249,_131250,_131251).

initiatedAt(obl(send_goods(_131270,iServer,_131272))=false, _131249, _131250, _131251) :-
     initiatedAt(contract(_131270,_131283,_131272)=false,_131249,_131250,_131251).

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
     role_of(_131248,merchant),role_of(_131249,consumer),\+_131248=_131249,queryGoodsDescription(_131250).

cachingOrder2(_131250, per(present_quote(_131250,_131251))=false) :-
     role_of(_131250,merchant),role_of(_131251,consumer),\+_131251=_131250.

cachingOrder2(_131248, contract(_131248,_131249,_131250)=true) :-
     role_of(_131248,merchant),role_of(_131249,consumer),\+_131248=_131249,queryGoodsDescription(_131250).

cachingOrder2(_131250, obl(send_EPO(_131250,iServer,_131252))=true) :-
     role_of(_131250,consumer),queryGoodsDescription(_131252).

cachingOrder2(_131250, obl(send_goods(_131250,iServer,_131252))=true) :-
     role_of(_131250,merchant),queryGoodsDescription(_131252).

cachingOrder2(_131248, suspended(_131248,_131249)=true) :-
     role_of(_131248,_131249).

cachingOrder2(_131250, pow(accept_quote(_131250,_131251,_131252))=true) :-
     role_of(_131251,merchant),role_of(_131250,consumer),\+_131250=_131251,queryGoodsDescription(_131252).

maxDurationUE(quote(_131291,_131292,_131293)=true,quote(_131291,_131292,_131293)=false,5) :- 
     grounding(quote(_131291,_131292,_131293)=true).

maxDuration(contract(_131291,_131292,_131293)=true,contract(_131291,_131292,_131293)=false,5) :- 
     grounding(contract(_131291,_131292,_131293)=true).

maxDurationUE(per(present_quote(_131293,_131294))=false,per(present_quote(_131293,_131294))=true,10) :- 
     grounding(per(present_quote(_131293,_131294))=false).

maxDurationUE(suspended(_131291,_131292)=true,suspended(_131291,_131292)=false,3) :- 
     grounding(suspended(_131291,_131292)=true).

