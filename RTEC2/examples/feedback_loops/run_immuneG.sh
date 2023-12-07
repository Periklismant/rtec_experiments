#!/bin/bash

EndTimes='100 200 400 800'

for EndTime in $EndTimes; do
	yap -l FL_EC.prolog -q -g "runQueryAllInits(immune_g, ${EndTime}), halt."

	HVals='0 1 2'
	SVals='0 1 2'

	for HVal in $HVals; do
		for SVal in $SVals; do
			python3 transform_flec_logs.py immune_g ${EndTime} ${HVal} ${SVal}
		done
	done
done

FILES="FLECresults/*"
for f in $FILES; do
	X="$(basename "$f")"
	echo $X
	diff <(sort "results/$X") <(sort "FLECresults/$X")
done