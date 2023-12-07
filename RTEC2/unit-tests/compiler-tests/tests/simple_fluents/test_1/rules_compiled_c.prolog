:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(sleeping(_131569)=true, _131578, _131552, _131580) :-
     user:happensAt(sleep_start(_131569),_131552).

terminatedAt(sleeping(_131569)=true, _131578, _131552, _131580) :-
     user:happensAt(sleep_end(_131569),_131552).

cachingOrder2(_131551, sleeping(_131551)=true) :-
     user:person(_131551).
