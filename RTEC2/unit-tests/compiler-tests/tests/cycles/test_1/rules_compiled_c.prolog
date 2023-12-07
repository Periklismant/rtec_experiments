:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
initiatedAt(strength(_131566)=tired, _131592, _131549, _131594) :-
     user:happensAt(ends_working(_131566),_131549),
     user:holdsAt(strength(_131566)=lowering,_131549).

initiatedAt(strength(_131566)=lowering, _131592, _131549, _131594) :-
     user:happensAt(starts_working(_131566),_131549),
     user:holdsAt(strength(_131566)=full,_131549).

initiatedAt(strength(_131566)=full, _131592, _131549, _131594) :-
     user:happensAt(sleep_end(_131566),_131549),
     user:holdsAt(strength(_131566)=tired,_131549).

initiatedAt(strength(_131570)=full, _131549, -1, _131551) :-
     user: (_131549=< -1),
     user: (-1<_131551).

cachingOrder2(_131548, strength(_131548)=full) :-
     user:person(_131548).

cachingOrder2(_131548, strength(_131548)=tired) :-
     user:person(_131548).

cachingOrder2(_131548, strength(_131548)=lowering) :-
     user:person(_131548).
