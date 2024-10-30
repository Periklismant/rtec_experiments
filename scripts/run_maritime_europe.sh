#!/bin/bash 
# This script reproduces the results of Figure 6 (right) of the paper.
# We execute RTEC on the maritime dataset concerning all european seas

wget -O ../datasets/maritime/imis_dataset.zip "https://owncloud.skel.iit.demokritos.gr:443/index.php/s/REYgngK1wN45g1C/download"
unzip -o ../datasets/maritime/imis_dataset.zip -d ../datasets/maritime/
rm ../datasets/maritime/imis_dataset.zip

WindowSizes=(7200 14400 28800 57600)
step=7200

cd ../systems/rtec/execution\ scripts

echo "%%% Executing RTEC on the maritime dataset of all European seas (see Figure 6 (right) of the paper).%%%"
for window_size in ${WindowSizes[@]}; do
    echo -e "\tWindow size: ${window_size}"
    ./run_rtec.sh --app=maritime --window-size=${window_size} --step=${step} > ../../../logs/rtec/maritime_europe_win${window_size}.txt
    awk 'NR==3{print "\tAverage reasoning time: " $6} NR==4{print "\tStandard deviation: " $6}' ../examples/maritime/results/log-swi-${window_size}-${step}-csv-file-log.txt
done
cd ../../../scripts
rm ../datasets/maritime/imis_critical.csv
