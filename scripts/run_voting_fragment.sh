#!/bin/bash 
# This script reproduces the results of Figure 4 (left) of the paper.
# We execute RTEC, sCASP and jRECfi on a small fragment our the voting protocol.

EventNos=(10 20 40 80)

for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
    echo "?- holdsAt(permitted_to_close(M), T)." > ../systems/scasp/query.pl
    echo "#include '../input/voting-${event_no}.pl'." > ../systems/scasp/event_description.pl
    cat ../systems/scasp/event_descriptions/voting.pl >> esystems/scasp/event_description.pl
    time scasp --prev_forall -n0 event_description.pl query.pl > ../logs/scasp/voting-${event_no}.txt &&
    rm query.pl
    rm event_description.pl
done

