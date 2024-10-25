#!/bin/bash 

window_sizes=(250 500 1000 2000)
step=250
#end_times=(6800 7000 7200 7400)
#window_sizes=(1000)
end_times=(7500 7750 8250 9250)

echo "%%% Executing RTEC on netbill using windows containing millions of events.%%%"

## TODO: voting_big.csv is too big to pack with the code. We should include and run the script that generates this dataset.

# Path relative to systems/rtec/execution\ scripts
dataset="../../../datasets/netbill/netbill_big.csv"
# Paths relative to this directory 
system_path="../systems/rtec"
for index in ${!window_sizes[@]}; do
    window_size=${window_sizes[$index]}
    end_time=${end_times[$index]}
    echo -e "\t\t\t* Window size: ${window_size}"
    echo -e "\t\t\t* End time: ${end_time}"
    cd ${system_path}/execution\ scripts
    ./run_rtec.sh --app=netbillp --window-size=${window_size} --step=${step} --input=${dataset} --end-time=${end_time} --background-knowledge=../examples/netbillp/dataset/auxiliary/big_domain.prolog > ../../../logs/rtec/netbill_big_rtec_netbill_win${window_size}.txt 
    awk 'END{print "\t\t\tAverage rule computations: " $11 " with standard deviation: " $14}' ../examples/netbillp/results/log-swi-${window_size}-${step}-csv-file-log.txt
    cd ../../../scripts
done
