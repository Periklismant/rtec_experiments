% Basic Event Calculus

%% Include the BASIC EVENT CALCULUS THEORY
#include 'src/bec.incl'.

%% Load event narrative
% We load the narrative via the execution script.
%#include '../input/voting-30-5.pl'.

%% Grounding of Entities %% 
delay(5).

%% Domain Knowledge %%

initiates(open_ballot(C,M), voting_in_progress(M), T):-
    motion(M), agent(C).
terminates(close_ballot(C,M), voting_in_progress(M), T):- 
    motion(M), agent(C).
trajectory(voting_in_progress(M), T1, permitted_to_close(M), T2) :- delay(R), T2 .>=. T1 + R.

