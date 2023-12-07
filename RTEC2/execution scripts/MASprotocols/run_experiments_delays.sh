#!/bin/bash

## First number is WM
## 40 40 problematic & 40 10 ##Got intervals with SWIPL.
## 20 OK 
## 80 OK
## 10 OK

WM_list='80'
Agent_list='8000' #'1000 2000 4000 8000'
Delay_list='5 10'
Step=10
Seed=1

#DatasetGround="netbillBigDGcsv"
DatasetDelays="netbillDelays"

#DatasetGround="votingBigDGcsv"
#DatasetDelays="votingDelays"


#rm execution-log-${DatasetGround}.log
rm execution-log-${DatasetDelays}.log

#for WM in $WM_list; do
#	for Agent in $Agent_list; do
#		echo "Running experiment: ${DatasetGround} with WM=${WM} and Agents=${Agent}"
#		yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${DatasetGround},${WM},${Step},${Agent},${Seed}, 1, 0),halt." >> execution-log-${DatasetGround}.log
#	done
#done

for WM in $WM_list; do
	for Agent in $Agent_list; do
		for Delay in $Delay_list; do
			echo "Running experiment: ${DatasetDelays} with WM=${WM}, Agents=${Agent} and Delay=${Delay}"
			yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${DatasetDelays},${WM},${Step},${Agent},${Seed}, 1, ${Delay}),halt." >> execution-log-${DatasetDelays}.log
		done
	done
done

