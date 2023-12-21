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
        echo $run_time
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
    time scasp --prev_forall -n0 event_description.pl query.pl > ../../logs/netbill/netbill-eventsNo${event_no}.txt &&
    rm query.pl
    rm event_description.pl
done

# Run jRECfi
echo "Reasoning with jRECfi on a fragment of NetBill."

# Run Ticker


# Run Fusemate
echo "Reasoning with Fusemate on a fragment of NetBill."
cd ../systems/fusemate/examples/event-calculus
./run.sh
cd ../../../../scripts

# Run Logica

# Run jRECrbt
