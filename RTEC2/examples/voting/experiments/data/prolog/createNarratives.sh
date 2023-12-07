#!/bin/bash

Agent_List='8000' #'1000 2000 4000 8000'
Seed_List='1' #'1 2 3 4 5'
Start=0
End=100


for Agent in $Agent_List; do
	for Seed in $Seed_List; do
		echo "Creating Narrative for ${Agent} agents, End: ${End} and Seed: ${Seed}"
		yap -s 0 -h 0 -t 0 -l voting-csv_data_generator.prolog -q -g "createNarrative(${Start},${End},${Agent},${Seed}),halt." >> execution-log-${Dataset}.log
	done
done
