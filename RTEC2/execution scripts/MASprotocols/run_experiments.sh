#!/bin/bash
# Adjust the paramaters before the `for' loop to run the desired experiments.
# This script will run RTEC for every possible parameter combination.
# Type a list of values for 'list' parameters and a single value for the rest.
# ${Dataset} should be an ApplicationName present in the `handleApplicationMAS.prolog' file.  

: <<'END'
WM_list='10 20 30' # '10 20 30'
Agent_list='1000 2000 4000 8000' #'1000 2000 4000 8000'
Seed_list='1 2 3 4 5' # '1 2 3 4 5'
Step=10
Dataset=votingBigDGcsv

for WM in $WM_list; do
	for Agent in $Agent_list; do
		for Seed in $Seed_list; do 
    		echo "Running experiment: ${Dataset} WM=${WM}, Step=${Step} Agents=${Agent} and Seed=${Seed}"
			yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${Dataset},${WM},${Step},${Agent},${Seed}),halt." >> execution-log-${Dataset}.log
		done
	done
done
END

: <<'END'
WM_list='10 30 50' # '10 20 30'
#Agent_list='1000 2000 4000 8000' #'1000 2000 4000 8000'
Seed_list='1 2 3 4 5'
DeadlinesFactor_list='1' #'1 2 4'
Agent=4000
Step=10
Dataset=votingBigDGcsv

for WM in $WM_list; do
	for DeadlinesFactor in $DeadlinesFactor_list; do
		for Seed in $Seed_list; do 
    		echo "Running experiment: ${Dataset} WM=${WM}, Step=${Step}, Agents=${Agent}, Seed=${Seed} and DeadlinesFactor=${DeadlinesFactor}"
			yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${Dataset},${WM},${Step},${Agent},${Seed},${DeadlinesFactor}),halt." >> execution-log-${Dataset}.log
		done
	done
done
END

WM_list='10 20 40 80' # '10 20 30'
Agent_list='8000'  #'2000 4000' # 8000'
Seed_list='1' # '1 2 3 4 5'
Step=10
Dataset_list='netbillBigDGcsv'


for Dataset in $Dataset_list; do
	for WM in $WM_list; do
		for Agent in $Agent_list; do
			for Seed in $Seed_list; do 
	    		echo "Running experiment: ${Dataset} WM=${WM}, Step=${Step} Agents=${Agent} and Seed=${Seed}"
				yap -s 0 -h 0 -t 0 -l continuousQueries.prolog -q -g "continuousQueries(${Dataset},${WM},${Step},${Agent},${Seed}, 1, 0),halt." >> execution-log-${Dataset}.log
			done
		done
	done
done
