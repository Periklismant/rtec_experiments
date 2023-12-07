#!/bin/bash

EndTimes='50 100 200 400 800' # 2000 4000 8000 16000' # '10 20 30'

HVals='0 1 2'
SVals='0 1 2'


for HVal in $HVals; do
	for SVal in $SVals; do
		for EndTime in $EndTimes; do
			echo "Running immuneG experiment: WM=${EndTime}, Step=${EndTime} and EndReasoningTime=${EndTime}"
			yap -l continuousQueries.prolog -q -g "immuneG(${EndTime},${EndTime},${EndTime},[${HVal},${SVal}]),halt." >> execution-log-immuneG-batch.log
		done
	done
done