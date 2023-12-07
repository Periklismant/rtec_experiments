:- ['manual_csv_read.prolog'].
	
loadIEStreams([Stream|[]], StartPoint, EndPoint, [StreamPosition|[]], [NewStreamPosition]) :-
	loadSDEs(Stream, StartPoint, EndPoint, StreamPosition, NewStreamPosition).

loadIEStreams([_Stream|Streams], StartPoint, EndPoint, [end_of_file|SPs], [end_of_file|NSPs]) :-
	loadIEStreams(Streams, StartPoint, EndPoint, SPs, NSPs).

loadIEStreams([Stream|Streams], StartPoint, EndPoint, [StreamPosition|SPs], NewStreamPositions) :-
	loadSDEs(Stream, StartPoint, EndPoint, StreamPosition, NewStreamPosition),
	loadIEStreams(Streams, StartPoint, EndPoint, SPs, MoreStreamPositions),
	append([NewStreamPosition],MoreStreamPositions,NewStreamPositions).
		
loadIEStreams(Stream, StartPoint, EndPoint) :-
	loadSDEs(Stream, StartPoint, EndPoint, [], _NewStreamPosition).


loadSDEs(Stream,StartPoint,EndPoint,StreamPosition,NewStreamPosition) :-
	% does not exist in yap
	%csv_read_file_row(Stream,Row,[line(Line),separator(0'|)]),
	% so, use manual_csv_reader instead
	set_input(Stream),
	get_row_from_line(Stream,Row,StreamPosition,RowStreamPosition),
	%write('Processing row: '),writeln(Row),
	processRow(Row,StartPoint,EndPoint,LastLine),
	(
	% if LastLine not reached yet, fail and continue
	LastLine = 1,
	% otherwise, get StreamPosition and cut (do not check next lines)
	NewStreamPosition = StreamPosition, 
	!
	;
	LastLine = 2,
	NewStreamPosition = end_of_file,
	!
	;
	loadSDEs(Stream,StartPoint,EndPoint,RowStreamPosition,NewStreamPosition)
	).

processRow([],_StartPoint,_EndPoint,LastLine) :-
	LastLine is 2,
	!.
	
processRow(Row,StartPoint,_EndPoint,LastLine) :-
	arg(2,Row,ArrivalTime),
	StartPoint >= ArrivalTime,
	%writeln("Start not reached"),
	LastLine is 0.
	
processRow(Row,StartPoint,EndPoint,LastLine) :-
	arg(2,Row,ArrivalTime),
	% if StartPoint not reached, fail and continue
	StartPoint < ArrivalTime,
	%writeln("After start"),
	(
	EndPoint >= ArrivalTime,
	%writeln("Valid row"),
	LastLine is 0,
	getEventFromRow(Row,NewEvent),
	%write('New Event: '),writeln(NewEvent),
	assert(NewEvent),
	!
	;
	LastLine is 1
	)
	.
	
getEventFromRow(Row,NewEvent) :-
	%write('Row: '),writeln(Row),
	% if row contains neither an event nor a fluent, this will fail
	arg(1,Row,EventType),
	(
	% get all event types (from declarations)
	findall(H,(event(E),E=..[H|_T]),Events),
	member(EventType,Events),
	checkGrounding(EventType, Row),
	formatEvent(Row,Event,OccurenceTime),
	NewEvent = happensAtIE(Event,OccurenceTime),
	!
	;
	% get all sdFluents (from declarations)
	findall(H,(sDFluent(F=_V),F=..[H|_T]),Fluents),
	member(EventType,Fluents),
	checkGrounding(EventType, Row),
	formatFluent(Row,Fluent,Value,StartTime,EndTime),
	NewEvent = holdsForIESI(Fluent=Value,(StartTime,EndTime)),
	!
	).
	
	
formatEvent(Row,Event,OccurenceTime) :-
	% get rid of row atom (H1), Arrival time (H3) 
	% also return Occurence Time
	Row =.. [_H1|[H2|[_H3|[OccurenceTime|T]]]],
	Event =.. [H2|T].
	
formatFluent(Row,Fluent,Value,StartTime,EndTime) :-
	% get rid of row atom (H1), Arrival time (H3), 
	% also return StartTime and EndTime 
	Row =.. [_H1|[H2|[_H3|[StartTime|[EndTime|[Value|T]]]]]],
	Fluent =.. [H2|T].
	
checkGrounding(EventType, Row) :-
	(
	findGroundings(EventType, Row)
	;
	true
	).
	
findGroundings(EventType, Row) :-
	needsGrounding(EventType, Index, ToGround),
	Row =.. [_H|T],
	nth0(Index, T, Value),
	GroundFact =.. [ToGround | [Value]],
	\+ clause(GroundFact, _Body),
	assert(GroundFact),
	fail.
	
