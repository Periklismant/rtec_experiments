#!/bin/bash
EndTimes='300 600 1200 2400'
for EndTime in $EndTimes; do
	swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(phage_g, ${EndTime}), halt."
	CIVals='0 1 2'
	CroVals='0 1 2 3'
	CIIVals='0 1'
	NVals='0 1'
	for CIVal in $CIVals; do
		for CroVal in $CroVals; do
			for CIIVal in $CIIVals; do
				for NVal in $NVals; do
					python3 transform_flec_logs.py phage_g ${EndTime} ${CIVal} ${CroVal} ${CIIVal} ${NVal}
				done
			done
		done
	done
done

