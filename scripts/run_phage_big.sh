#!/bin/bash
# This script reproduces the results of Figure 4 (right) of the paper.
# We execute RTEC and GKL-EC on the phage infection feedback loop.

App="phage"
#Timeline_sizes=(187500 375000 750000 1500000) # A timeline with length T contains about 2*T/3 events, i.e., changes in the functions that may lead to delayed variable modifications.
Timeline_sizes=(1125) # A timeline with length T contains about 2*T/3 events, i.e., changes in the functions that may lead to delayed variable modifications.
Window_sizes=(1125) # A timeline with length T contains about T/2 events, i.e., changes in the functions that may lead to delayed variable modifications.
step=1125
# Run RTEC 
cd ../systems/rtec/execution\ scripts
echo "Reasoning with RTEC on $App"
for index in ${!Timeline_sizes[@]}; do
    window_size=${Window_sizes[$index]}
    timeline_size=${Timeline_sizes[$index]}
    echo -e "\tWindow size: ${window_size}"
    echo -e "\tNumber of events: $((2*${timeline_size}/3))"
    App="phage"
    total_run_time=0
    total_run_time_sq=0
    count=0
    for CI in {0..0} 
        do
        for CRO in {0..0} 
            do
            for CII in {0..0} 
                do
                for N in {0..0} 
                    do
                        echo -e "\t\tInitial values: cI=$CI cro=$CRO cII=$CII n=$N"
                        start_time=`date +%s.%N`
                        ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${CI}_${CRO}_${CII}_${N}.prolog --end-time=${timeline_size} --window-size=${window_size} --step=${step} > ../../../logs/rtec/log_${App}_$((${timeline_size}/2))_${CI}_${CRO}_${CII}_${N}.txt
                        end_time=`date +%s.%N`
                        run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
                        run_time=${run_time_float%.*}
                        ((total_run_time+=run_time))
                        ((total_run_time_sq+=run_time**2))
                        ((count+=1))
                        echo -e "\t\tReasoning time: ${run_time}ms"
                done
            done
        done
    done
    avg=$((total_run_time/count))
    echo -e "\tAverage reasoning time: $avg"
    #stdev=$(echo "" | awk -v sum=${total_run_time} -v sumsq=${total_run_time_sq} -v count=${count} 'END{print sqrt(sumsq/count - (sum/count)^2)}')
    #echo -e "\tStandard deviation: $stdev"
done
# Run GKL-EC
#cd ../../gklec/scripts
#echo "Reasoning with GKL-EC on $App"
#for EndTime in ${Timeline_sizes[@]}; do
    #echo -e "\tNumber of events: $((2*${timeline_size}/3))"
	#swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(phage_g, ${EndTime}), halt."
	#CIVals='0 1 2'
	#CroVals='0 1 2 3'
	#CIIVals='0 1'
	#NVals='0 1'
	#for CIVal in $CIVals; do
		#for CroVal in $CroVals; do
			#for CIIVal in $CIIVals; do
				#for NVal in $NVals; do
					#python3 transform_flec_logs.py phage_g ${EndTime} ${CIVal} ${CroVal} ${CIIVal} ${NVal}
				#done
			#done
		#done
	#done
#done
cd ../../../scripts
