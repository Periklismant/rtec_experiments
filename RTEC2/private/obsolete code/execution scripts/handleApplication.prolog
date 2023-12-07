
% handleApplication(+Prolog, +ApplicationName, -LogFile, -WM, -Step, -LastTime, -StreamOrderFlag, -DynamicGroundingFlag, -PreprocessingFlag, -ClockTick)

% This is a predicate for setting the appropriate parameters for executing an application (see +ApplicationName),
% and consulting the relevant compiled event description, declarations and dataset. 
% Execution parameters:
% LogFile: the file recording the statistics of execution, WM: working memory size, Step: step size,
% LastTime: the last time-point of the dataset, StreamOrderFlag: 'ordered' or 'unordered' dataset, 
% DynamicGroundingFlag: 'dynamicgrounding' or 'nodynamicgrounding', PreprocessingFlag: 'preprocessing' or 'nopreprocessing', 
% ClockTick: temporal distance between two consecutive time-points, SDEBatch: the input narrative size asserted in a single batch

handleApplication(Prolog, toy, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :- 
	(Prolog=yap, 
	 LogFile = '../examples/toy/experiments/execution log files/log-YAP-toy.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/toy/experiments/execution log files/log-SWI-toy.txt'
	),
	WM = 30,
	Step = 30, 
	LastTime = 30,
	StreamOrderFlag = ordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../examples/toy/patterns/toy_rules_compiled.prolog'),
	consult('../examples/toy/patterns/toy_declarations.prolog'),
	%%%%%%%% THERE ARE NO DEADLINES IN THIS APPLICATION %%%%%%%%
	%consult('../src/timeoutTreatment.prolog'),
	consult('../examples/toy/experiments/data/toy_data.prolog'),
	consult('../examples/toy/experiments/data/toy_var_domain.prolog'), !.

handleApplication(Prolog, netbillSmall, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :- 
	(Prolog=yap, 
	 LogFile = '../examples/negotiation/experiments/execution log files/log-YAP-netbill-small-20-10.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/negotiation/experiments/execution log files/log-SWI-netbill-small-20-10.txt'
	),
	WM = 20,
	Step = 10, 
	LastTime = 20,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
	consult('../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
	consult('../src/timeoutTreatment.prolog'),
	consult('../examples/negotiation/experiments/data/negotiation-static_test.prolog'),
	consult('../examples/negotiation/experiments/data/prolog/negotiation-test_stream.prolog'), !.

handleApplication(Prolog, netbillBig, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
	(Prolog=yap,
	 LogFile = '../examples/negotiation/experiments/execution log files/log-YAP-netbill-big-10-10.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/negotiation/experiments/execution log files/log-SWI-netbill-big-10-10.txt'
	),
	WM = 10,
	Step = 10, 
	LastTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
	consult('../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
	consult('../src/timeoutTreatment.prolog'),
	consult('../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	consult('../examples/negotiation/experiments/data/prolog/negotiation-data_generator.prolog'), !.

handleApplication(Prolog, votingSmall, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :- 
	(Prolog=yap,
	 LogFile = '../examples/voting/experiments/execution log files/log-YAP-voting-small-20-10.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/voting/experiments/execution log files/log-SWI-voting-small-20-10.txt'
	),
	WM = 20,
	Step = 10, 
	LastTime = 20,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
	consult('../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
	consult('../src/timeoutTreatment.prolog'),
	consult('../examples/voting/experiments/data/voting-static_test.prolog'),
	consult('../examples/voting/experiments/data/prolog/voting-test_stream.prolog'), !.

handleApplication(Prolog, votingBig, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
	(Prolog=yap,
	 LogFile = '../examples/voting/experiments/execution log files/log-YAP-voting-big-10-10.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/voting/experiments/execution log files/log-SWI-voting-big-10-10.txt'
	),
	WM = 10,
	Step = 10, 
	LastTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
	consult('../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
	consult('../src/timeoutTreatment.prolog'),
	consult('../examples/voting/experiments/data/voting-static_generator.prolog'),
	consult('../examples/voting/experiments/data/prolog/voting-data_generator.prolog'), !.

handleApplication(Prolog, caviar, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
	(Prolog=yap,
	 LogFile = '../examples/caviar/experiments/execution log files/log-YAP-caviar-100K-100K.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/caviar/experiments/execution log files/log-SWI-caviar-100K-100K.txt'
	),
	WM = 100000,
	Step = 100000, 
	LastTime = 1007000,
	StreamOrderFlag = ordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = preprocessing, 
	ClockTick = 40,
	SDEBatch = 1000,
	%%%%%%%% LOAD THE APPLICATION-SPECIFIC PRE-PROCESSING MODULE %%%%%%%%
	consult('../examples/caviar/patterns/pre-processing.prolog'),
	consult('../examples/caviar/patterns/caviar_declarations.prolog'),
	consult('../examples/caviar/patterns/compiled_caviar_patterns.prolog'),
	%%%%%%%% THERE ARE NO DEADLINES IN THIS APPLICATION %%%%%%%%
	%consult('../src/timeoutTreatment.prolog'),
	consult('../examples/caviar/experiments/data/prolog/updateSDE-caviar.prolog'),
	consult('../examples/caviar/experiments/data/prolog/appearance.prolog'),
	consult('../examples/caviar/experiments/data/prolog/movementB.prolog'), 
	consult('../examples/caviar/experiments/data/list-of-ids.prolog'), !.

handleApplication(Prolog, ctm, LogFile, WM, Step, LastTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
	(Prolog=yap,
	 LogFile = '../examples/ctm/experiments/execution log files/log-YAP-ctm-10K-10K.txt'
	 ;
	 Prolog=swi,
	 LogFile = '../examples/ctm/experiments/execution log files/log-SWI-ctm-10K-10K.txt'
	),
	WM = 10000,
	Step = 10000, 
	LastTime = 50000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ClockTick = 1,
	SDEBatch = 1000,
	consult('../examples/ctm/patterns/ctm_declarations.prolog'),
	consult('../examples/ctm/patterns/compiled_ctm_patterns.prolog'),
	%%%%%%%% THERE ARE NO DEADLINES IN THIS APPLICATION %%%%%%%%
	%consult('../src/timeoutTreatment.prolog'),
	consult('../examples/ctm/experiments/data/prolog/updateSDE-ctm.prolog'),
	consult('../examples/ctm/experiments/data/prolog/abrupt_acceleration.prolog'),
	consult('../examples/ctm/experiments/data/prolog/abrupt_deceleration.prolog'),
	consult('../examples/ctm/experiments/data/prolog/internal_temperature_change.prolog'),
	consult('../examples/ctm/experiments/data/prolog/noise_level_change.prolog'),
	consult('../examples/ctm/experiments/data/prolog/passenger_density_change.prolog'),
	consult('../examples/ctm/experiments/data/prolog/sharp_turn.prolog'),
	consult('../examples/ctm/experiments/data/prolog/stop_enter_leave.prolog'),
	consult('../examples/ctm/experiments/data/vehicles.prolog'), !.



