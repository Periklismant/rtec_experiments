:- discontiguous getEvents/6.

% The file below is necessary for computing statistics by the predicates of this file
:- ['globals.prolog'].

performFullER(IEFileName, TimesFilename, ResultFilename, InitPoint, WM, Step, LastTime) :-
  % Initialization
  nb_getval(sts,STS),
  nb_getval(prl,PRL),  handleProlog(PRL, StatisticsFlag),
  stats_init(STS,TimesFilename,ResultFilename),
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
  "),
  nb_getval(times_stream,LogFileS),
  initialiseRecognition(ordered,dynamicgrounding, nopreprocessing, 1),
  InitWin is InitPoint + WM,
  openInputFiles(IEFileName,IEStreams,IEPositions),
  getEvents(IEFileName,IEStreams,InitPoint,InitWin,IEPositions,IEPositions1),
  InitWinPlus1 is InitWin+1, 
  InitTime is InitWin-InitWinPlus1,
  nl, write('Current Window				: (-1, '), write(InitWin), writeln(']'), 
  statistics(StatisticsFlag, [S1,_T1]),
  eventRecognition(InitWin,InitWinPlus1),
  findall((F=V,L), (outputEntity(F=V),holdsFor(F=V,L),L\=[]), OELI), 
  findall((EE,TT), (outputEntity(EE),happensAt(EE,TT)), OELT),
  statistics(StatisticsFlag,[S2,_T2]), 
  S is S2-S1, %S=T2,
  write(LogFileS, S),
  write('Recognition Time (ms)			: '), writeln(S),
  % calculate and record the number of input entities
  findall((Ev,EvT), (inputEntity(Ev),happensAtIE(Ev,EvT)), EvList), length(EvList,InL1),
  findall((InF,InFT), (inputEntity(InF),holdsAtIE(InF,InFT)), InFList), length(InFList,InL2),
  findall(Interval, (inputEntity(F=V),holdsForProcessedIE(F=V,L),member(Interval,L)), InputIntervals), 
  temporalDistance(TemporalDistance),
  fluents_duration(InputIntervals, TemporalDistance, InitPoint, InitWin, InL3),
  InL is InL1+InL2+InL3,
  write('Input Entities				: '), writeln(InL), 
  % compute and record output entity statistics
  findall(Interval, (outputEntity(F=V),holdsFor(F=V,L),member(Interval,L)), AllIntervals),  
  fluents_duration(OELI, TemporalDistance, InitPoint, InitWin, OELID),
  length(OELI, OutFVpairs),
  length(OELT, OELTL),
  length(AllIntervals, AllIntervalsL),
  OutLI is AllIntervalsL+OELTL,
  OutLD is OELID+OELTL,
  write('Output Entities (# fluent-value pairs)	: '),writeln(OutFVpairs),
  write('Output Entities (# intervals)		: '),writeln(OutLI),
  write('Output Entities (# timepoints)		: '),writeln(OutLD),
  writeln('========================================================='),
  print_CEs(_CC,_ListofTimePoints,InitWin,InitWinPlus1),
  
  % Continue
  CurrentTime is InitWin+Step,
  getEvents(IEFileName,IEStreams,InitWin,CurrentTime,IEPositions1,NewPositions),
  querying(IEFileName,IEStreams, NewPositions, WM, Step, CurrentTime, LastTime, [S], RecTimes, [InL], InputList, ([OutFVpairs],[OutLI],[OutLD]), (OutputListOutFVpairs,OutputListOutLI,OutputListOutLD)),

  
  % calculate and record the recognition time statistics
  list_stats(RecTimes,_,_,AvgTime,_,DevTime),
  nl(LogFileS), nl(LogFileS),
  write(LogFileS, 'Recognition Time average (ms)		: '), write(LogFileS, AvgTime), nl(LogFileS),
  write(LogFileS, 'Recognition Time standard deviation (ms): '), write(LogFileS, DevTime), nl(LogFileS),
  write('Recognition Time average (ms)			: '), writeln(AvgTime),
  % calculate and record the max query time
  max_list(RecTimes, Max),
  write(LogFileS, 'Recognition Time worst (ms)		: '), write(LogFileS, Max), nl(LogFileS), nl(LogFileS),
  % calculate and record the average number of input entities per window
  list_stats(InputList,_,_,AvgSDEs,_,DevSDEs),
  write(LogFileS, 'Input Entities average			: '), write(LogFileS, AvgSDEs), nl(LogFileS),
  write(LogFileS, 'Input Entities standard deviation	: '), write(LogFileS, DevSDEs), nl(LogFileS), nl(LogFileS),
  write('Input Entities average				: '), writeln(AvgSDEs),
  % calculate and record the average and standard deviation of output entity fluent-value pairs per window
  list_stats(OutputListOutFVpairs,_,_,AvgOutFVpairs,_,DevOutFVpairs),
  write(LogFileS, 'Output Entities (average number of fluent-value pairs)	: '), write(LogFileS, AvgOutFVpairs), nl(LogFileS),
  write(LogFileS, 'Output Entities (standard deviation)	  		: '), write(LogFileS, DevOutFVpairs), nl(LogFileS),
  write('Output Entities (average # fluent-value pairs)	: '), writeln(AvgOutFVpairs),
  % calculate and record the average and standard deviation of output entity intervals per window
  list_stats(OutputListOutLI,_,_,AvgOutL,_,DevOutL),
  write(LogFileS, 'Output Entities (average number of intervals)	: '), write(LogFileS, AvgOutL), nl(LogFileS),
  write(LogFileS, 'Output Entities (standard deviation)	  	: '), write(LogFileS, DevOutL), nl(LogFileS),
  write('Output Entities (average # intervals)		: '), writeln(AvgOutL),
  % calculate and record the average and standard deviation of output entity duration per window
  list_stats(OutputListOutLD,_,_,AvgOutLD,_,DevOutLD),
  write(LogFileS, 'Output Entities (average number of timepoints)	: '), write(LogFileS, AvgOutLD),nl(LogFileS),
  write(LogFileS, 'Output Entities (standard deviation)	 	: '), write(LogFileS, DevOutLD),nl(LogFileS),
  write('Output Entities (average # timepoints)		: '), writeln(AvgOutLD),
  writeln('========================================================='),
  %writeln(LogFileS),
  % Close/Clean-up
  writeln('ER done. Closing/Cleaning up...'),
  stats_end(STS),
  closeInputFiles(IEStreams),!.

