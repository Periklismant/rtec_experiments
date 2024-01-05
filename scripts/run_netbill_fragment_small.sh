#!/bin/bash 
# This script reproduces the results of Figure 5 (left) of the paper.
# We execute RTEC, sCASP, Ticker, Fusemate, Logica, jRECfi and jRECrbt on a small fragment of NetBill.

EventNos=(10 20 40 80)

echo "%%% Comparing RTEC, sCASP, Ticker, Fusemate, Logica, jRECrbt and jRECfi on a fragment of NetBill (see Figure 5 (left) of the paper). %%%"
# Run RTEC
echo -e "\t**System: RTEC**"
cd ../systems/rtec/execution\ scripts
for event_no in ${EventNos[@]}; do
    echo -e "\t\tNumber of events: ${event_no}"
        start_time=`date +%s.%N`
        ./run_rtec.sh --app=netbill_fragment --window-size=50 --step=50 --end-time=50 --input=../examples/netbill_fragment/dataset/csv/netbill-${event_no}.csv > logs/netbill-${event_no}.txt
        end_time=`date +%s.%N`
        run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
        run_time=${run_time_float%.*}
        echo -e "\t\tReasoning Time: ${run_time}ms"
done
cd ../../../scripts

# Run sCASP
echo -e "\t**System: sCASP**"
cd ../systems/scasp
for event_no in ${EventNos[@]}; do
    echo -e "\t\tNumber of events: ${event_no}"
    echo "?- holdsAt(quote(M,C,book), T)." > query.pl
    echo "#include 'input/netbill-${event_no}.pl'." > event_description.pl
    cat event_descriptions/netbill.pl >> event_description.pl
    start_time=`date +%s.%N`
    scasp --prev_forall -n0 event_description.pl query.pl > ../../logs/scasp/netbill-eventsNo${event_no}.txt &&
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\t\tReasoning time: ${run_time}ms"
    rm query.pl
    rm event_description.pl
done
cd ../../../scripts

# Run Ticker
echo -e "\t**System: Ticker**"
cd ../systems/ticker
for event_no in ${EventNos[@]}; do
    echo -e "\t\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    ./run.sh ${event_no} 50
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\t\tReasoning time: ${run_time}ms"
done
cd ../../scripts

# Run Fusemate
echo -e "\t**System: Fusemate**"
cd ../systems/fusemate/examples/event-calculus
./run.sh
cd ../../../../scripts

# Run Logica
echo -e "\t**System: Logica**"
cd ../systems/logica
for event_no in ${EventNos[@]}; do
    echo -e "\t\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    logica netbill-${event_no}.l run holdsAt &>/dev/null
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\t\tReasoning time: ${run_time}ms"
done
cd ../../scripts

# Run jRECrbt
echo -e "\t**System: jRECrbt**"
cd ../systems/jrecrbt/bin
for event_no in ${EventNos[@]}; do
    echo -e "\t\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    java -Xss9m Main rbt_rec $event_no netbill
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\t\tReasoning time: ${run_time}ms"
done
cd ../../../scripts

# Run jRECrbt
#echo "Run scripts/run_jrecfi.sh locally, with Oracle JDK 18, to reproduce the results on jRECfi, because it requires a GUI."
