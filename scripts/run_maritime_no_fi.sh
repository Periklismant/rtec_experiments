#!/bin/bash 
# This script reproduces the results of Figure 6 (left) of the paper.
# We execute RTEC and RTEC(without fi) on the maritime dataset concerning Brest, France.
# The event description contains FVPs without future initiations.

wget -O ../datasets/maritime/brest_dataset.zip "https://owncloud.skel.iit.demokritos.gr:443/index.php/s/67dJSuymyIw1Mng/download"
unzip -o ../datasets/maritime/brest_dataset.zip -d ../datasets/maritime/
rm ../datasets/maritime/brest_dataset.zip

#WindowSizes=(7200 14400 28800 57600)
WindowSizes=(115200)
#step=7200
step=115200
end_time=1447106400
Systems=("rtec" "rtecnofi")

echo "%%% Comparing RTEC and RTEC-without-fi on the maritime domain without future initiations (see Figure 6 (left) of the paper).%%%"
for system in ${Systems[@]}; do
    echo -e "\tSystem: ${system}"
    cd ../systems/${system}/execution\ scripts
    for window_size in ${WindowSizes[@]}; do
        echo -e "\t\tWindow size: ${window_size}"
        ./run_rtec.sh --app=maritime_no_fi --window-size=${window_size} --step=${step} --end-time=${end_time} > ../../../logs/${system}/maritime_no_fi_win${window_size}.txt
        awk 'NR==3{print "\t\tAverage reasoning time: " $6} NR==4{print "\t\tStandard deviation: " $6}' ../examples/maritime_no_fi/results/log-swi-${window_size}-${step}-csv-file-log.txt
    done
    cd ../../../scripts
done
rm ../datasets/maritime/brest-critical.csv
