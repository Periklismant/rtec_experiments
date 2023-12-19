#!/bin/bash
# This script reproduces the results of Figure 4 (middle) of the paper.
# We execute RTEC and GKL-EC on the immune response feedback loop.

Timeline_sizes=(100)
#Timeline_sizes=(300 600 1200 2400)
App="phage"
#Timeline_sizes=(400 800 1600 3200) # These timelines contain, resp., 200, 400, 800 and 1600 events, i.e., changes in the functions that may lead to delayed variable modifications.
# Run RTEC 
for timeline_size in ${Timeline_sizes[@]}; do
    echo "Timeline size: ${timeline_size}"
    App="phage"
    echo -e "\tApp: $App"
    total_run_time=0
    total_run_time_sq=0
    count=0
    for CI in {0..2} 
        do
        for CRO in {0..3} 
            do
            for CII in {0..1} 
                do
                for N in {0..1} 
                    do
                        echo -e "\t\tParameters: $CI $CRO $CII $N"
                        start_time=`date +%s.%N`
                        ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${CI}_${CRO}_${CII}_${N}.prolog --end-time=${timeline_size} > logs/logs_${App}_${CI}_${CRO}_${CII}_${N}.txt
                        end_time=`date +%s.%N`
                        run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
                        run_time=${run_time_float%.*}
                        ((total_run_time+=run_time))
                        ((total_run_time_sq+=run_time**2))
                        ((count+=1))
                        echo -e "\t\tRuntime: $run_time"
                done
            done
        done
    done
    echo "For application: $App with timeline size: $timeline_size, we have:"
    avg=$((total_run_time/count))
    echo "Average reasoning time: $avg"
    stdev=$(echo "" | awk -v sum=${total_run_time} -v sumsq=${total_run_time_sq} -v count=${count} 'END{print sqrt(sumsq/count - (sum/count)^2)}')
    echo "Standard deviation: $stdev"
done

cd ../systems/rtec/execution\ scripts
echo "Reasoning with RTEC on $App"
for timeline_size in ${Timeline_sizes[@]}; do
    echo -e "\tTimeline size: ${timeline_size}"
    total_run_time=0
    total_run_time_sq=0
    count=0
    for H in {0..1} 
    do
        for S in {0..2} 
        do
            echo -e "\t\tInitial values: h=$H s=$S"
            start_time=`date +%s.%N`
            ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${H}_${S}.prolog --end-time=${timeline_size} > logs/logs_${App}_${H}_${S}.txt
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
cd ../../gklec/scripts
echo "Reasoning with GKL-EC on $App"
for EndTime in ${Timeline_sizes[@]}; do
    echo -e "\tTimeline size: ${timeline_size}"
    swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(immune_g, ${EndTime}), halt."
    HVals='0 1' # 2'
    SVals='0 1 2'
    for HVal in $HVals; do
            for SVal in $SVals; do
                    python3 transform_flec_logs.py immune_g ${EndTime} ${HVal} ${SVal}
            done
    done
done
cd ../../../scripts
