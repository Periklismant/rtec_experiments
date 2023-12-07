#!/bin/bash

EndTimes='100 200 400 800' # 2000 4000 8000 16000' # '10 20 30'
Window='10'
Step='10'

HVals='0 1 2'
SVals='0 1 2'


for HVal in $HVals; do
	for SVal in $SVals; do
		for EndTime in $EndTimes; do
			echo "Running immuneG experiment: WM=${Window}, Step=${Step} and EndReasoningTime=${EndTime}"
			yap -l continuousQueries.prolog -q -g "immuneG(${Window},${Step},${EndTime},[${HVal},${SVal}]),halt." >> execution-log-immuneG-batch.log
		done
	done
done
