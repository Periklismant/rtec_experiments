:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(quote(_131568,_131569,_131570)=true, _131582, _131551, _131584) :-
     user:happensAt(present_quote(_131568,_131569,_131570,_131581),_131551).

initiatedAt(quote(_131568,_131569,_131570)=false, _131581, _131551, _131583) :-
     user:happensAt(accept_quote(_131569,_131568,_131570),_131551).

initiatedAt(contract(_131568,_131569,_131570)=true, _131634, _131551, _131636) :-
     user:happensAt(accept_quote(_131569,_131568,_131570),_131551),
     user:holdsAt(quote(_131568,_131569,_131570)=true,_131551),
     \+user:holdsAt(suspended(_131568,merchant)=true,_131551),
     \+user:holdsAt(suspended(_131569,consumer)=true,_131551).

initiatedAt(per(present_quote(_131570,_131571))=false, _131583, _131551, _131585) :-
     user:happensAt(present_quote(_131570,_131571,_131581,_131582),_131551).

initiatedAt(per(present_quote(_131570,_131571))=true, _131582, _131551, _131584) :-
     user:happensAt(request_quote(_131571,_131570,_131581),_131551).

initiatedAt(obl(send_EPO(_131570,iServer,_131572))=false, _131596, _131551, _131598) :-
     user:happensAt(send_EPO(_131570,iServer,_131572,_131586),_131551),
     user:price(_131572,_131586).

initiatedAt(obl(send_goods(_131570,iServer,_131572))=false, _131607, _131551, _131609) :-
     user:happensAt(send_goods(_131570,iServer,_131572,_131586,_131587),_131551),
     user:decrypt(_131586,_131587,_131597),
     user:meets(_131597,_131572).

initiatedAt(suspended(_131568,merchant)=true, _131601, _131551, _131603) :-
     user:happensAt(present_quote(_131568,_131581,_131582,_131583),_131551),
     user:holdsAt(per(present_quote(_131568,_131581))=false,_131551).

initiatedAt(obl(send_EPO(_131574,iServer,_131576))=true, _131551, _131552, _131553) :-
     user:initiatedAt(contract(_131589,_131574,_131576)=true,_131551,_131552,_131553).

initiatedAt(obl(send_goods(_131574,iServer,_131576))=true, _131551, _131552, _131553) :-
     user:initiatedAt(contract(_131574,_131590,_131576)=true,_131551,_131552,_131553).

initiatedAt(obl(send_EPO(_131574,iServer,_131576))=false, _131551, _131552, _131553) :-
     user:initiatedAt(contract(_131589,_131574,_131576)=false,_131551,_131552,_131553).

initiatedAt(obl(send_goods(_131574,iServer,_131576))=false, _131551, _131552, _131553) :-
     user:initiatedAt(contract(_131574,_131590,_131576)=false,_131551,_131552,_131553).

initiatedAt(suspended(_131572,merchant)=true, _131551, _131552, _131553) :-
     user:initiatedAt(contract(_131572,_131590,_131591)=false,_131551,_131552,_131553),
     user:holdsAt(obl(send_goods(_131572,iServer,_131591))=true,_131552).

initiatedAt(suspended(_131572,consumer)=true, _131551, _131552, _131553) :-
     user:initiatedAt(contract(_131589,_131572,_131591)=false,_131551,_131552,_131553),
     user:holdsAt(obl(send_EPO(_131572,iServer,_131591))=true,_131552).

holdsForSDFluent(pow(accept_quote(_131570,_131571,_131572))=true,_131551) :-
     user:holdsFor(quote(_131571,_131570,_131572)=true,_131581),
     user:holdsFor(suspended(_131570,consumer)=true,_131597),
     user:holdsFor(suspended(_131571,merchant)=true,_131612),
     user:relative_complement_all(_131581,[_131597,_131612],_131551).

cachingOrder2(_131550, quote(_131550,_131551,_131552)=true) :-
     user:role_of(_131550,merchant),user:role_of(_131551,consumer),\+_131550=_131551,user:queryGoodsDescription(_131552).

cachingOrder2(_131552, per(present_quote(_131552,_131553))=false) :-
     user:role_of(_131552,merchant),user:role_of(_131553,consumer),\+_131553=_131552.

cachingOrder2(_131550, contract(_131550,_131551,_131552)=true) :-
     user:role_of(_131550,merchant),user:role_of(_131551,consumer),\+_131550=_131551,user:queryGoodsDescription(_131552).

cachingOrder2(_131552, obl(send_EPO(_131552,iServer,_131554))=true) :-
     user:role_of(_131552,consumer),user:queryGoodsDescription(_131554).

cachingOrder2(_131552, obl(send_goods(_131552,iServer,_131554))=true) :-
     user:role_of(_131552,merchant),user:queryGoodsDescription(_131554).

cachingOrder2(_131550, suspended(_131550,_131551)=true) :-
     user:role_of(_131550,_131551).

cachingOrder2(_131552, pow(accept_quote(_131552,_131553,_131554))=true) :-
     user:role_of(_131553,merchant),user:role_of(_131552,consumer),\+_131552=_131553,user:queryGoodsDescription(_131554).
