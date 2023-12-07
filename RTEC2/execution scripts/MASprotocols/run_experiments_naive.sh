#!/bin/bash

WM_list='10 20 40 80'
Agent_list='1000' # 8000'
Seed_list='1' # '1 2 3 4 5'
#Step=10 # In these experiments, we use non-overlapping sliding windows.
Dataset_list='netbillBigDGcsv netbillnaivecsv'


for Dataset in $Dataset_list; do
	for WM in $WM_list; do
		for Agent in $Agent_list; do
			for Seed in $Seed_list; do 
	    		echo "Running experiment: ${Dataset} WM=${WM}, Step=${WM} Agents=${Agent} and Seed=${Seed}"
				yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${Dataset},${WM},${WM},${Agent},${Seed}, 1, 0),halt." >> execution-log-${Dataset}.log
			done
		done
	done
done