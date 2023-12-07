:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(working(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(starts_working(_131567),_131550).

terminatedAt(working(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(ends_working(_131567),_131550).

cachingOrder2(_131549, working(_131549)=true) :-
     user:person(_131549).

cachingOrder2(_131549, working(_131549)=false) :-
     user:person(_131549).
