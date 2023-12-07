#!/bin/bash

WM_list='14400' #'7200 14400 28800 57600'
#Agent_list='1000 2000 4000 8000'
Delay_list='40' #'5 10 20 40 80'
Step=7200
#Seed=1
DatasetGround="brestCritical"
DatasetDelays="brestDelays"

#DatasetGround="europeIMIS-Critical"
#DatasetDelays="europeIMISDelays"

#rm execution-log-${DatasetGround}.log
rm execution-log-${DatasetDelays}.log

#for WM in $WM_list; do
#	echo "Running experiment: ${DatasetGround} with WM=${WM}"
#	yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${DatasetGround},${WM},${Step},0, 0, 1, 0),halt." >> execution-log-${DatasetGround}.log
#done

for WM in $WM_list; do
	for Delay in $Delay_list; do
		echo "Running experiment: ${DatasetDelays} with WM=${WM} and Delay=${Delay}"
		yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${DatasetDelays},${WM},${Step}, 0, 0, 1, ${Delay}),halt." >> execution-log-${DatasetDelays}.log
	done	
done

