:-['./load.prolog'].

% Run in YAP: yap -s 0 -h 0 -t 0 -l run.prolog


/*

Note for mass-queries.prolog in the Brest folder:
When the QueryTime exceeds the EndReasoningTime, then the last window becomes
(EndReasoningTime-WM, EndReasoningTime]

In the generic execution script, the last window becomes, in this case,
(QueryTime-WM, EndReasoningTime]

*/

run :-
	nb_setval(dbg,false),
	nb_setval(prf,false),
	nb_setval(sts,true),
	nb_setval(prl,yap),
% window=step=1 day
	performFullER(['data/dynamic/preprocessed_dataset_RTEC_critical_nd.csv'],'execution log files/times.txt','execution log files/results_one_week.txt', 1443650400, 86400, 86400, 1444255200).

% end timepoint for one week: 1444255202
% end timepoint for 6 months: 1459461585
