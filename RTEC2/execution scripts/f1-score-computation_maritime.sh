#!/bin/bash

WM_list='14400' #'7200 14400 28800 57600'
Delay_list='40' #'5 10 20 40 80'
Step=7200

Application="Maritime-Monitoring/Brest"
GroundDataset="brestCritical"
DelaysDataset="brestDelays"

Path="../examples/${Application}/experiments/execution log files"
GroundPath="${Path}/log-${GroundDataset}-yap"
DelaysPath="${Path}/log-${DelaysDataset}-yap"

ResultPath="../examples/${Application}/experiments/statistics"
ResultsFilePrefix="${ResultPath}/metrics-"

for WM in $WM_list; do
	for Delay in $Delay_list; do
		GroundFile="${GroundPath}-${WM}-${Step}-1-recognised-intervals.txt"
		DelaysFile="${DelaysPath}-${WM}-${Step}-1-${Delay}-recognised-intervals.txt"
		ResultFile="${ResultsFilePrefix}-${WM}-${Step}-${Delay}.txt"
		if [ ! -f "${GroundFile}" ]; then
			echo "${GroundFile} does not exist."
		else
			echo "${GroundFile} does exist."
		fi
		if [ ! -f "${DelaysFile}" ]; then
			echo "${DelaysFile} does not exist."
		else
			echo "${DelaysFile} does exist."
		fi

		yap -l f1-score-computation.prolog -q -g "compare_all_events('${GroundFile}', '${DelaysFile}', '${ResultFile}'),halt." 
	done
done

