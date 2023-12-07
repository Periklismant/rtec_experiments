#!/bin/bash

WM_list=(10 30 50)
Step=10
#Agent_list=(1000 2000 4000 8000)
Agent=4000
Seed_list=(1 2 3 4 5)
DeadlineFactors_list=(1)
FolderName="$1/" #''
WriteFile="./${FolderName}allmetrics.txt"

for WM in "${WM_list[@]}"; do
	#for Agent in "${Agent_list[@]}"; do
	for DeadlineFactor in "${DeadlineFactors_list[@]}"; do
		echo "For WM=${WM} Agents=${Agent}  DeadlineFactor=${DeadlineFactor}" #>>  WriteFile
		AvgTime=0
		AvgInput=0
		AvgOutput=0
		AvgForget=0
		AvgDG=0
		AvgSF=0
		AvgSD=0
		for Seed in "${Seed_list[@]}"; do
			FilePath="./${FolderName}log-YAP-votingBigDGcsv-${WM}-${Step}-${Agent}-${Seed}-${DeadlineFactor}.txt"
			while IFS= read -r line
			do
				if [[ $line == *"Recognition Time average"* ]]; then
					RecTimeTemp=$(grep -Eo '([^.][0-9]+)' <<< $line)
					RecTime=$(head -n1 <<< $RecTimeTemp)
					echo -e "\tSeed ${Seed} Rectime=${RecTime}"
				fi
				if [[ $line == *"Input Entities average"* ]]; then
					InpEntTemp=$(grep -Eo '([^.][0-9]+)' <<< $line)
					InpEnt=$(head -n1 <<< $InpEntTemp)
					echo -e "\tSeed ${Seed} InpEnt=${InpEnt}"
				fi
				if [[ $line == *"Output Entities (average number of intervals)"* ]]; then
					OutEntTemp=$(grep -Eo '([^.][0-9]+)' <<< $line)
					OutEnt=$(head -n1 <<< $OutEntTemp)
					echo -e "\tSeed ${Seed} OutEnt=${OutEnt}"
				fi
				if [[ $line == *"Forget times"* ]]; then
					ForgetTemp=$(grep -Eo '[0-9]+$' <<< $line)
					ForgetTime=$(head -n1 <<< $ForgetTemp)
					echo -e "\tSeed ${Seed} Forget Time=${ForgetTime}"
				fi
				if [[ $line == *"Dynamic Grounding times"* ]]; then
					DGTemp=$(grep -Eo '[0-9]+$' <<< $line)
					DGTime=$(head -n1 <<< $DGTemp)
					echo -e "\tSeed ${Seed} Dynamic Grounding Time=${DGTime}"
				fi
				if [[ $line == *"Process Simple Fluents times"* ]]; then
					SFTemp=$(grep -Eo '[0-9]+$' <<< $line)
					SFTime=$(head -n1 <<< $SFTemp)
					echo -e "\tSeed ${Seed} SF Times=${SFTime}"
				fi
				if [[ $line == *"Process SD Fluents times"* ]]; then
					SDFTemp=$(grep -Eo '[0-9]+$' <<< $line)
					SDFTime=$(head -n1 <<< $SDFTemp)
					echo -e "\tSeed ${Seed} SDF Times=${SDFTime}"
				fi
				if [[ $line == *"Compute deadline initiations times"* ]]; then
					DITemp=$(grep -Eo '[0-9]+$' <<< $line)
					DITime=$(head -n1 <<< $DITemp)
					echo -e "\tSeed ${Seed} DI Times=${DITime}"
				fi
				if [[ $line == *"Deadlines times"* ]]; then
					DeadlinesTemp=$(grep -Eo '[0-9]+$' <<< $line)
					DeadlinesTime=$(head -n1 <<< $DeadlinesTemp)
					echo -e "\tSeed ${Seed} Deadlines Times=${DeadlinesTime}"
				fi
			done < "$FilePath"
			AvgTime=$((AvgTime+RecTime))
			AvgInput=$((AvgInput+InpEnt))
			AvgOutput=$((AvgOutput+OutEnt))
			AvgForget=$((AvgForget+ForgetTime))
			AvgDG=$((AvgDG+DGTime))
			AvgSF=$((AvgSF+SFTime))
			AvgSD=$((AvgSD+SDFTime))
			AvgDeadlines=$((AvgDeadlines+DeadlinesTime*2+DITime))
		done
		#echo "RecTimeSum=${AvgTime}"
		#echo "InputEntSum=${AvgInput}"
		#echo "OutputEntSum=${AvgOutput}"

		AvgTime=$((AvgTime/${#Seed_list[@]}))
		#echo "AvgTime=${AvgTime}" >> WriteFile
		AvgInput=$((AvgInput/${#Seed_list[@]}))
		#echo "AvgInput=${AvgInput}" >> WriteFile
		AvgOutput=$((AvgOutput/${#Seed_list[@]}))
		#echo "AvgOutput=${AvgOutput}" >> WriteFile
		AvgForget=$((AvgForget/${#Seed_list[@]}))
		AvgDG=$((AvgDG/${#Seed_list[@]}))
		AvgSF=$((AvgSF/${#Seed_list[@]}))
		AvgSD=$((AvgSD/${#Seed_list[@]}))
		AvgDeadlines=$((AvgDeadlines/${#Seed_list[@]}))
		echo "WM=${WM}, Agents=${Agent}, DeadlineFactor=${DeadlineFactor}: Time=${AvgTime}, Input=${AvgInput}, Output=${AvgOutput}, ForgetTime=${AvgForget}, DGTime=${AvgDG}, SFTime=${AvgSF}, SDFTime=${AvgSD}, DeadlinesTime=${AvgDeadlines}" >> ${WriteFile}
		#echo "WM=${WM}, Agents=${Agent}, DeadlineFactor=${DeadlineFactor}: Time=${AvgTime}, Input=${AvgInput}, Output=${AvgOutput}" >> ${WriteFile}
	done
done
