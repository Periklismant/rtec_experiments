#!/bin/bash 
# This script reproduces the results of Figure 6 (right) of the paper.
# We execute RTEC on the maritime dataset concerning all european seas

WindowSizes=(7200 14400 28800 57600)
cd ../systems/rtec/execution\ scripts

echo "%%% Executing RTEC on the maritime dataset of all European seas (see Figure 6 (right) of the paper).%%%"
for window_size in ${WindowSizes[@]}; do
    echo -e "\tWindow size: ${window_size}"
    ./run_rtec.sh --app=maritime --window-size=${window_size} --step=7200 > ../../../logs/rtec/maritime_europe_win${window_size}.txt
    awk 'NR==3{print "\tAverage reasoning time: " $6} NR==4{print "\tStandard deviation: " $6}' ../examples/maritime/results/log-swi-${window_size}-7200-csv-file-log.txt
done
cd ../../../scripts
