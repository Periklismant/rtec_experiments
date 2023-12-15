#!/bin/bash

#EndTimes='100 200 400 800'
EndTimes='3200'

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

: ' Compare results 
RTEC_RESULTS="rtec_results"
GKLEC_RESULTS="gklec_results"

FILES="FLECresults/*"
for f in $FILES; do
	X="$(basename "$f")"
	echo $X
	diff <(sort "${RTEC_RESULTS}/$X") <(sort "${GKLEC_RESULTS}/$X")
done
'