writeFStats([],_).
writeFStats([(Name,Avg,Dec)|Others],LogFileS):-
  write(LogFileS, 'Fluent '),write(LogFileS,Name),write(LogFileS,' Avg / Stdev		: '), write(LogFileS, Avg), write(LogFileS, ' / '),write(LogFileS, Dec),nl(LogFileS),
  writeFStats(Others,LogFileS).
  

clDeadlinesFluentStats([],[],[]).
clDeadlinesFluentStats([[A1,A2]|R],[A2|R2],[A1|R1]):-
    clDeadlinesFluentStats(R,R2,R1).
/*
list_stats(DeadlineStats,_,_,AvgDTime,_,DDevTime),
write(LogFileS, 'Deadlines processing time average (ms)		: '), write(LogFileS, AvgTime), nl(LogFileS),
write(LogFileS, 'Deadlines processing time standard deviation (ms): '), write(LogFileS, DevTime), nl(LogFileS),
*/
getFirstBsAndName([],_Name,[],[]).
getFirstBsAndName([[(T,Name)|Others]|OtherF],Name,[T|OT],[Others|OOthers]):-
    getFirstBsAndName(OtherF,Name,OT,OOthers).

perFluentStats([[]|_],[]).
perFluentStats(AllFluentStats,[(Name,Avg,Dev)|Others]):-
    getFirstBsAndName(AllFluentStats,Name,Ts,OtherFluentStats),
    list_stats(Ts,_,_,Avg,_,Dev),
    perFluentStats(OtherFluentStats,Others).


querying(IEFiles,_IEStreams, _Positions, _WM, _Step, _CurrentTime, _LastTime,RecTimes, RecTimes, InputList, InputList, OutputList, OutputList) :- 
  IEFiles = [FirstFile|Others],
  not(exists(FirstFile)),
  !.
  
