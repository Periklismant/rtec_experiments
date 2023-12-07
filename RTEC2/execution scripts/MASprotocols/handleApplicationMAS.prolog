
% handleApplication(+Prolog, +ApplicationName, -InputMode, -LogFile, -WM, -Step, -AgentNo, -Seed, -EndReasoningTime, -StreamOrderFlag, -DynamicGroundingFlag, -PreprocessingFlag, -ClockTick)

% This is a predicate for setting the appropriate parameters for executing an application (see +ApplicationName),
% and consulting the relevant compiled event description, declarations and dataset. 
% Execution parameters:
% InputMode: read input data from CSV files or Prolog files
% LogFile: the file recording the statistics of execution, ResultsFile: the file recording the recognised intervals, 
% WM: working memory size, Step: step size,
% AgentNo: number of agents in the scenario, Seed: seed for random data generator,
% DeadlinesFactor: The temporal deadlines of fluents is multiplied by this factor.
% StartReasoningTime and EndReasoningTime specify the range of continuous queries, ie continuous queries take place in (StartReasoningTime, EndReasoningTime]
% the last time-point of the dataset, StreamOrderFlag: 'ordered' or 'unordered' dataset, 
% DynamicGroundingFlag: 'dynamicgrounding' or 'nodynamicgrounding', PreprocessingFlag: 'preprocessing' or 'nopreprocessing', 
% ForgetThreshold: a parameter which helps decide which forget mechanism will be used. The mechanisms differ regarding the usage of the retract/retractall predicates
% 				If the number of events (to be retracted) per time-point is greater than ForgetThreshold, use retractall at each time-point. 
% 				Else, retract every event one by one.
%				Set to '-1' to avoid using retractall.
% DynamicGroundingThreshold: a parameter which helps decide the retract-assert mechanism of dynamic grounding. Again, the cases differ with respect to retract/retractall.
%				If the ratio of the size of the intersection of old ground terms and new ground terms to the number of old ground terms is greater than DynamiGroundingThreshold, do not retract/assert that intersection.
%				Else, retractall ground terms and re-assert new ground terms.
%				Set to '-1' to avoid using retractall.   
% ClockTick: temporal distance between two consecutive time-points, SDEBatch: the input narrative size asserted in a single batch




/*
datasetType/1 is used for logging the recognised intervals in continuousQueries.prolog
datasetType/1 is asserted in this file, and checked in continuousQueries.prolog
datasetType(ground_truth) denotes that the recognitions on the corresponding dataset will be used as ground truth
*/
:- dynamic datasetType/1.
%:- discontiguous handleApplication/16, handleApplication/14.


