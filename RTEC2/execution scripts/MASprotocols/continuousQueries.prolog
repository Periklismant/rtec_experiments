
/**********************************************************************************

 Script for running RTEC.
 Authors: Alexander Artikis and Manos Pitsikalis.

 Run in YAP: yap -s 0 -h 0 -t 0 -l continuousQueries.prolog
 Run in SWI: swipl -L0 -G0 -T0 -l continuousQueries.prolog

 **********************************************************************************/


% load RTEC
:- ['../../src/RTEC.prolog'].

% The data loader reads CSV files of input datasets, 
% converts the data to the appropriate RTEC predicates, 
% and asserts these predicates for RTEC to process.
:- ['../../src/data loader/dataLoader.prolog'].

% handleApplication includes hard-coded execution parameters, such as 
% window and step sizes, for certain applications
:- ['handleApplicationMAS.prolog'].


%% THIS IS TEMPORARY
:- ['../../examples/feedback_loops/resources/auxiliary/static_info.prolog'].

% continuousQueries(+ApplicationName)

% eg: continuousQueries(netbillSmall).
% eg: continuousQueries(netbillSmallcsv).
% eg: continuousQueries(netbillBig).
% eg: continuousQueries(netbillBigDG).
% eg: continuousQueries(votingSmall).
% eg: continuousQueries(votingSmallcsv).
% eg: continuousQueries(votingBig).

% These work for swipl:
traceNetbill:- leash(-all), visible(+all), protocol('trace.txt'), trace.
traceNaive:- leash(-all), visible(+all), protocol('traceNaive.txt'), trace.
%

testNetbill:- continuousQueries(netbillBigDGcsv, 40, 10, 1000, 1, 1, 0).
testVoting:- continuousQueries(votingBigDGcsv, 20, 10, 50, 5, 1, 0).
testBrest(Window):- continuousQueries(brestCritical, Window, 7200, 0, 0, 1, 0).
%testComparison:- continuousQueries(votingComparison,100,100,1000,1, 0).
testNaive:- continuousQueries(netbillnaivecsv, 200, 10, 1000, 1, 1, 0).
testVotingNaive:- continuousQueries(votingNaivecsv, 80, 10, 50, 5, 1, 0).

testIMIS:- continuousQueries(europeIMISCritical, 7200, 7200, 0, 0, 0, 0).

testBrestND(Window):- continuousQueries(brestCriticalNoDeadlines, Window, 7200, 0, 0, 0, 0).

testBrestDeadlines(Window):- continuousQueries(brestDeadlines, Window, 7200, 0, 0, 1, 0).

testIMISDeadlines(Window):- continuousQueries(europeIMISDeadlines, Window, 7200, 0, 0, 1, 0).

runNetbill(Window, Step, Agents):-
	continuousQueries(netbillBigDGcsv, Window, Step, Agents, 1, 1, 0).

runNetbillDelays(Window, Step, Agents, Delay):-
	continuousQueries(netbillDelays, Window, Step, Agents, 1, 1, Delay).

runBrestDelays(Window, Step, Delay):-
	continuousQueries(brestDelays, Window, Step, 0, 0, 1, Delay).

test(Window, Deadlines):- continuousQueries(netbillDeadlinesTest, Window, 10, 4000, 1, Deadlines, 0).

testN(Window, Deadlines):- continuousQueries(netbillnaiveDeadlinesTest, Window, 10, 4000, 1, Deadlines, 0).

testV(Window, Deadlines):- continuousQueries(votingDeadlinesTest, Window, 10, 4000, 1, Deadlines, 0).

testVN(Window, Deadlines):- continuousQueries(votingnaiveDeadlinesTest, Window, 10, 4000, 1, Deadlines, 0).

fdl(Window, Step, EndReasoningTime):- continuousQueries(fdl, Window, Step, EndReasoningTime, 0, 0, 0). %%Passing EndReasoningTime through "Agents" argument.

phageG(Window, Step, EndReasoningTime, Vals):- continuousQueries(phage_g, Window, Step, EndReasoningTime, Vals, 0, 0). 

immuneG(Window, Step, EndReasoningTime, Vals):- continuousQueries(immune_g, Window, Step, EndReasoningTime, Vals, 0, 0). 

