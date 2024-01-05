#!/bin/bash 
# This script reproduces the results of Figure 5 (right) of the paper.
# We execute RTEC and jRECrbt on a small fragment of NetBill.

EventNos=(4000 8000 16000 32000)
echo "%%% Comparing RTEC and jRECrbt on a fragment of NetBill (see Figure 5 (right) of the paper). %%%"

# Run RTEC
echo -e "\t**System: RTEC**"
cd ../systems/rtec/execution\ scripts
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    ./run_rtec.sh --app=netbill_fragment --window-size=50 --step=50 --end-time=50 --input=../examples/netbill_fragment/dataset/csv/netbill-${event_no}.csv > logs/netbill-${event_no}.txt
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
done
cd ../../../scripts

# Run jRECrbt
echo -e "\t**System: jRECrbt**"
cd ../systems/jrecrbt/bin
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    java -Xss9m Main rbt_rec $event_no netbill
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
done
cd ../../../scripts
