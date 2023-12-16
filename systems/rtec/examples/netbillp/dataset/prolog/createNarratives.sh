#!/bin/bash

Agent_List='100' #'1000 2000 4000 8000'
Seed_List='1' #'1 2 3 4 5'
Start=0
End=1000


for Agent in $Agent_List; do
	for Seed in $Seed_List; do
		echo "Creating Narrative for ${Agent} agents and Seed: ${Seed}"
		swipl -l quote_csv_data_generator.prolog -q -g "createNarrative(${Start},${End},${Agent},${Seed}),halt." >> execution-log-${Dataset}.log
	done
done