querying(_IEFiles,_IEStreams, _Positions, _WM, _Step, CurrentTime, LastTime,RecTimes, RecTimes, InputList, InputList, OutputList, OutputList) :- 
  CurrentTime > LastTime, 
  !.

querying(IEFiles,IEStreams, Positions, WM, Step, CurrentTime, LastTime, InitRecTime, RecTimes, InitInput, InputList, (InitOutputOutFVpairs,InitOutputOutLI,InitOutputOutLD), OutputList) :-
  nb_getval(sts,STS),
  CurrentTimeMinusWM is CurrentTime-WM,
  write('Current Window                         	: ('), write(CurrentTimeMinusWM), write(', '), write(CurrentTime), writeln(']'),
  InitTimeSDEs is CurrentTime-Step,
  InitTime is CurrentTime-WM,
  nb_getval(prl,PRL),  handleProlog(PRL, StatisticsFlag),
  statistics(StatisticsFlag,[S1,_T1]),
  eventRecognition(CurrentTime, WM), 
  findall((F=V,L), (outputEntity(F=V),holdsFor(F=V,L),L\=[]), OELI),
  findall((EE,TT), (outputEntity(EE),happensAt(EE,TT)), OELT),
  statistics(StatisticsFlag,[S2,_T2]),
  print_CEs(_CC,_ListofTimePoints,CurrentTime,WM),
  nb_getval(times_stream,LogFileS),
  S is S2-S1, %S=T2,
  writeResult(S, LogFileS),
  write('Recognition Time (ms)			: '), writeln(S),
  % calculate and record the number of input entities
  findall((Ev,EvT), (inputEntity(Ev),happensAtIE(Ev,EvT)), EvList), length(EvList,InL1),
  findall((InF,InFT), (inputEntity(InF),holdsAtIE(InF,InFT)), InFList), length(InFList,InL2),
  findall(Interval, (inputEntity(F=V),holdsForProcessedIE(F=V,L),member(Interval,L)), InputIntervals), 
  temporalDistance(TemporalDistance),
  fluents_duration(InputIntervals, TemporalDistance, InitPoint, InitWin, InL3),
  InL is InL1+InL2+InL3,
  write('Input Entities				: '), writeln(InL),
  % compute and record output entity statistics
  findall(Interval, (outputEntity(F=V),holdsFor(F=V,L),member(Interval,L)), AllIntervals),
  fluents_duration(OELI, TemporalDistance, InitTime, CurrentTime, OELID),
  length(OELI, OutFVpairs),
  length(OELT,OELTL),
  length(AllIntervals,AllIntervalsL),
  OutLI is AllIntervalsL+OELTL,
  OutLD is OELID+OELTL,
  write('Output Entities (# fluent-value pairs)	: '),writeln(OutFVpairs),
  write('Output Entities (# intervals)		: '), writeln(OutLI),
  write('Output Entities (# timepoints)		: '), writeln(OutLD),
  writeln('========================================================='),
  newcur(CurrentTime,Step,LastTime,NewCurrentTime),
  getEvents(IEFiles,IEStreams,CurrentTime,NewCurrentTime,Positions,NewPositions),
  
  querying(IEFiles, IEStreams, NewPositions, WM, Step, NewCurrentTime, LastTime, [S|InitRecTime], RecTimes, [InL|InitInput], InputList, ([OutFVpairs|InitOutputOutFVpairs],[OutLI|InitOutputOutLI],[OutLD|InitOutputOutLD]), OutputList).

newcur(CurrentTime,Step,LastTime,NewCurrentTime):-
  NewCurrentTime is CurrentTime+Step,
  NewCurrentTime <LastTime.
newcur(CurrentTime,Step,LastTime,LastTime):-
  %writeln((CurrentTime,Step,LastTime,LastTime)),
  NewCurrentTime1 is CurrentTime+Step,
  NewCurrentTime1 >=LastTime,
  LastTime \= CurrentTime.
newcur(CurrentTime,Step,CurrentTime,NewCurrentTime):-
  NewCurrentTime is CurrentTime+1.
    
streamsFinished([end_of_file|[]]).

