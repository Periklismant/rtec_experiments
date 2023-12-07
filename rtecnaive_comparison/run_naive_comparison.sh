#!/bin/bash 

rtecnaive_path="../systems/rtecnaive"
rtecfi_path="../systems/rtecfi"

window_sizes=(10 20 40 80)

voting_path="examples/voting"
voting_dataset="dataset/csv/voting-8000-1.csv"

# Voting Experiments
echo "%%% Running Voting Experiments%%%"
for window_size in ${window_sizes[@]}; do
    echo "Window size: ${window_size}"
    cd ${rtecfi_path}/execution\ scripts
    echo "\tRunning RTEC->"
    ./run_rtec.sh --app=voting --window-size=${window_size} --input-providers=../${voting_path}/${voting_dataset}
    cd ../../${rtec_path}/execution\ scripts
    echo "\tRunning RTEC->-naive"
    ./run_rtec.sh --app=voting --window-size=${window_size} --input-providers=../${voting_path}/${voting_dataset}
done 

netbill_dataset="dataset/csv/netbill-8000-1.csv"
netbill_path="examples/netbill"

# Netbill Experiments
echo "%%% Running Netbill Experiments%%%"
for window_size in ${window_sizes[@]}; do
    echo "Window size: ${window_size}
    cd ${rtecfi_path}/execution\ scripts
    echo "\tRunning RTEC->"
    ./run_rtec.sh --app=netbill --window-size=${window_size} --input-providers=../${netbill_path}/${netbill_dataset}
    cd ../../${rtec_path}/execution\ scripts
    echo "\tRunning RTEC->-naive"
    ./run_rtec.sh --app=netbill --window-size=${window_size} --input-providers=../${netbill_path}/${netbill_dataset}
done 

