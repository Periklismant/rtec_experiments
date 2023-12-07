#!/bin/bash

### Run FL_EC.prolog ###

EndTimes_list='250 500 1000 2000'
Applications_list='phage_g'

for App in $Applications_list; do
	for EndTime in $EndTimes_list; do
		LogFile="FLEC-logs-${App}-${EndTime}.txt"
		yap -l FL_EC.prolog -q -g "time(query(${App}, ${EndTime}, '${LogFile}')),halt."
		python3.8 transform_flec_logs.py ${LogFile} ${LogFile}
	done
done

### Compare Recognitions with the corresponding results of RTEC ###

#for EndTime in $EndTimes_list; do
#	FLECFile="FLEC-logs-${EndTime}.txt"
#	RTECFile="results/log-fdl-yap-${EndTime}-${EndTime}-${EndTime}-recognised-intervals.txt"
#	diff <(sort $FLECFile) <(sort $RTECFile)
#done