streamsFinished([end_of_file|OtherPositions]) :-
    streamsFinished(OtherPositions).    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Event I/O Utils
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeStacksInfo :-
  nb_getval(times_stream,Stream),
  statistics('global_stack',[GUsed,GFree]),
  statistics('local_stack',[LUsed,LFree]),
  statistics('trail',[TUsed,TFree]),
  GUg is GUsed/1073741824,
  GFg is GFree/1073741824,
  LUg is LUsed/1073741824,
  LFg is LFree/1073741824,
  TUg is TUsed/1073741824,
  TFg is TFree/1073741824,
  write(Stream,'GLOBAL (Used/Free): '),write(Stream,GUg),write(Stream,'/'),writeln(Stream,GFg),
  write(Stream,'LOCAL (Used/Free): '),write(Stream,LUg),write(Stream,'/'),writeln(Stream,LFg),
  write(Stream,'TRAIL (Used/Free): '),write(Stream,TUg),write(Stream,'/'),writeln(Stream,TFg).

getEvents(_IEFiles,IEStreams,Start,End,Positions,NewPositions) :-
    loadIEStreams(IEStreams,Start,End,Positions,NewPositions).
    
checkForInf([]) :- !.
checkForInf(Is) :-
    length(Is,L),
    nth1(L,Is,(S,E)),
    E \= inf, !.
      

writeCEs([]) :-
    nl.    
writeCEs([(_CE,[],_C)|OtherCCs]) :-
    writeCEs(OtherCCs).
writeCEs([(CE,L,C)|OtherCCs]) :-
    L \= [],
    write('          '),write(CE),write('   '),write(L),write('   '),write(C),nl,
    writeCEs(OtherCCs).

writeCEs(ResultStream,[]) :-
    nl(ResultStream), !.
writeCEs(ResultStream, [(_CE,[])|OtherCCs]) :-
    writeCEs(ResultStream,OtherCCs).
writeCEs(ResultStream,[(F=V,L)|OtherCCs]) :-
    DType = 'raw',
    L \= [],
    F =.. [FluentName|Args],
    %writeCEinLines(ResultStream,CE,L),
    write(ResultStream,'event('),
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

writeCEinLines(ResultStream,CE,[]).
writeCEinLines(ResultStream,CE,[(A,B)|L]):-
    B\=inf,
    writeElementsSeparated(ResultStream,[CE,A,B]),
    writeCEinLines(ResultStream,CE,L),!.
writeCEinLines(ResultStream,CE,[(A,B)|L]):-
    B==inf,
    writeElementsSeparated(ResultStream,[CE,A,B]),
    writeCEinLines(ResultStream,CE,L),!.
writeCEinLines(ResultStream,CE,[A|L]):-
    writeElementsSeparated(ResultStream,[CE,A,A]),!.

writeElementsSeparated(ResultStream,[]).
writeElementsSeparated(ResultStream,[E]):-
    write(ResultStream,E),nl(ResultStream).
writeElementsSeparated(ResultStream,[E|L]):-
    write(ResultStream,E),
    write(ResultStream,'|'),
    writeElementsSeparated(ResultStream,L).


writeResult(Time, Stream):-
  write(Stream,'+'), write(Stream,Time).


findIE :-
    findall((EE,TT), happensAt(EE,TT), IE),
    nb_getval(input_stream,InputStream),
    writeIE(InputStream,IE), !.

writeIE(InputStream, []) :- !.

writeIE(InputStream,[(IE,T)|OtherIEs]) :-
        write(InputStream,IE),
        write(InputStream,',  '),
        write(InputStream,T),
        nl(InputStream),
        writeIE(InputStream,OtherIEs).
    
openInputFiles([File|[]],[Stream|[]],[Position|[]]) :-
    open(File,read,Stream),
    stream_property(Stream,position(Position)).

openInputFiles([File|MoreFiles],[Stream|MoreStreams],[Position|MorePositions]) :-
    open(File,read,Stream),
    stream_property(Stream,position(Position)),
    openInputFiles(MoreFiles,MoreStreams,MorePositions).

closeInputFiles([Stream|[]]) :-
    close(Stream).
    