%%%%%%%%%%%%%%%%%%%%%%%% TOY EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handleApplication(ExperimentName,Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
    ExperimentName = toydeadlinescsv, !, 
	OutputPathPrefix = '../../examples/toy-deadlines/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	%WM = 10,
	%Step = 10, 
	StartReasoningTime = 0,
	EndReasoningTime = 40,
	StreamOrderFlag = ordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/toy-deadlines/patterns/toy_rules_compiled.prolog'),
	consult('../../examples/toy-deadlines/patterns/toy_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	% load the csv file with input data stream	
	InputMode = csv(['../../examples/toy-deadlines/experiments/data/toy_data.csv']), 
	consult('../../examples/toy-deadlines/experiments/data/toy_var_domain.prolog'), !.


%%%%%%%%%%%%%%%%%%%%%%%% FEEDBACK LOOPS EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handleApplication(ExperimentName, _Prolog, _InputMode, LogFile, ResultsFile, _WM, _Step, EndReasoningTime, Vals, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	%AgentNo and Seed are singleton in this case -- no data generation or script generated csv dataset is being used. 
	ExperimentName = phage_g, !,
	appVars(phage_g, Vars), assertVariables(phage_g), valsToNum(Vals, NumID),
	OutputPathPrefix = '../../examples/feedback_loops/results/phage_g',
	add_info(OutputPathPrefix,'-time.txt', [EndReasoningTime, NumID], LogFile),
	add_info(OutputPathPrefix,'.txt', [EndReasoningTime, NumID], ResultsFile),
	StartReasoningTime = 0,
	%EndReasoningTime = Agents, %8000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	retractInitially(Vars),
	assertInitially(Vars, Vals),
	consult('../../examples/feedback_loops/resources/patterns/feedback_loops_patterns.prolog'),
	consult('../../examples/feedback_loops/resources/patterns/feedback_loops_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog').
	%InputMode = dynamic_predicates(['../../examples/feedback_loops/dataset/prolog/data.prolog']), !.

handleApplication(ExperimentName, _Prolog, _InputMode, LogFile, ResultsFile, _WM, _Step, EndReasoningTime, Vals, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	%AgentNo and Seed are singleton in this case -- no data generation or script generated csv dataset is being used. 
	ExperimentName = immune_g, !,
	appVars(immune_g, Vars), assertVariables(immune_g), valsToNum(Vals, NumID),
	OutputPathPrefix = '../../examples/feedback_loops/results/immune_g',
	add_info(OutputPathPrefix,'-time.txt', [EndReasoningTime, NumID], LogFile),
	add_info(OutputPathPrefix,'.txt', [EndReasoningTime, NumID], ResultsFile),
	StartReasoningTime = 0,
	%EndReasoningTime = Agents, %8000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	retractInitially(Vars),
	assertInitially(Vars, Vals),
	consult('../../examples/feedback_loops/resources/patterns/feedback_loops_patterns.prolog'),
	consult('../../examples/feedback_loops/resources/patterns/feedback_loops_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog').
	%InputMode = dynamic_predicates(['../../examples/feedback_loops/dataset/prolog/data.prolog']), !.

%%%%%%%%%%%%%%%%%%%%%%%% NETBILL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	%AgentNo and Seed are singleton in this case -- no data generation or script generated csv dataset is being used. 
	ExperimentName = netbillSmallcsv, !,
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 20,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_test.prolog'),
	InputMode = csv(['../../examples/negotiation/experiments/data/csv/negotiation-test_stream.csv']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	%AgentNo and Seed are singleton in this case -- no data generation or script generated csv dataset is being used. 
	ExperimentName = netbillSmall, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 20,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_test.prolog'),
	InputMode = dynamic_predicates(['../../examples/negotiation/experiments/data/prolog/negotiation-test_stream.prolog']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :-
	ExperimentName = netbillBig, !, 	
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
    (Prolog=yap, 
	 srandom(Seed) ;
	 Prolog=swi,
	 set_random(seed(Seed))),
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputMode = dynamic_predicates(['../../examples/negotiation/experiments/data/prolog/negotiation-csv_data_generator.prolog']), !.


handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :-
	ExperimentName = netbillBigcsv, !,
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/negotiation/experiments/data/csv/negotiation', '.csv', [AgentNo ,Seed], InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = netbillBigDG, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputMode = dynamic_predicates(['../../examples/negotiation/experiments/data/prolog/negotiation-csv_data_generator.prolog']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  netbillBigDGcsv, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	% assert(datasetType(ground_truth)),
	add_info('../../examples/negotiation/experiments/data/csv/negotiation', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile), % Add EndReasoningTime for larger datasets
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  netbillQuote, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_quote.prolog'),
	consult('../../examples/negotiation/patterns/netbill_quote_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	% assert(datasetType(ground_truth)),
	InputFile = '../../examples/negotiation/experiments/data/csv/negotiation-200-100-1.csv',
	%add_info('../../examples/negotiation/experiments/data/csv/netbill', '-1.csv', [EndReasoningTime, AgentNo], InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, _Seed, _DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = netbillDelays, !,
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, Delay], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, Delay], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 1000,
	%EndReasoningTime0 = 1000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/negotiation/experiments/data/csv/delayed_files/agents', '_no_upper_bound%.csv', [AgentNo, EndReasoningTime, 'gamma_delayed', Delay], '_', InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, _Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = netbillnaive, !,
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTECnaive_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputMode = dynamic_predicates(['../../examples/negotiation/experiments/data/prolog/negotiation-csv_data_generator.prolog']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = netbillnaivecsv, !,
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 1000,

	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),
	
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTECnaive_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/negotiation/experiments/data/csv/negotiation', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, _Seed, _DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = netbillNaiveDelays, !,
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, Delay], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, Delay], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 1000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTECnaive_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/negotiation/experiments/data/csv/delayed_files/agents', '_no_upper_bound%.csv', [AgentNo, EndReasoningTime, 'gamma_delayed', Delay], '_', InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  netbillnaiveDeadlines, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatmentNaive.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/negotiation/experiments/data/csv/negotiation', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile), % Add EndReasoningTime for larger datasets
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  netbillnaiveDeadlinesTest, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatmentNaive.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputFile = '../../examples/negotiation/experiments/data/csv/negotiation-4000-100-1.csv',
	%add_info('../../examples/negotiation/experiments/data/csv/negotiation', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile), % Add EndReasoningTime for larger datasets
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  netbillDeadlinesTest, !, 
	OutputPathPrefix = '../../examples/negotiation/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 1000,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
	consult('../../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputFile = '../../examples/negotiation/experiments/data/csv/negotiation-4000-1000-1.csv',
	%add_info('../../examples/negotiation/experiments/data/csv/negotiation', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile), % Add EndReasoningTime for larger datasets
	InputMode = csv([InputFile]), !.

%%%%%%%%%%%%%%%%%%%%%%%% VOTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	%AgentNo and Seed are singleton in this case -- no data generation or script generated csv dataset is being used. 
	ExperimentName = votingSmallcsv, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 20,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_test.prolog'),
	InputMode = csv(['../../examples/voting/experiments/data/csv/voting-test_stream.csv']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = votingSmall, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 30,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_test.prolog'),
	InputMode = dynamic_predicates(['../../examples/voting/experiments/data/prolog/voting-test_stream.prolog']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :-
	ExperimentName = votingBig, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10,
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	(Prolog=yap, 
	 srandom(Seed) ;
	 Prolog=swi,
	 set_random(seed(Seed))),
	consult('../../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputMode = dynamic_predicates(['../../examples/voting/experiments/data/prolog/voting-csv_data_generator.prolog']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :-
	ExperimentName = votingBigcsv, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/voting/experiments/data/csv/voting', '.csv', [AgentNo, Seed], InputFile),
	InputMode = csv([InputFile]), !.
	
handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :-
	ExperimentName = votingBigDG, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 100,
	(Prolog=yap, 
	 srandom(Seed) ;
	 Prolog=swi,
	 set_random(seed(Seed))),
	consult('../../examples/voting/patterns/vopr_RTEC_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputMode = dynamic_predicates(['../../examples/voting/experiments/data/prolog/voting-csv_data_generator.prolog']), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = votingBigDGcsv, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 1000,
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	assert(datasetType(ground_truth)),
	add_info('../../examples/voting/experiments/data/csv/voting', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, _Seed, _DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = votingDelays, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, Delay, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, Delay, EndReasoningTime], ResultsFile),
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, %% Check this! 
	DynamicGroundingThreshold = 0.8,
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/voting/experiments/data/csv/delayed_files/agents', '_no_upper_bound%.csv', [AgentNo, EndReasoningTime, 'gamma_delayed', Delay], '_', InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, _Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = votingNaive, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step], ResultsFile),
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTECnaive_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputMode = dynamic_predicates(['../../examples/voting/experiments/data/prolog/voting-csv_data_generator.prolog']), !.


handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = votingNaivecsv, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, EndReasoningTime], ResultsFile),
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTECnaive_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/voting/experiments/data/csv/voting', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, _Seed, _DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName = votingNaiveDelays, !,
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, Delay, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, Delay, EndReasoningTime], ResultsFile),
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, %% Check this! 
	DynamicGroundingThreshold = 0.8,
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTECnaive_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/voting/experiments/data/csv/delayed_files/agents', '_no_upper_bound%.csv', [AgentNo, EndReasoningTime, 'gamma_delayed', Delay], '_', InputFile),
	InputMode = csv([InputFile]), !.


handleApplication(Prolog, votingComparison, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, _DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	(Prolog=yap, 
	 add_info('../../examples/voting/experiments/execution log files/log-YAP-votingComparison','.txt', [WM, Step, AgentNo, Seed], LogFile),
	 add_info('../../examples/voting/experiments/execution log files/log-YAP-votingComparison','-recognised-intervals.txt', [WM, Step, AgentNo, Seed], ResultsFile)
	 ;
	 Prolog=swi,
	 add_info('../../examples/voting/experiments/execution log files/log-SWI-votingComparison','.txt', [WM, Step, AgentNo, Seed], LogFile),
	 add_info('../../examples/voting/experiments/execution log files/log-SWI-votingComparison','-recognised-intervals.txt', [WM, Step, AgentNo, Seed], ResultsFile)
	),
	StartReasoningTime = 0,
	EndReasoningTime = 63430, %31710, %15850, %7900,  %
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = nodynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 6343, %3171, %1585, %790, %
	consult('../../examples/voting/patterns/vopr_comparison_compiled.prolog'),
	consult('../../examples/voting/patterns/vopr_comparison_declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator_comparison.prolog'),
	assert_n_agents(AgentNo),
	add_info('../../examples/voting/experiments/data/csv/voting', '-rtecComparison.csv', [AgentNo, Seed], InputFile),
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  votingnaiveDeadlinesTest, !, 
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 100,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatmentNaive.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputFile = '../../examples/voting/experiments/data/csv/voting-4000-100-1.csv',
	%add_info('../../examples/voting/experiments/data/csv/voting', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile), % Add EndReasoningTime for larger datasets
	InputMode = csv([InputFile]), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, AgentNo, Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, SDEBatch) :- 
	ExperimentName =  votingDeadlinesTest, !, 
	OutputPathPrefix = '../../examples/voting/experiments/execution log files/log',
	StartReasoningTime = 0,
	EndReasoningTime = 1000,

	add_info(OutputPathPrefix,'.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], LogFile),
	add_info(OutputPathPrefix,'-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, AgentNo, Seed, DeadlinesFactor, EndReasoningTime], ResultsFile),

	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = 10, 
	DynamicGroundingThreshold = 0.8, 
	ClockTick = 1,
	SDEBatch = 10,
	consult('../../examples/voting/patterns/vopr_RTEC_compiled_dg.prolog'),
	consult('../../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	consult('../../examples/voting/experiments/data/voting-static_generator.prolog'),
	assert_n_agents(AgentNo),
	InputFile = '../../examples/voting/experiments/data/csv/voting-4000-1000-1.csv',
	%add_info('../../examples/voting/experiments/data/csv/voting', '.csv', [AgentNo, EndReasoningTime, Seed], InputFile), % Add EndReasoningTime for larger datasets
	InputMode = csv([InputFile]), !.

%% Brest %% 
handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :-
	ExperimentName = brestCritical, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	StartReasoningTime = 1443650400,
	%EndReasoningTime = 1446242400,
	% first two months end:
	EndReasoningTime = 1448834400,
	% end of dataset:
	%EndReasoningTime = 1459548000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% load the patterns: 
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled.prolog'), % _Cycles 
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	%assert(datasetType(ground_truth)),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Brest/experiments/data/dynamic/preprocessed_dataset_RTEC_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Brest/experiments/data/static/loadStaticData.prolog'), 
	!.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :-
	ExperimentName = brestDeadlines, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	StartReasoningTime = 1443650400,
	%EndReasoningTime = 1446242400,
	% first two months end:
	EndReasoningTime = 1448834400,
	% end of dataset:
	%EndReasoningTime = 1459548000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% load the patterns: 
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled_Deadline_Fluents.prolog'),
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	%assert(datasetType(ground_truth)),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Brest/experiments/data/dynamic/preprocessed_dataset_RTEC_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Brest/experiments/data/static/loadStaticData.prolog'), 
	!.


handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :-
	ExperimentName = brestCriticalNoDeadlines, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log-NoDeadlines',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	StartReasoningTime = 1443650400,
	%EndReasoningTime = 1446242400,
	% first two months end:
	EndReasoningTime = 1448834400,
	% end of dataset:
	%EndReasoningTime = 1459548000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% load the patterns: 
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled.prolog'), % _Cycles 
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	%consult('../../src/timeoutTreatment.prolog'),
	%assert(datasetType(ground_truth)),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Brest/experiments/data/dynamic/preprocessed_dataset_RTEC_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Brest/experiments/data/static/loadStaticData.prolog'), 
	!.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :- 
	ExperimentName = brestDelays, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Brest/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor, Delay], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor, Delay], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	StartReasoningTime = 1443650400,
	%EndReasoningTime = 1446242400,
	% first two months end:
	EndReasoningTime = 1448834400,
	% end of dataset:
	%EndReasoningTime = 1459548000,
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% SDEBatch = 10,
	% load the patterns: 
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled.prolog'), % _Cycles 
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	add_info('../../examples/Maritime-Monitoring/Brest/experiments/data/dynamic/delayed_files/gamma_delayed', '%.csv', [Delay], '_', InputFile),
	InputMode = csv([InputFile]), 
	% load the static data
	consult('../../examples/Maritime-Monitoring/Brest/experiments/data/static/loadStaticData.prolog'), 
	!.

% Europe-IMIS
handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :-
	ExperimentName = europeIMISCritical, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Europe-IMIS/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	%StartReasoningTime = 1451606400,
	% 1/5 of dataset is 535677 timepoints
	%StartReasoningTime = 1451606400,
	%EndReasoningTime = 1452142077,
	StartReasoningTime = 1452142077,
	EndReasoningTime = 1452677754,
	%StartReasoningTime = 1452677754,
	%EndReasoningTime = 1453213431,
	%StartReasoningTime = 1453213431,
	%EndReasoningTime = 1453749108,
	%StartReasoningTime = 1453749108,
	% end of dataset: 
	%EndReasoningTime = 1454284786,
	% end of the first week:
	% EndReasoningTime = 1452211200, 
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	%ForgetThreshold = 10, 
	%DynamicGroundingThreshold = 0.8, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% load the patterns:
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled_Cycles.prolog'), %% CHECK IF CYCLES.
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/dynamic/preprocessed_dataset_RTEC_imis_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/static/loadStaticData.prolog'), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, _Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :-
	ExperimentName = europeIMISDeadlines, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Europe-IMIS/experiments/execution log files/log',
	add_info(OutputPathPrefix, '.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	%StartReasoningTime = 1451606400,
	% 1/5 of dataset is 535677 timepoints
	%StartReasoningTime = 1451606400,
	%EndReasoningTime = 1452142077,
	StartReasoningTime = 1452142077,
	EndReasoningTime = 1452677754,
	%StartReasoningTime = 1452677754,
	%EndReasoningTime = 1453213431,
	%StartReasoningTime = 1453213431,
	%EndReasoningTime = 1453749108,
	%StartReasoningTime = 1453749108,
	% end of dataset: 
	%EndReasoningTime = 1454284786,
	% end of the first week:
	% EndReasoningTime = 1452211200, 
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	%ForgetThreshold = 10, 
	%DynamicGroundingThreshold = 0.8, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% load the patterns:
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled_Deadline_Fluents.prolog'), %% CHECK IF CYCLES.
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	% load the dynamic data:
	InputMode = csv(['../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/dynamic/preprocessed_dataset_RTEC_imis_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/static/loadStaticData.prolog'), !.

handleApplication(ExperimentName, Prolog, InputMode, LogFile, ResultsFile, WM, Step, _AgentNo, _Seed, DeadlinesFactor, Delay, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ForgetThreshold, DynamicGroundingThreshold, ClockTick, _SDEBatch) :-
	ExperimentName = europeIMISDelays, !,
	OutputPathPrefix = '../../examples/Maritime-Monitoring/Europe-IMIS/experiments/execution log files/log',
	add_info(OutputPathPrefix, '4.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor, Delay], LogFile),
	add_info(OutputPathPrefix, '-recognised-intervals4.txt', [ExperimentName, Prolog, WM, Step, DeadlinesFactor, Delay], ResultsFile),
	%WM = 86400,
	%Step = 86400, 
	% start of the dataset:
	%StartReasoningTime = 1451606400,
	% 1/5 of dataset is 535677 timepoints
	%StartReasoningTime = 1451606400,
	%EndReasoningTime = 1452142077,
	%StartReasoningTime = 1452142077,
	%EndReasoningTime = 1452677754,
	%StartReasoningTime = 1452677754,
	%EndReasoningTime = 1453213431,
	StartReasoningTime = 1453213431,
	EndReasoningTime = 1453749108,
	%StartReasoningTime = 1453749108,
	% end of dataset: 
	%EndReasoningTime = 1454284786,
	% end of the first week:
	% EndReasoningTime = 1452211200, 
	StreamOrderFlag = unordered,
	DynamicGroundingFlag = dynamicgrounding,
	PreprocessingFlag = nopreprocessing, 
	%ForgetThreshold = 10, 
	%DynamicGroundingThreshold = 0.8, 
	ForgetThreshold = -1, 
	DynamicGroundingThreshold = -1, 
	ClockTick = 1,
	% load the patterns:
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Compiled_Cycles.prolog'), %% CHECK IF CYCLES.
	% these are auxiliary predicates used in the maritime patterns
	consult('../../examples/Maritime-Monitoring/maritime patterns/compare.prolog'),	
	consult('../../examples/Maritime-Monitoring/maritime patterns/Maritime_Patterns_Declarations.prolog'),
	consult('../../src/timeoutTreatment.prolog'),
	% load the dynamic data:
	add_info('../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/dynamic/delayed_files/gamma_delayed', '%.csv', [Delay], '_', InputFile),
	InputMode = csv([InputFile]), 
	%InputMode = csv(['../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/dynamic/preprocessed_dataset_RTEC_imis_critical_nd.csv']),
	% load the static data
	consult('../../examples/Maritime-Monitoring/Europe-IMIS/experiments/data/static/loadStaticData.prolog'), !.

%% Support Predicates %% 
add_info(PrefixStr, SuffixStr, [], FinalStr):-
	atom_concat(PrefixStr, SuffixStr, FinalStr).

add_info(PrefixStr, SuffixStr, [NewInfo|RestInfo], FinalStr):-
	\+number(NewInfo), !,
	atom_concat(PrefixStr, '-', PrefixStr1),
	atom_concat(PrefixStr1, NewInfo, PrefixStr2),
	add_info(PrefixStr2, SuffixStr, RestInfo, FinalStr).

add_info(PrefixStr, SuffixStr, [NewInfo|RestInfo], FinalStr):-
	current_prolog_flag(dialect, yap), !,
    number_atom(NewInfo, NewInfoAtom),
	atom_concat(PrefixStr, '-', PrefixStr1),
	atom_concat(PrefixStr1, NewInfoAtom, PrefixStr2),
	add_info(PrefixStr2, SuffixStr, RestInfo, FinalStr).

add_info(PrefixStr, SuffixStr, [NewInfo|RestInfo], FinalStr):-
    atom_number(NewInfoAtom, NewInfo), % opposite from above.
	atom_concat(PrefixStr, '-', PrefixStr1),
	atom_concat(PrefixStr1, NewInfoAtom, PrefixStr2),
	add_info(PrefixStr2, SuffixStr, RestInfo, FinalStr).

%% Support Predicates %% 
add_info(PrefixStr, SuffixStr, [], _Delimiter, FinalStr):-
	atomic_concat(PrefixStr, SuffixStr, FinalStr).

add_info(PrefixStr, SuffixStr, [NewInfo|RestInfo], Delimiter, FinalStr):-
	\+integer(NewInfo), !,
	atomic_concat(PrefixStr, Delimiter, PrefixStr1),
	atomic_concat(PrefixStr1, NewInfo, PrefixStr2),
	add_info(PrefixStr2, SuffixStr, RestInfo, Delimiter, FinalStr).

add_info(PrefixStr, SuffixStr, [NewInfo|RestInfo], Delimiter, FinalStr):-
	current_prolog_flag(dialect, yap), !,
    number_atom(NewInfo, NewInfoAtom),
	atomic_concat(PrefixStr, Delimiter, PrefixStr1),
	atomic_concat(PrefixStr1, NewInfoAtom, PrefixStr2),
	add_info(PrefixStr2, SuffixStr, RestInfo, Delimiter, FinalStr).

add_info(PrefixStr, SuffixStr, [NewInfo|RestInfo], Delimiter, FinalStr):-
    atom_number(NewInfoAtom, NewInfo), % opposite from above.
	atomic_concat(PrefixStr, Delimiter, PrefixStr1),
	atomic_concat(PrefixStr1, NewInfoAtom, PrefixStr2),
	add_info(PrefixStr2, SuffixStr, RestInfo, Delimiter, FinalStr).

