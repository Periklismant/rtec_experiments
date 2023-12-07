#!/bin/bash

EndTimes='100 200 400 800' # 2000 4000 8000 16000' # '10 20 30'

CIVals='0 1 2'
CroVals='0 1 2 3'
CIIVals='0 1'
NVals='0 1'



for CIVal in $CIVals; do
	for CroVal in $CroVals; do
		for CIIVal in $CIIVals; do
			for NVal in $NVals; do
				for EndTime in $EndTimes; do
					Window=${EndTime}
					echo "Running phageG experiment: WM=${EndTime}, Step=${EndTime} and EndReasoningTime=${EndTime}"
					yap -l continuousQueries.prolog -q -g "phageG(${EndTime},${EndTime},${EndTime},[${CIVal},${CroVal},${CIIVal},${NVal}]),halt." >> execution-log-phageG-batch.log
				done
			done
		done
	done
done