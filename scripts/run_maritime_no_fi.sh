WindowSizes=(7200 14400 28800 57600)
Systems=("rtec" "rtecnofi")

for system in ${Systems[@]}; do
    echo "System: ${system}"
    cd ../systems/${system}/execution\ scripts
    for window_size in ${WindowSizes[@]}; do
        echo "Window size: ${window_size}"
        ./run_rtec.sh --app=maritime_no_fi --window-size=${window_size} --step=7200 > ../../../logs/maritime_no_fi_${system}_${window_size}.txt
    done
    cd ../../../scripts
done
