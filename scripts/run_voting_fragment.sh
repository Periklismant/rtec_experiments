#!/bin/bash 
# This script reproduces the results of Figure 4 (left) of the paper.
# We execute RTEC, sCASP and jRECfi on a small fragment our the voting protocol.

EventNos=(10 20 40 80)

# Run RTEC
echo "Reasoning with RTEC on a fragment of voting."
cd ../systems/rtec/execution\ scripts
for event_no in ${EventNos[@]}; do
    echo -e "\tNumber of events: ${event_no}"
    start_time=`date +%s.%N`
    ./run_rtec.sh --app=voting_fragment --window-size=40 --step=40 --end-time=40 --background-knowledge=../examples/voting_fragment/dataset/auxiliary/voting-${event_no}.prolog --input=../examples/voting_fragment/dataset/csv/voting-${event_no}.csv > logs/voting-${event_no}.txt
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
done
cd ../../../scripts

# Run sCASP
echo "Reasoning with sCASP on a fragment of voting."
cd ../systems/scasp
for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
    echo "?- holdsAt(permitted_to_close(M), T)." > query.pl
    echo "#include 'input/voting-${event_no}.pl'." > event_description.pl
    cat event_descriptions/voting.pl >> event_description.pl
    start_time=`date +%s.%N`
    scasp --prev_forall -n0 event_description.pl query.pl > ../../logs/scasp/voting-eventsNo${event_no}.txt &&
    end_time=`date +%s.%N`
    run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
    run_time=${run_time_float%.*}
    echo -e "\tReasoning time: ${run_time}ms"
    rm query.pl
    rm event_description.pl
done
cd ../../../scripts

# Run jRECfi
echo "Reasoning with jRECfi on a fragment of voting."
