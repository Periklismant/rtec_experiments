
%%%%%%%%%%%%%%%%%%%%%%%% Maritime-Brest %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use SWI on the maritime datasets only for debugging

%%%%% critical points

handleApplication(Prolog, brest-critical, InputMode, LogFile, ResultsFile, WM, Step, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, _SDEBatch) :-
	(Prolog=yap,
         add_wm_step_info('../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-critical-yap-retrall','.txt', WM, Step, LogFile),
	 add_wm_step_info('../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-critical-yap-retrall','-recognised-intervals-critical-yap.txt', WM, Step, ResultsFile)
	 ;
	 Prolog=swi,
	 LogFile = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-critical-SWI-1day-1day.txt',
	 ResultsFile = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-critical-SWI-1day-1day-recognised-intervals-critical-SWI.txt'
	),
	% start of the dataset:
	StartReasoningTime = 1443650400,
	% end of the dataset:
	EndReasoningTime = 1459461588,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing,
	ClockTick = 1,
	% load the patterns:
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Brest/experiments/data/dynamic/preprocessed_dataset_RTEC_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Brest/experiments/data/static/loadStaticData.prolog'), !.

%%%%% enriched points

handleApplication(Prolog, brest-enriched, InputMode, LogFile, ResultsFile, WM, Step, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, _SDEBatch) :-
	(Prolog=yap,
 	 add_wm_step_info('../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-enriched-yap','.txt', WM, Step, LogFile),
	 add_wm_step_info('../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-enriched-yap','-recognised-intervals-enriched-yap.txt', WM, Step, ResultsFile)
	 ;
	 Prolog=swi,
	 LogFile = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-enriched-SWI-1day-1day.txt',
	 ResultsFile = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-Brest-enriched-SWI-1day-1day-recognised-intervals-enriched-SWI.txt'
	),
	% start of the dataset:
	StartReasoningTime = 1443650400,
	% end of the dataset:
	EndReasoningTime = 1459461588,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing,
	ClockTick = 1,
	% load the patterns:
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Brest/experiments/data/dynamic/preprocessed_dataset_RTEC_enriched_nd.csv']),
	%%% Important: instruct the execution script that the recognitions on this dataset will be treated as the ground truth
	assert( datasetType(ground_truth) ),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Brest/experiments/data/static/loadStaticData.prolog'), !.

add_wm_step_info(Str1, Str2, WM, Step, StrO):-
    number_atom(WM, WMatom),
    number_atom(Step, StepAtom),
	atom_concat(Str1, '-', Str1a),
	atom_concat(Str1a, WMatom, Str1b),
	atom_concat(Str1b, '-', Str1c),
	atom_concat(Str1c, StepAtom, Str1d),
	atom_concat(Str1d, Str2, StrO).
        
