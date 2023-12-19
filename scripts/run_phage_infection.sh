#!/bin/bash
# This script reproduces the results of Figure 4 (right) of the paper.
# We execute RTEC and GKL-EC on the phage infection feedback loop.

Timeline_sizes=(100)
#Timeline_sizes=(300 600 1200 2400) # These timelines contain, resp., 200, 400, 800 and 1600 events, i.e., changes in the functions that may lead to delayed variable modifications.
App="phage"
# Run RTEC 
cd ../systems/rtec/execution\ scripts
echo "Reasoning with RTEC on $App"
for timeline_size in ${Timeline_sizes[@]}; do
    echo -e "\tTimeline size: ${timeline_size}"
    App="phage"
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
                        echo -e "\t\tInitial values: cI=$CI cro=$CRO cII=$CII n=$N"
                        start_time=`date +%s.%N`
                        ./run_rtec.sh --app=feedback_loops --background-knowledge=../examples/feedback_loops/resources/auxiliary/static_info.prolog --background-knowledge=../examples/feedback_loops/resources/auxiliary/initial_conditions/inits_${App}_${CI}_${CRO}_${CII}_${N}.prolog --end-time=${timeline_size} > ../../../logs/rtec/log_${App}_${CI}_${CRO}_${CII}_${N}.txt
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
cd ../../gklec/scripts
echo "Reasoning with GKL-EC on $App"
for EndTime in ${Timeline_sizes[@]}; do
    echo -e "\tTimeline size: ${timeline_size}"
	swipl -l ../src/gklec.prolog -q -g "runQueryAllInits(phage_g, ${EndTime}), halt."
	CIVals='0 1 2'
	CroVals='0 1 2 3'
	CIIVals='0 1'
	NVals='0 1'
	for CIVal in $CIVals; do
		for CroVal in $CroVals; do
			for CIIVal in $CIIVals; do
				for NVal in $NVals; do
					python3 transform_flec_logs.py phage_g ${EndTime} ${CIVal} ${CroVal} ${CIIVal} ${NVal}
				done
			done
		done
	done
done
cd ../../../scripts
