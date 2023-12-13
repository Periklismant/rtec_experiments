
initiatedAt(voting_in_progress(M)=true, T):-
    happensAt(open_ballot(_A,M), T).

terminatedAt(voting_in_progress(M)=false, T):-
    happensAt(close_ballot(_A,M), T).

fi(voting_in_progress(M)=true, voting_in_progress(M)=false, 5).

grounding(open_ballot(A, M)) :- agent(A), motion(M).
grounding(close_ballot(A, M)) :- agent(A), motion(M).

grounding(voting_in_progress(M)=true):- motion(M).
grounding(voting_in_progress(M)=false):- motion(M).

