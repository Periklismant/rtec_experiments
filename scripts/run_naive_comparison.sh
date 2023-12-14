#!/bin/bash 


#Applications=("voting" "netbillnop" "netbillp")
Applications=("netbillp")
Systems=("rtec" "rtecnaive")
#Systems=("rtecnaive")
window_sizes=(10)


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
			./run_rtec.sh --app=${App} --window-size=${window_size} --step=10 --input=${dataset} > ../../../logs/naivecomp_${system}_${App}_win${window_size}.txt --end-time=30
			cd ../../../scripts
		done
	done
done
