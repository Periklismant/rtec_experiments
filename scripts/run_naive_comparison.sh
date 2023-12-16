#!/bin/bash 


#Applications=("voting" "netbillnop" "netbillp")
Applications=("netbillnop")
Systems=("rtec" "rtecnaive")
#Systems=("rtecnaive")
#window_sizes=(10 20 40 80)
window_sizes=(20 40 80)

for App in ${Applications[@]}; do
	echo "%%% Running ${App} experiments %%%"
	# Path relative to systems/rtec/execution\ scripts
	dataset="../../../datasets/${App}/naive_comparison_input.csv"
	for system in ${Systems[@]}; do
		echo "- System: ${system}" 
		# Paths relative to this directory 
		system_path="../systems/${system}"
		for window_size in ${window_sizes[@]}; do
			echo -e "\t* Window size: ${window_size}"
			cd ${system_path}/execution\ scripts
            end_time=$((${window_size}*5))
			./run_rtec.sh --app=${App} --window-size=${window_size} --step=${window_size} --input=${dataset} > ../../../logs/naivecomp_${system}_${App}_win${window_size}.txt --end-time=${end_time}
			cd ../../../scripts
		done
	done
done
