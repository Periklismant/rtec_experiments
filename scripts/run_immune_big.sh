#!/bin/bash
# This script reproduces the results of Figure 4 (middle) of the paper.
# We execute RTEC and GKL-EC on the immune response feedback loop.

#Timeline_sizes=(200)
App="immune"
Timeline_sizes=(4000) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
Window_sizes=(4000) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
#Window_sizes=(250000 500000 1000000 2000000) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
step=4000
#Timeline_sizes=(1000000) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
#Timeline_sizes=(250000 500000 1000000 2000000) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
#Window_sizes=(100 100 100 100) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
#Window_sizes=(100) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
#step=100
# Run RTEC 
cd ../systems/rtec/execution\ scripts
echo "Reasoning with RTEC on $App"
for index in ${!Timeline_sizes[@]}; do
    window_size=${Window_sizes[$index]}
    timeline_size=${Timeline_sizes[$index]}
    echo -e "\tWindow_size: ${window_size}"
    echo -e "\tNumber of events: $((${window_size}/2))"
    total_run_time=0
    total_run_time_sq=0
    count=0
    for H in {0..0} #{0..1} 
    do
        for S in {0..0} #{0..2} 
        do
            echo -e "\t\tInitial values: h=$H s=$S"
            start_time=`date +%s.%N`
            ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${H}_${S}.prolog --end-time=${timeline_size} --window-size=${window_size} --step=${step} > ../../../logs/rtec/log_${App}_${window_size}_${H}_${S}.txt
            end_time=`date +%s.%N`
            run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
            run_time=${run_time_float%.*}
            ((total_run_time+=run_time))
            ((total_run_time_sq+=run_time**2))
            ((count+=1))
            echo -e "\t\tReasoning time: ${run_time}ms"
        done
    done
    #echo "For application: $App with timeline size: $timeline_size, we have:"
    avg=$((total_run_time/count))
    echo -e "\tAverage reasoning time: $avg"
    stdev=$(echo "" | awk -v sum=${total_run_time} -v sumsq=${total_run_time_sq} -v count=${count} 'END{print sqrt(sumsq/count - (sum/count)^2)}')      
    #echo -e "\tStandard deviation: $stdev"
done
# Run GKL-EC
#cd ../../gklec/scripts
#echo "Reasoning with GKL-EC on $App"
#for EndTime in ${Timeline_sizes[@]}; do
#    echo -e "\tNumber of events: $((${timeline_size}/2))"
#    swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(immune_g, ${EndTime}), halt."
#    HVals='0 1' # 2'
#    SVals='0 1 2'
    #for HVal in $HVals; do
    #       for SVal in $SVals; do
    #              python3 transform_flec_logs.py immune_g ${EndTime} ${HVal} ${SVal}
    #       done
    #done
#done
cd ../../../scripts
