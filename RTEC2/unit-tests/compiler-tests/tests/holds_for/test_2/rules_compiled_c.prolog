:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
holdsForSDFluent(drunk(_131567)=true,_131550) :-
     user:holdsFor(happy(_131567)=true,_131576),
     user:holdsFor(infiniteBeers(_131567)=true,_131590),
     user:intersect_all([_131576,_131590],_131550).

cachingOrder2(_131549, infiniteBeers(_131549)=true) :-
     user:person(_131549).
