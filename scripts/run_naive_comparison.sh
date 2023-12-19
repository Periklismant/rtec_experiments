#!/bin/bash 

Applications=("voting" "netbillnop" "netbillp")
Systems=("rtec" "rtecnaive")
window_sizes=(10 20 40 80)

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
            # Run 
            end_time=$((${window_size}*10))
            ./run_rtec.sh --app=${App} --window-size=${window_size} --step=10 --input=${dataset} --end-time=${end_time} --background-knowledge=../examples/${App}/dataset/auxiliary/domain_${window_size}.prolog > ../../../logs/naivecomp_${system}_${App}_win${window_size}.txt 
            cd ../../../scripts
        done
    done
done
