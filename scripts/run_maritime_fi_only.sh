#!/bin/bash 
# This script reproduces the results of Figure 6 (middle) of the paper.
# We execute RTEC on the maritime dataset concerning Brest, France.
# The event description contains FVPs with future initiations.

wget -O ../datasets/maritime/brest_dataset.zip "https://owncloud.skel.iit.demokritos.gr:443/index.php/s/67dJSuymyIw1Mng/download"
unzip -o ../datasets/maritime/brest_dataset.zip -d ../datasets/maritime/
rm ../datasets/maritime/brest_dataset.zip

WindowSizes=(7200 14400 28800 57600)
cd ../systems/rtec/execution\ scripts

echo "%%% Executing RTEC on the maritime domain with future initiations (see Figure 6 (middle) of the paper).%%%"
for window_size in ${WindowSizes[@]}; do
    echo -e "\tWindow size: ${window_size}"
    ./run_rtec.sh --app=maritime_fi_only --window-size=${window_size} --step=7200 > ../../../logs/rtec/maritime_fi_only_win${window_size}.txt
    awk 'NR==3{print "\tAverage reasoning time: " $6} NR==4{print "\tStandard deviation: " $6}' ../examples/maritime_fi_only/results/log-swi-${window_size}-7200-csv-file-log.txt
done
cd ../../../scripts
rm ../datasets/maritime/brest_critical.csv
