:- use_module(library(readutil)).
:- use_module(library(lists)).

% just for testing
test_csv(FileName) :-
	open(FileName,read,Stream),
	set_input(Stream),
	stream_property(Stream,position(SP)),
	write('SP:'),write(SP),nl,
	load_rows_csv(Stream,2145918139768,[],NSP1),
	stream_property(Stream,position(NSP)),
	write('NSP:'),write(NSP),nl,
	load_rows_csv(Stream,2145924603403,NSP1,NSP2),
	load_rows_csv(Stream,2145924882586,NSP2,_NSP3),
	close(Stream).
	
% just for testing
load_rows_csv(Stream,Tlimit,SP,NSP) :-
	SP \= end_of_file,
	get_row_from_line(Stream,Row,SP,ISP),
	(
	Row = [],
	NSP = ISP,
	!
	;
	%write(Row),nl,
	arg(2,Row,T),
	T > Tlimit, 
	NSP = SP,
	!
	;
	write('Row:'),write(Row),nl,
	load_rows_csv(Stream,Tlimit,ISP,NSP)
	).

get_row_from_line(_Stream,[],end_of_file,end_of_file).
	
get_row_from_line(Stream,Row,StreamPosition,NewStreamPosition) :-
	(
	StreamPosition \= [],
	set_stream_position(Stream,StreamPosition),
	!
	;
	StreamPosition = []
	),
	read_line_to_codes(Stream,Codes),
	(
	Codes = end_of_file,
	Row = [],
	NewStreamPosition = end_of_file,
	!
	;
	% In case an empty line is read. Treat this as EOF.
	%Codes = [],
	%Row = [],
	%NewStreamPosition = end_of_file,
	%!
	%;
	partition_by_delim(Codes,124,[[]],PartitionedCodes),
	atom_partitions(PartitionedCodes,Atoms),
	%Event =.. Atoms,
	Row =.. [row|Atoms],
	stream_property(Stream,position(NewStreamPosition))
	).

% from a list of codes' partitions (e.g. [[116, 114, 110],[50, 49]], 
% see partition_by_delim predicate), create a list of atoms 
% (e.g. [[116, 114, 110],[50, 49]] --> [trx,21])
atom_partitions([Partition|[]],[Atom|[]]) :-
	atom_codes(Atom1,Partition),
	(
	check_if_number(Partition),
	attempt_to_number(Atom1,Atom),
	!
	;
	Atom=Atom1
	),
	!.
	
atom_partitions([Partition|MorePartitions],[Atom|MoreAtoms]) :-
	atom_codes(Atom1,Partition),
	(
	check_if_number(Partition),
	attempt_to_number(Atom1,Atom),
	!
	;
	Atom=Atom1
	),
	atom_partitions(MorePartitions,MoreAtoms).
	
check_if_number([]) :- fail.

check_if_number([Code|[]]) :-
	(
	(Code = 45 ; Code = 46),
	!
	;
	Code >= 48,
	Code =< 57
	).
	
check_if_number([Code|MoreCodes]) :-
	(
	(Code = 45 ; Code = 46),
	!
	;
	Code >= 48,
	Code =< 57
	),
	check_if_number(MoreCodes).
	
		
	
attempt_to_number(AtomField,Field) :-
	(
	atom_number(AtomField,Field),
	!
	;
	AtomField='',
	Field=[],
	!
	;
	Field = AtomField
	).


% for a list of codes(e.g. [116 114 110 124 50 49]), get partitions
% delimited by Delimiter (e.g. 124) and create a list of those partitions
% (e.g. [[116, 114, 110],[50, 49]])
partition_by_delim([],_Delimiter,CurrentPartitions,Partitions) :-
	reverse(CurrentPartitions,Partitions),
	!.

partition_by_delim([Delimiter|[]],Delimiter,CurrentPartitions,Partitions) :-
	reverse(CurrentPartitions,Partitions),
	!.
	
partition_by_delim([Delimiter|MoreCodes],Delimiter,CurrentPartitions,PartitionedCodes) :-
	MoreCodes = [Code|OtherCodes],
	AppendedPartitions = [[Code]|CurrentPartitions],
	partition_by_delim(OtherCodes,Delimiter,AppendedPartitions,PartitionedCodes),
	!.
	
partition_by_delim([Code|MoreCodes],Delimiter,[CurrentPartition|MorePartitions],PartitionedCodes) :-
	Code \= Delimiter,
	append(CurrentPartition,[Code],AppendedPartition),
	partition_by_delim(MoreCodes,Delimiter,[AppendedPartition|MorePartitions],PartitionedCodes).
	
	

	
/*
Below this line, other predicates for a char-by-char reading.
Not used.
*/
	
load_csv(Stream,Tlimit,SP,NSP) :-
	csv_read_stream_row(Stream,Row,SP,ISP),
	(
	arg(2,Row,T),
	T > Tlimit, 
	NSP = SP,
	!
	;
	write('Row:'),write(Row),nl,
	load_csv(Stream,Tlimit,ISP,NSP)
	).


csv_read_row(FileName,Row,LineCount) :-
	open(FileName,read,Stream),
	read_line(Stream,[row],NewLine,LineCount),
	Row =.. NewLine,
	close(Stream).
	
csv_read_stream_row(Stream,Row,[],SP) :-
	read_line(Stream,[row],NewLine,_LineCount),
	Row =.. NewLine,
	stream_property(Stream,position(SP)), !.
	
csv_read_stream_row(Stream,Row,OldSP,NewSP) :-
	OldSP \= [],
	set_stream_position(Stream,OldSP),
	read_line(Stream,[row],NewLine,LineCount),
	(
	LineCount = 2,
	Row = [],
	!
	;
	Row =.. NewLine
	),
	%stream_position(Stream,SP),
	stream_property(Stream,position(NewSP)).
	
read_line(Stream,OldLine,NewLine,LineCount) :-
	%set_input(Stream),
	read_field(Stream,[],ListField,LineBreak),
	atomic_list_concat(ListField, AtomField),
	% try to convert Atom to Number, if possible
	attempt_to_number(AtomField,Field),
	(
	LineBreak \= 0,
	append(OldLine,[Field],NewLine),
	LineCount = LineBreak,
	!
	;
	LineBreak = 0, 
	append(OldLine,[Field],InterLine),
	read_line(Stream,InterLine,NewLine,LineCount)
	).
	
%read_field(Stream,OldField,NewField) :-
	
read_field(Stream,OldField,NewField,LineBreak) :- 
	get_char(Char),
	(
	% clear any blanks at the beginning (OldField=[])
	OldField = [],
	(Char='\r'; Char='\n'),
	read_field(Stream,[],NewField,LineBreak),
	!
	;
	% this is the end of current line, break out
	(Char='\r'; Char='\n'),
	NewField = OldField,
	LineBreak = 1,
	!
	;
	Char=end_of_file,
	NewField = OldField,
	LineBreak = 2,
	!
	;
	Char='|',
	NewField = OldField,
	LineBreak = 0,
	!
	;
	append(OldField,[Char],InterField),
	read_field(Stream,InterField,NewField,LineBreak)
	).
	
