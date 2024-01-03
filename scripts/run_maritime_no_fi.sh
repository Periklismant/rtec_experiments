#!/bin/bash 
# This script reproduces the results of Figure 6 (left) of the paper.
# We execute RTEC and RTEC(without fi) on the maritime dataset concerning Brest, France.
# The event description contains FVPs without future initiations.

WindowSizes=(7200 14400 28800 57600)
Systems=("rtec" "rtecnofi")

echo "%%% Comparing RTEC and RTEC-without-fi on the maritime domain without future initiations (see Figure 6 (left) of the paper).%%%"
for system in ${Systems[@]}; do
    echo -e "\tSystem: ${system}"
    cd ../systems/${system}/execution\ scripts
    for window_size in ${WindowSizes[@]}; do
        echo -e "\t\tWindow size: ${window_size}"
        ./run_rtec.sh --app=maritime_no_fi --window-size=${window_size} --step=7200 > ../../../logs/${system}/maritime_no_fi_win${window_size}.txt
        awk 'NR==3{print "\t\tAverage reasoning time: " $6} NR==4{print "\t\tStandard deviation: " $6}' ../examples/maritime_no_fi/results/log-swi-${window_size}-7200-csv-file-log.txt
    done
    cd ../../../scripts
done
