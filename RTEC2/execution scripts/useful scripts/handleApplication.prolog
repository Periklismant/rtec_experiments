
% handleApplication(+Prolog, +ApplicationName, -InputMode, -LogFile, -WM, -Step, -EndReasoningTime, -StreamOrderFlag, -DynamicGroundingFlag, -PreprocessingFlag, -ClockTick)

% This is a predicate for setting the appropriate parameters for executing an application (see +ApplicationName),
% and consulting the relevant compiled event description, declarations and dataset. 
% Execution parameters:
% InputMode: read input data from CSV files or Prolog files
% LogFile: the file recording the statistics of execution, ResultsFile: the file recording the recognised intervals, WM: working memory size, Step: step size,
% StartReasoningTime and EndReasoningTime specify the range of continuous queries, ie continuous queries take place in (StartReasoningTime, EndReasoningTime]
% the last time-point of the dataset, StreamOrderFlag: 'ordered' or 'unordered' dataset, 
% DynamicGroundingFlag: 'dynamicgrounding' or 'nodynamicgrounding', PreprocessingFlag: 'preprocessing' or 'nopreprocessing', 
% ClockTick: temporal distance between two consecutive time-points, SDEBatch: the input narrative size asserted in a single batch


/*
datasetType/1 is used for logging the recognised intervals in continuousQueries.prolog
datasetType/1 is asserted in this file, and checked in continuousQueries.prolog
datasetType(ground_truth) denotes that the recognitions on the corresponding dataset will be used as ground truth
*/
:- dynamic datasetType/1.

% ----------------------------- Voting ------------------------------

