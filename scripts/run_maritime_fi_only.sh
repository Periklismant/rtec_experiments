WindowSizes=(7200 14400 28800 57600)

cd ../systems/rtec/execution\ scripts
for window_size in ${WindowSizes[@]}; do
    echo "Window size: ${window_size}"
    ./run_rtec.sh --app=maritime_fi_only --window-size=${window_size} --step=7200 > ../../../logs/maritime_fi_only_rtec_${window_size}.txt
done
cd ../../../scripts
