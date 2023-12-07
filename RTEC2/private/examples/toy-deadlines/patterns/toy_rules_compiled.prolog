initiatedAt(has_won_lottery(P)=true, T1, T, T2) :-
     happensAtIE(win_lottery(P), T),T1=<T,T<T2.

terminatedAt(rich(P)=true, T1, T, T2) :-
     happensAtIE(lose_wallet(P), T),T1=<T,T<T2.

initiatedAt(location(P)=Loc, T1, T, T2) :-
     happensAtIE(go_to(P,Loc),T),T1=<T,T<T2.

initiatedAt(drunk_alcohol(P)=true, T1, T, T2) :- 
     happensAtIE(drinks(P,beer), T),T1=<T,T<T2.
     holdsAtProcessedSimpleFluent(P, location(P)=pub, T).

cachingOrder2(P, has_won_lottery(P)=true) :-
     person(P).

cachingOrder2(P, has_won_lottery(P)=false) :-
     person(P).

cachingOrder2(P, rich(P)=true) :-
     person(P).

cachingOrder2(P, rich(P)=false) :-
     person(P).

cachingOrder2(P, location(P)=home) :-
     person(P),place(home).

cachingOrder2(P, location(P)=pub) :-
     person(P),place(pub).

cachingOrder2(P, location(P)=work) :-
     person(P),place(work).

cachingOrder2(P, drunk_alcohol(P)=true) :-
     person(P).

cachingOrder2(P, drunk_alcohol(P)=false) :-
     person(P).

cachingOrder2(P, drunk(P)=true) :-
     person(P).

cachingOrder2(P, drunk(P)=false) :-
     person(P).

maxDuration(has_won_lottery(P)=true, rich(P)=true, 10) :-
     grounding(has_won_lottery(P)=true).

maxDurationUE(drunk_alcohol(P)=true, drunk(P)=true, 2) :-
     grounding(drunk_alcohol(P)=true).

maxDurationUE(drunk(P)=true, drunk(P)=false, 5) :-
     grounding(drunk(P)=true).