handleApplication(Prolog, votingBig, NAgents, InputMode, LogFile, ResultsFile, WM, Step, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
    WM = 10,
    Step = 10, 
    ( Prolog=yap,
      add_agent_n_wm_step('../examples/voting/experiments/execution log files/log-YAP-voting-big','times.txt', NAgents, WM, Step, LogFile),
      add_agent_n_wm_step('../examples/voting/experiments/execution log files/log-YAP-voting-big','recognised-intervals.txt', NAgents, WM, Step, ResultsFile)
     ;
      Prolog=swi,halt
    ),
    StartReasoningTime = 0,
    EndReasoningTime = 100,
    StreamOrderFlag = unordered,
    DynamicGroundingFlag = nodynamicgrounding,
    PreprocessingFlag = nopreprocessing, 
    ClockTick = 1,
    SDEBatch = 10,
    consult('../examples/voting/patterns/vopr_RTEC_compiled.prolog'),
    consult('../examples/voting/patterns/vopr_RTEC_declarations.prolog'),
    consult('../../src/timeoutTreatment.prolog'),
    consult('../examples/voting/experiments/data/voting-static_generator.prolog'),
    assert_n_agents(NAgents),
    InputMode = dynamic_predicates(['../examples/voting/experiments/data/prolog/voting-data_generator.prolog']), !.

handleApplication(Prolog, votingBigDG, NAgents, InputMode, LogFile, ResultsFile, WM, Step, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
    WM = 10,
    Step = 10, 
    ( Prolog=yap,
        add_agent_n_wm_step('../examples/voting/experiments/execution log files/log-YAP-voting-big-dg','times.txt', NAgents, WM, Step, LogFile),
        add_agent_n_wm_step('../examples/voting/experiments/execution log files/log-YAP-voting-big-dg','recognised-intervals.txt', NAgents, WM, Step, ResultsFile)
     ;
      Prolog=swi,halt
    ),
    StartReasoningTime = 0,
    EndReasoningTime = 100,
    StreamOrderFlag = unordered,
    DynamicGroundingFlag = dynamicgrounding,
    PreprocessingFlag = nopreprocessing, 
    ClockTick = 1,
    SDEBatch = 10,
    consult('../examples/voting/patterns/vopr_RTEC_compiled_dg.prolog'),
    consult('../examples/voting/patterns/vopr_RTEC_declarations_dg.prolog'),
    consult('../../src/timeoutTreatment.prolog'),
    consult('../examples/voting/experiments/data/voting-static_generator.prolog'),
    assert_n_agents(NAgents),
    InputMode = dynamic_predicates(['../examples/voting/experiments/data/prolog/voting-data_generator.prolog']), !.

% --------------------------- Netbill ----------------------------

handleApplication(Prolog, netbillBig, NAgents, InputMode, LogFile, ResultsFile, WM, Step, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
    WM = 10,
    Step = 10,
    (Prolog=yap,
     add_agent_n_wm_step('../examples/negotiation/experiments/execution log files/log-YAP-netbill-big','times.txt', NAgents, WM, Step, LogFile),
     add_agent_n_wm_step('../examples/negotiation/experiments/execution log files/log-YAP-netbill-big','recognised-intervals.txt', NAgents, WM, Step, ResultsFile)
     ;
     Prolog=swi,halt
    ),
    StartReasoningTime = 0,
    EndReasoningTime = 100,
    StreamOrderFlag = unordered,
    DynamicGroundingFlag = nodynamicgrounding,
    PreprocessingFlag = nopreprocessing, 
    ClockTick = 1,
    SDEBatch = 10,
    srandom(0),
    consult('../examples/negotiation/patterns/netbill_RTEC_compiled.prolog'),
    consult('../examples/negotiation/patterns/netbill_RTEC_declarations.prolog'),
    consult('../../src/timeoutTreatment.prolog'),
    consult('../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
    assert_n_agents(NAgents),
    InputMode = dynamic_predicates(['../examples/negotiation/experiments/data/prolog/negotiation-data_generator.prolog']), !.

handleApplication(Prolog, netbillBigDG, NAgents, InputMode, LogFile, ResultsFile, WM, Step, StartReasoningTime, EndReasoningTime, StreamOrderFlag, DynamicGroundingFlag, PreprocessingFlag, ClockTick, SDEBatch) :-
    WM = 10,
    Step = 10,
    (Prolog=yap,
        add_agent_n_wm_step('../examples/negotiation/experiments/execution log files/log-YAP-netbill-big-dg','times.txt', NAgents, WM, Step, LogFile),
     add_agent_n_wm_step('../examples/negotiation/experiments/execution log files/log-YAP-netbill-big-dg','recognised-intervals.txt', NAgents, WM, Step, ResultsFile)
     ;
     Prolog=swi,halt
    ),
    StartReasoningTime = 0,
    EndReasoningTime = 100,
    StreamOrderFlag = unordered,
    DynamicGroundingFlag = dynamicgrounding,
    PreprocessingFlag = nopreprocessing, 
    ClockTick = 1,
    SDEBatch = 10,
    srandom(0),
    consult('../examples/negotiation/patterns/netbill_RTEC_compiled_dg.prolog'),
    consult('../examples/negotiation/patterns/netbill_RTEC_declarations_dg.prolog'),
    consult('../../src/timeoutTreatment.prolog'),
    consult('../examples/negotiation/experiments/data/negotiation-static_generator.prolog'),
    assert_n_agents(NAgents),
    InputMode = dynamic_predicates(['../examples/negotiation/experiments/data/prolog/negotiation-data_generator.prolog']), !.



add_agent_n_wm_step(Str1, Str2, N, WM, Step, StrO):-
    number_atom(N, NAtom),
    number_atom(WM, WMAtom),
    number_atom(Step, StepAtom),
    atom_concat(Str1, '-', Str1a),
    atom_concat(Str1a, NAtom, Str1b),
    atom_concat(Str1b, '-', Str1c),
    atom_concat(Str1c, WMAtom, Str1d),
    atom_concat(Str1d, '-', Str1e),
    atom_concat(Str1e, StepAtom, Str1f),
    atom_concat(Str1f, '-', Str1g),
    atom_concat(Str1g, Str2, StrO).
