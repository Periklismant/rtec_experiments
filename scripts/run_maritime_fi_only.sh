#!/bin/bash 
# This script reproduces the results of Figure 6 (middle) of the paper.
# We execute RTEC on the maritime dataset concerning Brest, France.
# The event description contains FVPs with future initiations.

WindowSizes=(7200 14400 28800 57600)
cd ../systems/rtec/execution\ scripts
for window_size in ${WindowSizes[@]}; do
    echo "Window size: ${window_size}"
    ./run_rtec.sh --app=maritime_fi_only --window-size=${window_size} --step=7200 > ../../../logs/rtec/maritime_fi_only_win${window_size}.txt
done
cd ../../../scripts
