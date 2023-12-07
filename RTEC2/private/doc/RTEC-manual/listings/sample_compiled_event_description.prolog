initiatedAt(trust(_131261,_131262)=true, _, _131249, _) :-
     happensAtIE(topic(_131261,_131262),_131249),
     holdsAtProcessedSDFluent(_131261,hmInfluence(_131261)=true,_131249).

terminatedAt(trust(_131261,_131262)=true, _, _131249, _) :-
     happensAtProcessedIE(_131261,start(influence(_131261)=low),_131249).

holdsForSDFluent(hmInfluence(_131264)=true,_131249) :-
     holdsForProcessedIE(_131264,influence(_131264)=high,_131270),
     holdsForProcessedIE(_131264,influence(_131264)=medium,_131281),
     union_all([_131270,_131281],_131249).

cachingOrder2(_131248, hmInfluence(_131248)=true) :-
     id(_131248).

cachingOrder2(_131248, trust(_131248,_131249)=true) :-
     pair(_131248,_131249).

collectIntervals2(_131248, influence(_131248)=high) :-
     id(_131248).

collectIntervals2(_131248, influence(_131248)=medium) :-
     id(_131248).

collectIntervals2(_131248, influence(_131248)=low) :-
     id(_131248).

