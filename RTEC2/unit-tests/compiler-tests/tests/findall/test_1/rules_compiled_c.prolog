:-dynamic initiatedAt/4, holdsForSDFluent/2, initiatedAt/2, terminatedAt/2, terminatedAt/4, maxDuration/3, maxDurationUE/3.
holdsForSDFluent(workingEfficiently(_131567)=true,_131550) :-
     user:holdsFor(working(_131567)=true,_131576),
     user:holdsFor(sleeping_at_work(_131567)=true,_131590),
     user:relative_complement_all(_131576,[_131590],_131605),
     findall((_131613,_131614),(member(_131605,(_131613,_131614)),_131631 is _131614-_131613,compare(>,_131631,2)),_131550).

cachingOrder2(_131549, workingEfficiently(_131549)=true) :-
     user:person(_131549).
