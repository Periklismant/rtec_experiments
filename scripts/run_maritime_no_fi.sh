#!/bin/bash 
# This script reproduces the results of Figure 6 (left) of the paper.
# We execute RTEC and RTEC(without fi) on the maritime dataset concerning Brest, France.
# The event description contains FVPs without future initiations.

WindowSizes=(7200 14400 28800 57600)
Systems=("rtec" "rtecnofi")
for system in ${Systems[@]}; do
    echo "System: ${system}"
    cd ../systems/${system}/execution\ scripts
    for window_size in ${WindowSizes[@]}; do
        echo "Window size: ${window_size}"
        ./run_rtec.sh --app=maritime_no_fi --window-size=${window_size} --step=7200 > ../../../logs/${system}/maritime_no_fi_win${window_size}.txt
    done
    cd ../../../scripts
done
