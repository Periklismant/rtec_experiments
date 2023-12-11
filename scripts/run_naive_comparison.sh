#!/bin/bash 

# Paths relative to this directory 
rtecnaive_path="../systems/rtecnaive"
rtec_path="../systems/rtec"

window_sizes=(10 20 40 80)

# Path relative to systems/rtec/execution\ scripts
voting_dataset="../../../datasets/voting/naive_comparison_input.csv"

# Voting Experiments
echo "%%% Running Voting Experiments %%%"
for window_size in ${window_sizes[@]}; do
    echo "Window size: ${window_size}"
    cd ${rtec_path}/execution\ scripts

    echo -e "\tRunning RTEC->"
    ./run_rtec.sh --app=voting --window-size=${window_size} --input=${voting_dataset} > ../../../logs/naivecomp_rtec_voting_win${window_size}.txt

    cd ../../${rtec_path}/execution\ scripts
    echo -e "\tRunning RTEC->-naive"
    ./run_rtec.sh --app=voting --window-size=${window_size} --input=${voting_dataset} > ../../../logs/naivecomp_rtecnaive_voting_win${window_size}.txt

done 

cd ../../scripts

# Path relative to systems/rtec/execution\ scripts
netbill_dataset="../../../datasets/netbill/naive_comparison_input.csv"

# Netbill Experiments
echo "%%% Running Netbill Experiments %%%"
for window_size in ${window_sizes[@]}; do
    echo "Window size: ${window_size}"
    cd ${rtec_path}/execution\ scripts
    echo -e "\tRunning RTEC->"
    ./run_rtec.sh --app=netbill --window-size=${window_size} --input=${netbill_dataset} > ../logs/naivecomp_rtec_voting_win${window_size}.txt
    cd ../../${rtec_path}/execution\ scripts
    echo -e "\tRunning RTEC->-naive"
    ./run_rtec.sh --app=netbill --window-size=${window_size} --input=${netbill_dataset} > ../logs/naivecomp_rtecnaive_netbill_win${window_size}.txt
done 

