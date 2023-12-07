:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(rich(_131569)=true, _131594, _131552, _131596) :-
     user:happensAt(win_lottery(_131569),_131552),
     \+user:holdsAt(sleeping(_131569)=true,_131552).

terminatedAt(rich(_131569)=true, _131578, _131552, _131580) :-
     user:happensAt(lose_wallet(_131569),_131552).

cachingOrder2(_131551, sleeping(_131551)=true) :-
     user:person(_131551).

cachingOrder2(_131551, sleeping(_131551)=false) :-
     user:person(_131551).

cachingOrder2(_131551, rich(_131551)=true) :-
     user:person(_131551).

cachingOrder2(_131551, rich(_131551)=false) :-
     user:person(_131551).
