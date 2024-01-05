#!/bin/bash 
# This script reproduces the results of Figure 5 (left) of the paper.
# We execute RTEC, sCASP, Ticker, Fusemate, Logica, jRECfi and jRECrbt on a small fragment of NetBill.

EventNos=(10 20 40 80)

# Run RTEC
echo "Reasoning with RTEC on a fragment of NetBill."
cd ../systems/rtec/execution\ scripts
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
        start_time=`date +%s.%N`
        ./run_rtec.sh --app=netbill_fragment --window-size=50 --step=50 --end-time=50 --input=../examples/netbill_fragment/dataset/csv/netbill-${event_no}.csv > logs/netbill-${event_no}.txt
        end_time=`date +%s.%N`
        run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
        run_time=${run_time_float%.*}
        echo -e "\tReasoning Time: ${run_time}ms"
done
cd ../../../scripts

# Run sCASP
echo "Reasoning with sCASP on a fragment of NetBill."
cd ../systems/scasp
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
    echo "?- holdsAt(quote(M,C,book), T)." > query.pl
    echo "#include 'input/netbill-${event_no}.pl'." > event_description.pl
    cat event_descriptions/netbill.pl >> event_description.pl
    start_time=`date +%s.%N`
    scasp --prev_forall -n0 event_description.pl query.pl > ../../logs/scasp/netbill-eventsNo${event_no}.txt &&
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
    rm query.pl
    rm event_description.pl
done
cd ../../../scripts

# Run Ticker
echo "Reasoning with Ticker on a fragment of NetBill."
cd ../systems/ticker
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    ./run.sh ${event_no} 50
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
done
cd ../../scripts

# Run Fusemate
cd ../systems/fusemate/examples/event-calculus
./run.sh
cd ../../../../scripts

# Run Logica
echo "Reasoning with Logica on a fragment of NetBill."
cd ../systems/logica
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    logica netbill-${event_no}.l run holdsAt &>/dev/null
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
done
cd ../../scripts

# Run jRECrbt
echo "Reasoning with jRECrbt on a fragment of NetBill."
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
