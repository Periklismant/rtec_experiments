/*
This version of the data generator can create csv files of input data using the 'createNarrative/4' predicate. 
Its arguments are:
	Start -> the starting timestamp of the reasoning process.
	End -> the final timestamp of the process.
	Seed -> Used by the random package to create a unique dataset. 
			The same Seed value will always yield the same dataset (given that all other parameters are equal).
	AgentNo -> the number of agents to be asserted.
WARNING. 'createNarrative/4' asserts the appropriate number of agents. 
Agent assertions via different files should be avoided when using this predicate -> 
Comment out agent assertions in the static generator file.
*/

:- use_module(library(random)).
:- use_module(library(lists)).

% compute a random subset of a list when Limit<1 and a superset otherwise
% random_subset(+List, +ListLength, +ListSubsetLimit, [], -ListSubset)
random_subset(_List, _Length, Limit, ListSubset, ListSubset) :-
	length(ListSubset, ListSubsetLength),
	ListSubsetLength >= Limit, !.
random_subset(List, Length, Limit, InitialListSubset, ListSubset) :-
	Temp is random(Length),
	nth0(Temp, List, RandomElement),
	random_subset(List, Length, Limit, [RandomElement|InitialListSubset], ListSubset).

createNarrative(Start, End, AgentNo, Seed):-
	Start<End,
	set_random(seed(Seed)),
	consult('../auxiliary/voting_static_generator.prolog'),
	assert_n_agents(AgentNo),
	openFile(AgentNo,Seed, WriteFileStream),
	updateNarrative(Start, End, WriteFileStream),
	close(WriteFileStream), !.

updateNarrative(Start, End, _Stream):-
	Start >= End.

updateNarrative(Start, End, WriteFileStream):-
	TempEnd is Start + 10,
	updateSDE(Start, TempEnd, WriteFileStream),
	updateNarrative(TempEnd, End, WriteFileStream).

