#!/bin/bash 

wget -O ../datasets/voting/voting_big.zip "https://owncloud.skel.iit.demokritos.gr:443/index.php/s/Da1MKlt9rIvQbxl/download"
unzip -o ../datasets/voting/voting_big.zip -d ../datasets/voting/
rm ../datasets/voting/voting_big.zip

#window_sizes=(75 150 300 600)
#step=75
#end_times=(2250 2325 2475 2775)
window_sizes=(250 500 1000 2000)
step=250
end_times=(7500 7750 8250 9250)

echo "%%% Executing RTEC on voting using windows containing millions of events.%%%"

## TODO: voting_big.csv is too big to pack with the code. We should include and run the script that generates this dataset.

# Path relative to systems/rtec/execution\ scripts
dataset="../../../datasets/voting/voting_big.csv"
# Paths relative to this directory 
system_path="../systems/rtec"
for index in ${!window_sizes[@]}; do
    window_size=${window_sizes[$index]}
    end_time=${end_times[$index]}
    echo -e "\t\t\t* Window size: ${window_size}"
    echo -e "\t\t\t* End time: ${end_time}"
    cd ${system_path}/execution\ scripts
    ./run_rtec.sh --app=voting --window-size=${window_size} --step=${step} --input=${dataset} --end-time=${end_time} --background-knowledge=../examples/voting/dataset/auxiliary/big_domain.prolog > ../../../logs/rtec/voting_big_rtec_voting_win${window_size}.txt 
    awk 'END{print "\t\t\tAverage rule computations: " $11 " with standard deviation: " $14}' ../examples/voting/results/log-swi-${window_size}-${step}-csv-file-log.txt
    cd ../../../scripts
done
