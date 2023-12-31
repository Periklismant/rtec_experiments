#!/bin/bash
# This script reproduces the results of Figure 4 (middle) of the paper.
# We execute RTEC and GKL-EC on the immune response feedback loop.

#Timeline_sizes=(200)
App="immune"
#Timeline_sizes=(400 800 1600 3200) # These timelines contain, resp., 200, 400, 800 and 1600 events, i.e., changes in the functions that may lead to delayed variable modifications.
Timeline_sizes=(400)

echo "%%% Comparing RTEC and GKL-EC on the immune response feedback loop (see Figure 4 (middle) of the paper). %%%"
# Run RTEC 
cd ../systems/rtec/execution\ scripts
echo -e "\t**System: RTEC**"
for timeline_size in ${Timeline_sizes[@]}; do
    echo -e "\t\tNumber of events: $((${timeline_size}/2))"
    total_run_time=0
    total_run_time_sq=0
    count=0
    for H in {0..1} 
    do
        for S in {0..2} 
        do
            echo -e "\t\t\tInitial values: h=$H s=$S"
            start_time=`date +%s.%N`
            ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${H}_${S}.prolog --end-time=${timeline_size} > ../../../logs/rtec/log_${App}_${H}_${S}.txt
            end_time=`date +%s.%N`
            run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
            run_time=${run_time_float%.*}
            ((total_run_time+=run_time))
            ((total_run_time_sq+=run_time**2))
            ((count+=1))
            echo -e "\t\t\tReasoning time: ${run_time}ms"
        done
    done
    #echo "For application: $App with timeline size: $timeline_size, we have:"
    avg=$((total_run_time/count))
    echo -e "\t\tAverage reasoning time: $avg"
    stdev=$(echo "" | awk -v sum=${total_run_time} -v sumsq=${total_run_time_sq} -v count=${count} 'END{print sqrt(sumsq/count - (sum/count)^2)}')      
    #echo -e "\tStandard deviation: $stdev"
done
# Run GKL-EC
cd ../../gklec/scripts
echo -e "\t**System: GKL-EC**"
for EndTime in ${Timeline_sizes[@]}; do
    echo -e "\t\tNumber of events: $((${timeline_size}/2))"
    swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(immune_g, ${EndTime}), halt."
    #HVals='0 1' # 2'
    #SVals='0 1 2'
    #for HVal in $HVals; do
    #       for SVal in $SVals; do
    #              python3 transform_flec_logs.py immune_g ${EndTime} ${HVal} ${SVal}
    #       done
    #done
done
cd ../../../scripts