updateSDE(Start, End, WriteFileStream) :-
	% sanity check:
	Start<End,
	%%%%%%%%%%% count the agents occupying various roles %%%%%%%%%%%%%%%%%%
	findall(Ag, (person(Ag),\+role_of(Ag,chair),\+role_of(Ag,voter)), NoRoleList),
	length(NoRoleList, NoRoleNo), 
	findall(V, role_of(V,voter), VotersList), length(VotersList, VotersNo), 
	findall(C, role_of(C,chair), ChairsList), length(ChairsList, ChairsNo), 
	findall(V, (role_of(V,voter),\+role_of(V,chair)), VotersOnlyList),
	length(VotersOnlyList, VotersOnlyNo), 
	findall(C, (role_of(C,chair),\+role_of(C,voter)), ChairsOnlyList),
	length(ChairsOnlyList, ChairsOnlyNo), 
	findall(VC, (role_of(VC,voter),role_of(VC,chair)), VotersChairsList),
	length(VotersChairsList, VotersChairsNo),
	%%%%%%%%%%% count the number of motions %%%%%%%%%%%%%%%%%%
	findall(M, motion(M), MotionsList), length(MotionsList, MotionsNo), 
	%%%%%%%%%%% propose motion %%%%%%%%%%%%%%%%%% 
	handleMsg(VotersChairsList, VotersChairsNo, 1.3, MotionsList, MotionsNo, propose, [], Start, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus1 is Start+1,
	%%%%%%%%%%% propose motion %%%%%%%%%%%%%%%%%% 
	handleMsg(VotersList, VotersNo, 0.2, MotionsList, MotionsNo, propose, [], StartPlus1, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus2 is Start+2,
	%%%%%%%%%%% close ballot %%%%%%%%%%%%%%%%%% 
	handleMsg(VotersChairsList, VotersChairsNo, 0.1, MotionsList, MotionsNo, close_ballot, [], StartPlus2, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus3 is Start+3,
	%%%%%%%%%%% second motion %%%%%%%%%%%%%%%%%% 
	handleMsg(VotersChairsList, VotersChairsNo, 1.8, MotionsList, MotionsNo, second, [], StartPlus3, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus4 is Start+4,
	%%%%%%%%%%% voting %%%%%%%%%%%%%%%%%% 
	handleMsg(VotersList, VotersNo, 2.3, MotionsList, MotionsNo, vote, aye, StartPlus4, WriteFileStream),
	handleMsg(VotersList, VotersNo, 2.4, MotionsList, MotionsNo, vote, nay, StartPlus4, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus5 is Start+5,
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus6 is Start+6,
	%%%%%%%%%%% voting %%%%%%%%%%%%%%%%%% 
	handleMsg(VotersList, VotersNo, 2.8, MotionsList, MotionsNo, vote, aye, StartPlus6, WriteFileStream),
	handleMsg(VotersList, VotersNo, 2.7, MotionsList, MotionsNo, vote, nay, StartPlus6, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus7 is Start+7,
	%%%%%%%%%%% close ballot %%%%%%%%%%%%%%%%%% 
	handleMsg(ChairsList, ChairsNo, 0.4, MotionsList, MotionsNo, close_ballot, [], StartPlus7, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus8 is Start+8,
	%%%%%%%%%%% declare result %%%%%%%%%%%%%%%%%% 
	handleMsg(ChairsList, ChairsNo, 1.5, MotionsList, MotionsNo, declare, not_carried, StartPlus8, WriteFileStream),
	%%%%%%%%%%% clock tick %%%%%%%%%%%	
	StartPlus9 is Start+9,
	%%%%%%%%%%% declare result %%%%%%%%%%%%%%%%%% 
	handleMsg(ChairsList, ChairsNo, 1.3, MotionsList, MotionsNo, declare, carried, StartPlus9, WriteFileStream).

% Agents from the SenderList send messages to agents from RecipientsList
% handleMsg(+SenderList, +SenderListLength, +SenderLimitPercentage, +RecipientList, +RecipientListLength, +MessageHeader, +MessageTopic,+MessageTime)
handleMsg(SenderList, SenderNo, SenderPercentage, RecipientList, RecipientNo, Header, Topic, Time, WriteFileStream) :-
	TempPercent is SenderNo*SenderPercentage,		
	random_subset(SenderList, SenderNo, TempPercent, [], SenderSubset),
	assertMsg(SenderSubset, RecipientList, RecipientNo, Header, Topic, Time, WriteFileStream).

% assert request_quote messages
% assertMsg(+SenderList, +RecipientList, +RecipientListLength, +MessageHeader, +MessageTopic,+MessageTime)
assertMsg([], _, _, _, _, _, _).
assertMsg([H|Tail], RecipientList, RecipientNo, MessageHeader, Topic, Time, WriteFileStream) :-
	Temp is random(RecipientNo),
	nth0(Temp, RecipientList, RandomRecipient),
	flatten([MessageHeader, H, RandomRecipient, Topic], FlatMsg),
	Message =.. FlatMsg,
	formatWrite(WriteFileStream, Message, Time), !,
	assertMsg(Tail, RecipientList, RecipientNo, MessageHeader, Topic, Time, WriteFileStream).

openFile(AgentNo,Seed,OpenFileStream):-
    atom_number(AgentNoAtom, AgentNo),
    atom_number(SeedAtom, Seed),
	atom_concat('../csv/voting-', AgentNoAtom, FName1),
	atom_concat(FName1, '-', FName2),
	atom_concat(FName2, SeedAtom, FName3),
	atom_concat(FName3, '.csv', FName),
	open(FName, write, OpenFileStream).

formatWrite(WriteFileStream, Message, Time):-
	Message =.. [EventName|ArgsList],
	append([EventName,Time,Time], ArgsList, WriteList),
	writeSep(WriteFileStream, WriteList).

writeSep(WriteFileStream, []):-
	write(WriteFileStream,'\n').

writeSep(WriteFileStream,[Last]):-
	write(WriteFileStream, Last),
	write(WriteFileStream, '\n').

writeSep(WriteFileStream, [H|T]):-
	write(WriteFileStream, H),
	write(WriteFileStream, '|'),
	writeSep(WriteFileStream, T).

