:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(rich(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(win_lottery(_131567),_131550).

terminatedAt(rich(_131567)=true, _131576, _131550, _131578) :-
     user:happensAt(lose_wallet(_131567),_131550).

cachingOrder2(_131549, rich(_131549)=true) :-
     user:person(_131549).

cachingOrder2(_131549, rich(_131549)=false) :-
     user:person(_131549).
