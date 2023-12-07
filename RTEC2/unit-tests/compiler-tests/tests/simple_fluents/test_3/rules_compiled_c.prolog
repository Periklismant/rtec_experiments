:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(shappy(_131569)=true, _131583, _131552, _131585) :-
     user:happensAt(startI(happy(_131569)=true),_131552).

terminatedAt(shappy(_131569)=true, _131583, _131552, _131585) :-
     user:happensAt(end(happy(_131569)=true),_131552).

cachingOrder2(_131551, shappy(_131551)=true) :-
     user:person(_131551).
