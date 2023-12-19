#!/bin/bash
EndTimes='400 800 1600 3200'
for EndTime in $EndTimes; do
	swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(immune_g, ${EndTime}), halt."
	HVals='0 1' # 2'
	SVals='0 1 2'
	for HVal in $HVals; do
		for SVal in $SVals; do
			python3 transform_flec_logs.py immune_g ${EndTime} ${HVal} ${SVal}
		done
	done
done