fdl30:- fdl(30,30,30).

fdlP10:- phageG(10,10,10).

fdl30win:- fdl(10,10,30).

testQuote(Agents) :- continuousQueries(netbillQuote, 100, 100, Agents, 1, 0, 0).

testToyDeadlines :- continuousQueries(toydeadlinescsv, 10, 10, 1, 1, 0, 0).

testToyDeadlinesBatch :- continuousQueries(toydeadlinescsv, 40, 40, 1, 1, 0, 0).


continuousQueries(App, WM, Step, AgentNo, Seed, DeadlinesFactor, Delay) :-
	% load RTEC according to the requested Prolog compiler
	% also return the correct statistics flag ('cputime' for YAP or 'runtime' for SWI)	
	% handleProlog(-Prolog, -StatisticsFlag)
	%open('./error.txt', write, ErrStream), 
	%yap_flag(user_error, ErrStream),
	handleProlog(Prolog, StatisticsFlag),
	writeln('Starting...'),
	% load the requested event description, declarations, data; 
	% return the parameters of the application: WM, Step; 
	% continuous queries take place in (StartReasoningTime, EndReasoningTime]
	% StreamOrderFlag (ordered or unordered), 
	% DynamicGroundingFlag (dynamicgrounding or nodynamicgrounding),
	% PreprocessingFlag (preprocessing or nopreprocessing), 
	% ClockTick: temporal distance between two consecutive time-points
	% SDEBatch: the input narrative size asserted in a single batch
	% handleApplication(+Prolog, +App, -InputMode, -LogFile, -ResultsFile, -WM, -Step, -DeadlinesFactor, -Delay, -StartReasoningTime, -EndReasoningTime, -StreamOrderFlag, -DynamicGroundingFlag, -PreprocessingFlag, -ForgetThreshold, -DynamicGroundingThreshold, -ClockTick, -SDEBatch),
	handleApplication(App, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch),
	% openFiles(+datasetfiles, -datasetstreams, -datasetpointerpositions, +logfile, -logfilestream, +resultsfile, -resultsfilestream)
		format("                                                                 
	8 888888888o. 8888888 8888888888 8 8888888888       ,o888888o.    
	8 8888    `88.      8 8888       8 8888            8888     `88.  
	8 8888     `88      8 8888       8 8888         ,8 8888       `8. 
	8 8888     ,88      8 8888       8 8888         88 8888           
	8 8888.   ,88'      8 8888       8 888888888888 88 8888           
	8 888888888P'       8 8888       8 8888         88 8888           
	8 8888`8b           8 8888       8 8888         88 8888           
	8 8888 `8b.         8 8888       8 8888         `8 8888       .8' 
	8 8888   `8b.       8 8888       8 8888            8888     ,88'  
	8 8888     `88.     8 8888       8 888888888888     `8888888P'   
	"), nl,
	openFiles(InputMode, InputStreams, PointerPositions, LogFile, LogFileStream, ResultsFile, ResultsFileStream), 
	% initialise RTEC
	% initialiseRecognition(+StreamOrderFlag, +DynamicGroundingFlag, +PreprocessingFlag, +ForgetThreshold, +DynamicGroundingThreshold, +ClockTick),	
	initialiseRecognition(StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick),
	% init time counters
	initGlobals,
	% set the temporal deadlines of each fluent.
	write(DeadlinesFactor), nl,
	(DeadlinesFactor>0 -> initDeadlines(DeadlinesFactor) ; nl),
	QueryTime is StartReasoningTime+WM,
	% querying(+InputStreams, +PointerPositions, +StatisticsFlag, +LogFileStream, +WM, +Step, +QueryTime, +EndReasoningTime, +[], -RecTimes, +[], -InputList, +([],[],[]), (-OutputListOutFVpairs,-OutputListOutLI,-OutputListOutLD), +SDEBatch)
	querying(InputStreams, PointerPositions, StatisticsFlag, LogFileStream, ResultsFileStream, WM, Step, QueryTime, EndReasoningTime, [], RecTimes, [], InputList, ([],[],[]), (OutputListOutFVpairs,OutputListOutLI,OutputListOutLD), SDEBatch),
	% calculate and record the recognition time statistics
	list_stats(RecTimes,_,_,AvgTime,_,DevTime),
	nl(LogFileStream), nl(LogFileStream),
	write(LogFileStream, 'Recognition Time average (ms)		: '), 
	write(LogFileStream, AvgTime), nl(LogFileStream),
	write(LogFileStream, 'Recognition Time standard deviation (ms): '), 
	write(LogFileStream, DevTime), nl(LogFileStream),
	write('Recognition Time average (ms)			: '), 
	writeln(AvgTime),
	% calculate and record the max query time
	max_list(RecTimes, Max),
	write(LogFileStream, 'Recognition Time worst (ms)		: '), 
	write(LogFileStream, Max), nl(LogFileStream), nl(LogFileStream),
	% calculate and record the average number of input entities per window
	list_stats(InputList,_,_,AvgSDEs,_,DevSDEs),
	write(LogFileStream, 'Input Entities average			: '), 
	write(LogFileStream, AvgSDEs), nl(LogFileStream),
	write(LogFileStream, 'Input Entities standard deviation	: '), 
	write(LogFileStream, DevSDEs), nl(LogFileStream), nl(LogFileStream),
	write('Input Entities average				: '), 
	writeln(AvgSDEs),
	% calculate and record the average and standard deviation of output entity fluent-value pairs per window
	list_stats(OutputListOutFVpairs,_,_,AvgOutFVpairs,_,DevOutFVpairs),
	write(LogFileStream, 'Output Entities (average number of fluent-value pairs)	: '), 
	write(LogFileStream, AvgOutFVpairs), nl(LogFileStream),
	write(LogFileStream, 'Output Entities (standard deviation)	  		: '), 
	write(LogFileStream, DevOutFVpairs), nl(LogFileStream),
	write('Output Entities (average # fluent-value pairs)	: '), writeln(AvgOutFVpairs),
	% calculate and record the average and standard deviation of output entity intervals per window
	list_stats(OutputListOutLI,_,_,AvgOutL,_,DevOutL),
	write(LogFileStream, 'Output Entities (average number of intervals)	: '), 
	write(LogFileStream, AvgOutL), nl(LogFileStream),
	write(LogFileStream, 'Output Entities (standard deviation)	  	: '), 
	write(LogFileStream, DevOutL), nl(LogFileStream),
	write('Output Entities (average # intervals)		: '), 
	writeln(AvgOutL),
	% calculate and record the average and standard deviation of output entity duration per window
	list_stats(OutputListOutLD,_,_,AvgOutLD,_,DevOutLD),
	write(LogFileStream, 'Output Entities (average number of timepoints)	: '), 
	write(LogFileStream, AvgOutLD),nl(LogFileStream),
	write(LogFileStream, 'Output Entities (standard deviation)	 	: '), 
	write(LogFileStream, DevOutLD),nl(LogFileStream),
	write('Output Entities (average # timepoints)		: '), 
	writeln(AvgOutLD),
	writeln('========================================================='),
	%nl(LogFileStream),
	writeAllGlobals(LogFileStream),
	closeFiles(InputStreams, LogFileStream, ResultsFileStream), !.

% continuous queries should stop when the previous query time is greater or equal to the designated last reasoning time 
querying(_InputStreams, _InputPointerPositions, _StatisticsFlag, _LogFileStream, _ResultsFileStream, _WM, Step, QueryTime, EndReasoningTime, RecTimes, RecTimes, InputList, InputList, OutputList, OutputList, _SDEBatch) :-
	PrevQueryTime is QueryTime-Step,
 	PrevQueryTime >= EndReasoningTime, !.

querying(InputStreams, InputPointerPositions, StatisticsFlag, LogFileStream, ResultsFileStream, WM, Step, QueryTime, EndReasoningTime, InitRecTime, RecTimes, InitInput, InputList, (InitOutputOutFVpairs,InitOutputOutLI,InitOutputOutLD), OutputList, SDEBatch) :-
 	QueryTimeMinusWM is QueryTime-WM,
	% VerifiedQueryTime=QueryTime when QueryTime =< EndReasoningTime
	% otherwise: VerifiedQueryTime=EndReasoningTime 
	verifyQueryTime(QueryTime, EndReasoningTime, VerifiedQueryTime),
	% load input data in (QueryTimeMinusWM, VerifiedQueryTime]
	loadNarrative(InputStreams, QueryTimeMinusWM, VerifiedQueryTime, InputPointerPositions, NewInputPointerPositions, SDEBatch),
 	write('Current Window                         	: ('), 
	write(QueryTimeMinusWM), write(', '), write(VerifiedQueryTime), writeln(']'),
	%%%%%%%%% compute the recognition time of the current window
	getCPUtime(S1,always),
	% eventRecognition(+QueryTime, +WM)
	% Note: the first argument of eventRecognition below remains QueryTime and not VerifiedQueryTime.
	% This way, we do not change the start time of event recognition.
	% When QueryTime =< EndReasoningTime then event recognition takes place in (QueryTime-WM,QueryTime]
	% Otherwise, event recognition takes place effectively in (QueryTime-WM,EndReasoningTime]
	% because no input data are loader after EndReasoningTime
	eventRecognition(QueryTime, WM),
	getCPUtime(S2,always),
	getCPUtime(FAT1),
	findall((F=V,L), (outputEntity(F=V),holdsFor(F=V,L),L\=[]), OELI),
	findall((EE,TT), (outputEntity(EE),happensAt(EE,TT)), OELT),
	getCPUtime(FAT2),
	updateTime(user_time,FAT1,FAT2),
	length(OELI, OELILen), updateVariable(holdsForOE, OELILen),
	length(OELT, OELTLen), updateVariable(happensAtOE, OELTLen),
	% count the open intervals of holdsFor and update global variable 
	countOpen(OELI, 0, _NumberOfOpenIntervals),
	% log the computed intervals of output entities
	printRecognitions(ResultsFileStream, QueryTime, WM),
	% Remove all intervals before QueryTimeMinusWM?
	%removeOutdated(QueryTime, WM),
	%%%%%%%%% compute the recognition time of the current window
 	S is S2-S1, %S=T2,
 	writeResult(S, LogFileStream),
 	write('Recognition Time (ms)			: '), writeln(S),
 	% calculate and record the number of input entities
 	findall((Ev,EvT), (inputEntity(Ev),happensAtIE(Ev,EvT)), EvList), length(EvList,InL1),
 	findall((InF,InFT), (inputEntity(InF),holdsAtIE(InF,InFT)), InFList), length(InFList,InL2),
 	InL is InL1+InL2,
 	write('Input Entities				: '), writeln(InL),
 	% compute and record output entity statistics
 	findall(Interval, (outputEntity(F=V),holdsFor(F=V,L),member(Interval,L)), AllIntervals),
 	temporalDistance(TemporalDistance),
 	% fluents_duration(+OELI, +TemporalDistance, +QueryTimeMinusWM, +VerifiedQueryTime, -OELID)
 	fluents_duration(OELI, TemporalDistance, QueryTimeMinusWM, VerifiedQueryTime, OELID),
 	length(OELI, OutFVpairs),
 	length(OELT,OELTL),
 	length(AllIntervals,AllIntervalsL),
 	OutLI is AllIntervalsL+OELTL,
 	OutLD is OELID+OELTL,
 	write('Output Entities (# fluent-value pairs)	: '), writeln(OutFVpairs),
	write('Output Entities (# intervals)		: '), writeln(OutLI),
	write('Output Entities (# timepoints)		: '), writeln(OutLD),
	writeln('========================================================='),
	% move to the next query-time
	NextQueryTime is QueryTime+Step, !, %% This cut is necessary to prevent the local stack from exploding.
	%printLocalStackInfo,
	querying(InputStreams, NewInputPointerPositions, StatisticsFlag, LogFileStream, ResultsFileStream, WM, Step, NextQueryTime, EndReasoningTime, [S|InitRecTime], RecTimes, [InL|InitInput], InputList, ([OutFVpairs|InitOutputOutFVpairs],[OutLI|InitOutputOutLI],[OutLD|InitOutputOutLD]), OutputList, SDEBatch).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Utils
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lookForOpenIntervals([], Count, Count).

lookForOpenIntervals([(_, inf)|_RestIntervals], Count, NewCount):-
	NewCount is Count + 1, !.

lookForOpenIntervals([_Interval|RestIntervals], Count, NewCount):-
	%write(Interval), nl,
	lookForOpenIntervals(RestIntervals, Count, NewCount).

countOpen([], NumberOfOpenIntervals, NumberOfOpenIntervals):-
	%write(NumberOfOpenIntervals), nl,
	updateVariable(open_intervals, NumberOfOpenIntervals).

countOpen([(_, L)|RestFluentsIntervals], Count, NumberOfOpenIntervals):-
	%write(L), nl,
	lookForOpenIntervals(L, Count, NewCount),
	countOpen(RestFluentsIntervals, NewCount, NumberOfOpenIntervals).

checkOpen([]).

checkOpen([(_S, inf)|_RestIntervals]):- !, fail.

checkOpen([_Interval|RestIntervals]):-
	checkOpen(RestIntervals).

% openFiles(+datasetfiles, -datasetstreams, -datasetpointerpositions, +logfile, -logfilestream, +resultsfile, -resultsfilestream)
openFiles(InputMode, InputStreams, PointerPositions, LogFile, LogFileStream, ResultsFile, ResultsFileStream) :-
	open(LogFile, write, LogFileStream),
	open(ResultsFile, write, ResultsFileStream),
	(
		% the dataset is in csv file(s)
		InputMode = csv(InputFiles),
		openInputCSVFiles(InputFiles, InputStreams, PointerPositions)
		;
		% the dataset is in the form of Prolog assertions
		InputMode = dynamic_predicates(InputFiles),
		InputStreams = [], 		
		consultInputFiles(InputFiles)
	).
	
% openInputCSVFiles(+InputFiles, -InputStreams, -PointerPositions)
openInputCSVFiles([], [], []) :- !.
openInputCSVFiles([File|MoreFiles], [Stream|MoreStreams], [Position|MorePositions]) :-
	open(File, read, Stream),
	stream_property(Stream, position(Position)),
	openInputCSVFiles(MoreFiles, MoreStreams, MorePositions).

% consultInputFiles(+InputFiles)
% the InputFiles are Prolog assertions expressing an input narrative
consultInputFiles([]) :- !.
consultInputFiles([File|MoreFiles]) :-
	consult(File),
	consultInputFiles(MoreFiles).


% closeFiles(+datasetfilesstreams, +logfilestream, +resultsfilestream)
% first case: there are no input streams, 
% ie the dataset is in the form of Prolog assertions
closeFiles(InputStreams, LogFileStream, ResultsFileStream) :-
	close(LogFileStream),
	close(ResultsFileStream),
	InputStreams = [], !.	
% second case: the dataset is in csv files;
% in this case close each input stream;
% note: the log file stream is closed in the 
% above closeFiles/2 clause
closeFiles(InputStreams, _LogFileStream, _ResultsFileStream) :-
	closeInputFiles(InputStreams).

% closeInputFiles(+InputStreams)	
closeInputFiles([]) :- !.
closeInputFiles([InputStream|MoreInputStreams]) :-
	close(InputStream),
	closeInputFiles(MoreInputStreams).


% write(+RecognitionTime, +LogFile)
writeResult(Time, LogFileStream):-
  	write(LogFileStream,'+'),
	write(LogFileStream,Time).


%Input   :  List L of numbers
%returns :  Length of L (Len)
%           Sum of L (Sum) 
%           Mean (Avg), Variance (Var) and Standard Deviations of L elements
list_stats(L,Len,Sum,Avg,Var,Dev):-
	sum_list(L,Sum),
	length(L,Len),
	Avg is Sum/Len,
	list_var(L,Avg,Var1),
	Var is Var1/Len,
	Dev is sqrt(Var).

%Input   :  List L and List Mean (Avg)
%Returns :  X where X = Variance of L * Length of L
list_var([],_,0).
list_var([El|Other],Avg,Var):-
	list_var(Other,Avg,VarIn),
	Var is (VarIn + ((El-Avg)*(El-Avg))).

%Input   :  List L of pairs (F=V,I)
%           TemporalDistance of timepoints,
%           S,E where S and E are the values of the intersection interval (S,E)
%Returns :  Total Duration of intervals
fluents_duration([],_,_,_,0).
fluents_duration([(_=_,Li)|OtherFluents],TemporalDistance,S,E,Duration):-
	fluents_duration(OtherFluents,TemporalDistance,S,E,DurationIn),
	intersect_all([Li,[(S,E)]],L),
	interval_list_duration(L,CurDur),
	CurrentDuration is CurDur/TemporalDistance,
	Duration is DurationIn + CurrentDuration.

%Input   : Interval List
%Returns : Duration of intervals without taking into consideration TemporalDistance
interval_list_duration([],0).
interval_list_duration([(S,E)|L],T) :- 
	interval_list_duration(L,S1),
	D is E-S,
	T is S1+D.


% verifyQueryTime(+QueryTime, +EndReasoningTime, -VerifiedQueryTime)
% A given QueryTime is OK as long as it is less or equal to the designated last reasoning time; 
% otherwise, it is set to the designated last reasoning time
verifyQueryTime(QueryTime, EndReasoningTime, QueryTime) :-
	QueryTime =< EndReasoningTime, !.
verifyQueryTime(QueryTime, EndReasoningTime, EndReasoningTime) :-
 	write('***Attention***: QueryTime adjusted from '), write(QueryTime), 
	write(' to '), write(EndReasoningTime),
	writeln(' but QueryTime-WM remains the same.').


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assert narrative (SDEs)
%%%%%%%%%%%%%%%%%%%%%%%%%%

% loadNarrative(+InputStreams, +Start, +End, +PointerPositions, -NewPointerPositions, +SDEBatch)
loadNarrative(InputStreams, Start, End, PointerPositions, NewPointerPositions, SDEBatch) :-
	(
		% use the csv data loader
		\+ InputStreams = [],
		loadIEStreams(InputStreams, Start, End, PointerPositions, NewPointerPositions)
		;
		% do NOT use the csv data loader 
		InputStreams = [],
		updateManySDE(Start, End, SDEBatch)
	).


% updateManySDE(+Start, +End, +SDEBatch)

% assert SDE from +Start to +End using batches of +SDEBatch size
% updateSDE, as opposed to updateManySDE, is defined in an application-specific manner

updateManySDE(Start, End, SDEBatch) :-
	Diff is End-Start,
	Diff =< SDEBatch,
	%!,
	updateSDE(Start, End), !.	

updateManySDE(Start, End, SDEBatch) :-
	Diff is End-Start,
	Diff > SDEBatch,
	NewStart is Start+SDEBatch,
	updateSDE(Start, NewStart), !,
	updateManySDE(NewStart, End, SDEBatch).

updateManySDE(_, _, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Log the recognised intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% printRecognitions(+CEIntervalsStream, +CurrentTime, +WM)
printRecognitions(CEIntervalsStream, CurrentTime, WM) :-
	%%% new code %%% 
	StartTime is CurrentTime-WM,
	StartTimePlusOne is StartTime + 1,
	CurrentTimePlusOne is CurrentTime + 1,
	%%% new code end %%%
	findall((F=V,L2), 
		(
		outputEntity(F=V),
                holdsFor(F=V,L),
                L\==[],
                intersect_all([L,[(StartTimePlusOne,CurrentTimePlusOne)]],L2) %% changed
                ), 
              CEIntervals),
	writeCEs(CEIntervalsStream, CEIntervals).

writeCEs(ResultStream, []) :-
	%write(ResultStream, 'batchEnd'),
	nl(ResultStream), !.
writeCEs(ResultStream, [(_CE,[])|OtherCCs]) :-
	writeCEs(ResultStream,OtherCCs).
writeCEs(ResultStream,[(F=V,L)|OtherCCs]) :-
	(
		\+ datasetType(ground_truth),
		DType = 'predictions'
		;
		% in some cases the ground truth is computed by RTEC;
		% eg in the maritime application, we consider as ground truth the recognition on the raw dataset
		datasetType(ground_truth),
		DType = 'ground_truth'
	),
	L \= [],
   	F =.. [FluentName|Args],
    	write(ResultStream,'recognitions('),
    	write(ResultStream,DType),
    	write(ResultStream,','),
    	write(ResultStream,FluentName),
    	write(ResultStream,','),
   	write(ResultStream,[Args,V]),
    	write(ResultStream,','),
    	write(ResultStream,L),
    	write(ResultStream,').'),
    	nl(ResultStream),
    	writeCEs(ResultStream,OtherCCs).

