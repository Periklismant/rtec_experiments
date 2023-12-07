
/*

==============

The ground truth file is denoted by 'ground_truth', and the other file is denoted by 'predictions'.

Format of input files:

recognitions(predictions/ground_truth,fluentName,[[arg1,...argN],value],[(ts1,te1),...,(tsN,teN)]).

which corresponds to:

holdsFor(fluentName(arg1,...argN)=value, [(ts1,te1),...,(tsN,teN)]).

==============

This script assumes that there are no open intervals (continuousQueries.prolog intersects the produced intervals with the current window). This script computes the union of all intervals before performing the comparison for the computation of the F1-score.

==============

Note: for big files (eg IMIS) this script may take a lot of time (eg more than 1 hour).

*/

:-use_module(library(system)).

:-['../src/utilities/interval-manipulation.prolog'].
:-use_module(library(lists)).


%compares the intervals of the loaded files
%compare_all_events
compare_all_events(GroundTruthFile,PredictionsFile,ResultFilename) :-
    write('Start!'), nl,
    %unix(argv([])),
    consult(GroundTruthFile),
    write('Ground Consulted!'), nl,
    consult(PredictionsFile),
    write('Predictions Consulted!'), nl,
    open(ResultFilename, write, ResultStream),
    writeElementsSeparated(ResultStream,['Event','TP','FP','FN','Precision','Recall','F-1'],','),
    nl(ResultStream),
    find_event_names(Events),
    write('Found all events.'),nl,
    compare_events(Events,Results,ResultStream),
    compute_overall_metrics(Results, ResultStream),
    close(ResultStream),
    write('Finished.').

compute_overall_metrics(Results, ResultStream):-
    find_statistics(Results, (0,0,0), (TPSum, FPSum, FNSum)),
    write(TPSum), nl,
    TPs is TPSum, FPs is FPSum, FNs is FNSum, 
    Pr is TPs/(TPs+FPs),Re is TPs/(TPs+FNs),F1 is 2*Pr*Re/(Pr+Re),
    writeElementsSeparated(ResultStream,['Overall',TPs,FPs,FNs,Pr,Re,F1],','),
    nl(ResultStream).


find_statistics([], X, X).

find_statistics([(_, (TP, FP, FN))|Rest], (CurrTP, CurrFP, CurrFN), FinalMetrics):-
    NewTP = TP+CurrTP, NewFP = FP+CurrFP, NewFN = FN+CurrFN,
    find_statistics(Rest, (NewTP, NewFP, NewFN), FinalMetrics).

%finds the name (E) of all the output entities 
%e.g., trawling(Vessel)=true -> E=trawling
find_event_names(Events):-setof(E,D^V^T^recognitions(D,E,V,T),Events).

%compares all output entities
%step 1: find all distinct instances of a fluent and compare them
%step 2: compute Precision, Recall, F1
%step 3: write results
%step 4: continue for remaining fluents/output entities
%compare_events(+EventNameList,-[(EventName,(TP,FP,FN))|...],+ResultStream).
compare_events([],[],_).
compare_events([Event|OtherEvents],[(Event,(M1,M2,M3))|Other],ResultStream):-
    write('Comparing event: '),write(Event),nl,
    compare_all_args_of_event(Event,Results),
    triplesumlist(Results,(M1,M2,M3)),
    Pr is M1/(M1+M2),Re is M1/(M1+M3),F1 is 2*Pr*Re/(Pr+Re),
    writeElementsSeparated(ResultStream,[Event,M1,M2,M3,Pr,Re,F1],','),
    nl(ResultStream),
    compare_events(OtherEvents,Other,ResultStream).

%find all the instance of a fluent (Arguments)
%compare the intervals of each instance between the two datasets
%compare_all_args_of_event(+EventInstance,-TPFPFNperInstance)
compare_all_args_of_event(Event,L):-
    find_args_of_event(Event,Args),
    compare_args(Args,Event,L).