closeInputFiles([Stream|MoreStreams]) :-
    close(Stream),
    closeInputFiles(MoreStreams).
  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Statistics Utils
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CT in microsecs
getCPUTime(CT,yap) :-
    statistics(cputime,[CS,_T1]),
    CT is round(CS * 1000),
    !.
getCPUTime(CT,swipl) :-
    statistics(cputime,CS),
      CT is round(CS * 1000000),
      !.

stats_init(false,_TimesFilename,_ResultFilename) :- !.
stats_init(true,TimesFilename,ResultFilename) :- 
    open(TimesFilename, write, TimesStream),
      open(ResultFilename, write, ResultStream),
      %open('Events2.txt', write, InputStream),
      nb_setval(times_stream,TimesStream),
      nb_setval(results_stream,ResultStream).
      %nb_setval(input_stream, InputStream).

print_CEs(CC,ListofTimePoints,CurrentTime,WM) :-
   % writeln('Collecting stats...'),
    StartTime is CurrentTime-WM,
    findall((F=V,L2),
                     (outputEntity(F=V),
                     holdsFor(F=V,L),
                     L\==[],
		     %L2=L,
		     %replace_inf(L,L2,CurrentTime),							% REMOVE (x,inf) intervals
                     intersect_all([L,[(StartTime,CurrentTime)]],L2),                  % intersect with window
                     index(F=V,Vessel),
                     vessel(Vessel)
                     ), 
              CC),
      nb_getval(results_stream,ResultStream),
      writeCEs(ResultStream,CC).

remove_inf([],[]).
remove_inf([(A,B)|Other],[(A,B)|ROther]):-B\=inf,remove_inf(Other,ROther).
remove_inf([(A,B)|Other],ROther):-B=inf,remove_inf(Other,ROther).

replace_inf([],[],_).
replace_inf([(A,B)|Other],[(A,B)|ROther],V):-B\=inf,replace_inf(Other,ROther,V).
replace_inf([(A,B)|Other],[(A,V)|ROther],V):-B=inf,replace_inf(Other,ROther,V).

get_statistics(yap, GUsed, LUsed, TUsed, HUsed, MUnshared, AtomsNo, AtomsMem):-
     statistics(global_stack,[GUsed,_GFree]),
     statistics(local_stack,[LUsed,_LFree]),
     statistics(trail,[TUsed,_TFree]),
     statistics(heap,[HUsed,_HFree]),
     statistics(program,[MUnshared,_MFree]),
     statistics(atoms,[AtomsNo,AtomsMem]).

get_statistics(swipl, GUsed, LUsed, TUsed, HUsed, MUnshared, AtomsNo, AtomsMem):-
     statistics(global_stack,[GUsed,_GFree]),
     statistics(local_stack,[LUsed,_LFree]),
     statistics(trail,[TUsed,_TFree]),
     statistics(heapused,HUsed),
     statistics(memory,[MUnshared,_MFree]),
     statistics(atoms,[AtomsNo,AtomsMem]).

stats_end(false) :- !.
stats_end(true) :-
    nb_getval(times_stream,TimesStream),
    nb_getval(results_stream,ResultStream),
    %writeStats(ResultStream,TimesStream),
    %nb_getval(input_stream, InputStream),
    close(TimesStream),close(ResultStream).%, close(InputStream).


  
average(List, Average):- 
    sum_list(List, Sum),
    length(List, Length),
    Length > 0, 
    Average is round(Sum / Length).
    

transposeLists([[]|T],[]) :- !.
transposeLists(L,TrL) :-
    firstOfLists(L,HL,TL),
    transposeLists(TL,OtherTrL),
    append([HL],OtherTrL,TrL).

firstOfLists([],[],[]) :- !.  
firstOfLists([[H|T]|[]],[H],[T]) :- !.
firstOfLists([[H|T]|TT],HL,TL) :-
    firstOfLists(TT,IHL,ITL),
    append([H],IHL,HL),
    append([T],ITL,TL).


% write(+RecognitionTime, +LogFile)
writeResult(Time, LogFileS):-
  	write(LogFileS,'+'),
	write(LogFileS,Time).

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

handleProlog(yap, cputime).
% in case of SWI load the necessary Prolog declarations 
handleProlog(swipl, runtime).
