#!/bin/bash

WM_list='86400'
#WM_list='7200 14400 28800 57600'
Step=86400

rm -f execution-log-brest-critical.log
rm -f execution-log-brest-enriched.log
rm -f scoring-log.log

for WM in $WM_list; do
    echo "Running experiment: brest-critical WM=${WM}, Step=${Step}"
    yap -l continuousQueries.prolog -q -g "continuousQueries(brest-critical,${WM},${Step}),halt." >> execution-log-brest-critical.log
    #echo "Running experiment: brest-enriched WM=${WM}, Step=${Step}"
    #yap -l continuousQueries.prolog -q -g "continuousQueries(brest-enriched,${WM},${Step}),halt." >> execution-log-brest-enriched.log
    #COMPARE INTERVALS BELOW
    #GTFile=../../examples/Maritime-Monitoring/Brest/experiments/execution\ log\ files/log-Brest-enriched-yap-${WM}-${Step}-recognised-intervals-enriched-yap.txt
    #PFile=../../examples/Maritime-Monitoring/Brest/experiments/execution\ log\ files/log-Brest-critical-yap-${WM}-${Step}-recognised-intervals-critical-yap.txt
    #F1File=../../examples/Maritime-Monitoring/Brest/experiments/execution\ log\ files/log-Brest-critical-yap-${WM}-${Step}-f1-score.txt

    #./f1-score-computation-args.sh "$GTFile" "$PFile" "$F1File" >> scoring-log.log
done
