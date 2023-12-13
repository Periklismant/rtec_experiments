#!/bin/bash

Timeline_sizes=(100 200 400 800)

for timeline_size in ${Timeline_sizes[@]}; do
    echo "Timeline size: ${timeline_size}"

    App="immune"
    echo -e "\tApp: $App"
    total_run_time=0
    total_run_time_sq=0
    count=0
    for H in {0..2} 
    do
        for S in {0..2} 
        do
            echo -e "\t\tParameters: $H $S"
            start_time=`date +%s.%N`
            ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${H}_${S}.prolog --end-time=${timeline_size} > logs/logs_${App}_${H}_${S}.txt
            end_time=`date +%s.%N`
            run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
            run_time=${run_time_float%.*}
            ((total_run_time+=run_time))
            ((total_run_time_sq+=run_time**2))
            ((count+=1))
            echo -e "\t\tRuntime: $run_time"
        done
    done
    echo "For application: $App with timeline size: $timeline_size, we have:"
    avg=$((total_run_time/count))
    echo "Average reasoning time: $avg"
    stdev=$(echo "" | awk -v sum=${total_run_time} -v sumsq=${total_run_time_sq} -v count=${count} 'END{print sqrt(sumsq/count - (sum/count)^2)}')
    #echo "Standard deviation: $stdev"

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
    #echo "Standard deviation: $stdev"

done

: '
App="simple_loop"
for X in {0..1} 
do
	for Y in {0..1} 
	do
		echo "App: $App Parameters: $X $Y"
		./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${X}_${Y}.prolog > logs/logs_${App}_${X}_${Y}.txt
	
	done
done
'