%find the all the arguments (including fluent value) in the
%the output entities of the first argument `Event'
%e.g.,trawling(Vessel)=Value -> V=[[Vessel],Value]
%find_args_of_event(Event,Args)
find_args_of_event(Event,Args):-setof(V,D^T^Event^recognitions(D,Event,V,T),Args).

%find compare the output intervals for an instance of a fluent
%using the 'ground_truth' and the 'predictions' dataset
%step 1: find all the intervals from the predictions dataset
%step 2: find all the intervals from the ground_truth dataset
%step 3: perform union for the intervals of the predictions dataset
%step 4: perform union for the intervals of the ground_truth dataset
%step 5: compare the interval lists
%compare_args(+ListOfArguments,+FluentName,-[(TP,FP,FN)|...]):-
compare_args([],_,[]).
compare_args([Args|OtherArgs],Event,[Comp|OtherComp]):-
    findall(Icri, recognitions(predictions,Event,Args,Icri),Icr),
    findall(Irawi, recognitions(ground_truth,Event,Args,Irawi),Iraw),
    union_all(Icr,I1),
    union_all(Iraw,I2),
    compare_intervals(I1,I2,Comp),
    compare_args(OtherArgs,Event,OtherComp).

%Compare two lists of intervals A,B
%compare_intervals(+A,+B,-(Common,OnlyA,OnlyB))
compare_intervals(A,B,(Common,OnlyA,OnlyB)):-
    intersect_all([A,B],Intersected),
    find_total(Intersected,Common),
    relative_complement_all(A,[B],OnlyAIntervals),
    find_total(OnlyAIntervals,OnlyA),
    relative_complement_all(B,[A],OnlyBIntervals),
    find_total(OnlyBIntervals,OnlyB).

%find the total duration of the intervals included in the list L
%find_total(+L,-D)
find_total([],0).
find_total([(S,E)|L],T):-find_total(L,S1),D is E-S,T is S1+D.

%perform mutliwise addition for 3d tuples
%triplesum(+A,+B,-C)
triplesum((A1,B1,C1),(A2,B2,C2),(A3,B3,C3)):-A3 is A1 + A2, B3 is B1 + B2, C3 is C1 + C2.

%perform mutliwise addition for all the 3d tuples in the list L
%triplesumlist(+L,+R).
triplesumlist([],(0,0,0)).
triplesumlist([A|B],Sum):-
    triplesumlist(B,SumO),triplesum(SumO,A,Sum).

%Find the mean of all the 3d tuples in the list L
%triplemean(+L,-M)
triplemean(L,(M1,M2,M3)):-triplesumlist(L,(S1,S2,S3)),length(L,Size),M1 is round(S1/Size),M2 is round(S2/Size),M3 is round(S3/Size).



writeElementsSeparated(_,[],_C).
writeElementsSeparated(ResultStream,[E],_C):-
    write(ResultStream,E).
writeElementsSeparated(ResultStream,[E|L],C):-
    write(ResultStream,E),
    write(ResultStream,C),
    writeElementsSeparated(ResultStream,L,C).


/*

The part below idoes not concern the comparison.

*/


%------------ Print to csv format code -------

create_csvs:-
    find_event_names(Events),
    create_streams(Events,Streams),
    write('Created files.'),nl,
    print_to_csvs(Streams),
    write('Closing files.'),nl,
    close_streams(Streams).

create_streams([],[]).
create_streams([EventName|Other],[(EventName,StreamC,StreamR)|OtherS]):-
    atom_concat('res_predictions_',EventName,STR1),
    atom_concat(STR1,'.csv',STRC),
    atom_concat('res_ground_truth_',EventName,STR2),
    atom_concat(STR2,'.csv',STRR),
    open(STRC,write,StreamC),
    open(STRR,write,StreamR),
    create_streams(Other,OtherS).

print_to_csvs([]).
print_to_csvs([(EventName,StreamC,StreamR)|OtherS]):-
    find_args_of_event(EventName,Args),
    write('Printing event :'),write(EventName),write('.'),nl,
    print_all(EventName,Args,StreamC,StreamR),
    print_to_csvs(OtherS).

print_all(_,[],_,_).
print_all(Event,[ArgsValue|OtherArgsValues],StreamC,StreamR):-
    findall(Icri, recognitions(predictions,Event,ArgsValue,Icri),Icr),
    findall(Irawi, recognitions(ground_truth,Event,ArgsValue,Irawi),Iraw),
    union_all(Icr,I1),
    union_all(Iraw,I2), % Iground before, but both Iraw and Iground were singleton
    [Args,Value]=ArgsValue,
    csv_print(Event,Args,Value,I1,StreamC),
    csv_print(Event,Args,Value,I2,StreamR),
    print_all(Event,OtherArgsValues,StreamC,StreamR).

csv_print(_Event,_Args,_Value,[],_Stream).
csv_print(Event,Args,Value,[(S,E)|Other],Stream):-
    write(Stream,Event),
    write(Stream,'|'),
    writeElementsSeparated(Stream,Args,'|'),
    write(Stream,'|'),
    writeElementsSeparated(Stream,[Value,S,E],'|'),
    nl(Stream),
    csv_print(Event,Args,Value,Other,Stream).

close_streams([]).
close_streams([(_EventName,StreamC,StreamR)|OtherS]):-
    close(StreamC),
    close(StreamR),
    close_streams(OtherS).


