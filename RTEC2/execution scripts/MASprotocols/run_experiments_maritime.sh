#!/bin/bash

: <<'END'
#WM_list='86400'
#Step=86400
WM_list='7200 14400 28800 57600'
Step=7200
dataset="europeIMIS-critical" # "brest-critical"

rm -f execution-log-brest-critical.log
rm -f execution-log-brest-enriched.log
rm -f scoring-log.log

for WM in $WM_list; do
    echo "Running experiment: ${dataset} WM=${WM}, Step=${Step}"
    yap -l continuousQueries.prolog -q -g "continuousQueries(${dataset},${WM},${Step}, 0, 0, 0),halt." >> execution-log-${dataset}-critical.log
    #echo "Running experiment: brest-enriched WM=${WM}, Step=${Step}"
    #yap -l continuousQueries.prolog -q -g "continuousQueries(brest-enriched,${WM},${Step}),halt." >> execution-log-brest-enriched.log
    #COMPARE INTERVALS BELOW
    #GTFile=../../examples/Maritime-Monitoring/Brest/experiments/execution\ log\ files/log-Brest-enriched-yap-${WM}-${Step}-recognised-intervals-enriched-yap.txt
    #PFile=../../examples/Maritime-Monitoring/Brest/experiments/execution\ log\ files/log-Brest-critical-yap-${WM}-${Step}-recognised-intervals-critical-yap.txt
    #F1File=../../examples/Maritime-Monitoring/Brest/experiments/execution\ log\ files/log-Brest-critical-yap-${WM}-${Step}-f1-score.txt

    #./f1-score-computation-args.sh "$GTFile" "$PFile" "$F1File" >> scoring-log.log
done

END

WM_list='7200 14400 28800 57600'
Step=7200
dataset='europeIMISDeadlines' #"europeIMIS-critical" # "brest-critical"
DeadlinesFactor_list='1'


for WM in $WM_list; do
	for DeadlinesFactor in $DeadlinesFactor_list; do
		echo "Running experiment: ${dataset} WM=${WM}, Step=${Step} DeadlinesFactor=${DeadlinesFactor}"
    	yap -l continuousQueries.prolog -q -g "continuousQueries(${dataset},${WM},${Step}, 0, 0, ${DeadlinesFactor}, 0),halt." >> execution-log-${dataset}.log
 	done
done


: <<'END'
datasetIMIS='europeIMISCritical'
for WM in $WM_list; do
    for DeadlinesFactor in $DeadlinesFactor_list; do
        echo "Running experiment: ${datasetIMIS} WM=${WM}, Step=${Step} DeadlinesFactor=${DeadlinesFactor}"
        yap -l continuousQueries.prolog -q -g "continuousQueries(${datasetIMIS},${WM},${Step}, 0, 0, ${DeadlinesFactor}, 0),halt." >> execution-log-${datasetIMIS}.log
    done
done
END