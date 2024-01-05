#!/bin/bash 
# This script reproduces the results of Figure 3 of the paper.
# We execute RTEC and RTEC-naive on voting (left diagram of Figure 3) and NetBill.
# For NetBill, we distinguish between two event descriptions
#   netbillp -> the future initiations of FVPs may be postponed (middle diagram of Figure 3), and
#   netbillnop -> the future initiations of FVPs may not be postponed (right diagram of Figure 3). 

Applications=("voting" "netbillnop" "netbillp")
Systems=("rtec" "rtecnaive")
window_sizes=(10 20 40 80)
step=10

echo "%%% Comparing RTEC and RTEC-naive on voting and NetBill (see Figure 3 of the paper). %%%"
for App in ${Applications[@]}; do
    echo -e "\t**Application: ${App}**"
    # Path relative to systems/rtec/execution\ scripts
    dataset="../../../datasets/${App}/naive_comparison_input.csv"
    for system in ${Systems[@]}; do
        echo -e "\t\t- System: ${system}" 
        # Paths relative to this directory 
        system_path="../systems/${system}"
        for window_size in ${window_sizes[@]}; do
            echo -e "\t\t\t* Window size: ${window_size}"
            cd ${system_path}/execution\ scripts
            end_time=$((${window_size}*10))
            ./run_rtec.sh --app=${App} --window-size=${window_size} --step=${step} --input=${dataset} --end-time=${end_time} --background-knowledge=../examples/${App}/dataset/auxiliary/domain_${window_size}.prolog > ../../../logs/${system}/naivecomp_${system}_${App}_win${window_size}.txt 
            awk 'END{print "\t\t\tAverage rule computations: " $11 " with standard deviation: " $14}' ../examples/${App}/results/log-swi-${window_size}-${step}-csv-file-log.txt
            cd ../../../scripts
        done
    done
done
