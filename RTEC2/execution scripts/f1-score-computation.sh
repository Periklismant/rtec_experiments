#!/bin/bash

WM_list='80'
Agent_list='8000' #2000 4000 8000'
Delay_list='20 40 80'
Step=10
Seed=1
EndReasoningTime=1000

Application="negotiation"
GroundDataset="netbillBigDGcsv"
DelaysDataset="netbillDelays"

#Application="voting"
#GroundDataset="votingBigDGcsv"
#DelaysDataset="votingDelays"

Path="../examples/${Application}/experiments/execution log files"
GroundPath="${Path}/log-${GroundDataset}-yap"
DelaysPath="${Path}/log-${DelaysDataset}-yap"

ResultPath="../examples/${Application}/experiments/statistics"
ResultsFilePrefix="${ResultPath}/metrics-"

for WM in $WM_list; do
	for Agent in $Agent_list; do
		for Delay in $Delay_list; do
			GroundFile="${GroundPath}-${WM}-${Step}-${Agent}-1-1-${EndReasoningTime}-recognised-intervals.txt"
			DelaysFile="${DelaysPath}-${WM}-${Step}-${Delay}-recognised-intervals.txt"
			ResultFile="${ResultsFilePrefix}-${WM}-${Step}-${Agent}-${Delay}.txt"
			if [ ! -f "${GroundFile}" ]; then
    			echo "${GroundFile} does not exist."
    		else
    			echo "${GroundFile} OK."
    		fi
    		if [ ! -f "${DelaysFile}" ]; then
    			echo "${DelaysFile} does not exist."
    		else
    			echo "${DelaysFile} OK."
    		fi

			yap -l f1-score-computation.prolog -q -g "compare_all_events('${GroundFile}', '${DelaysFile}', '${ResultFile}'),halt." 
		done
	done
done