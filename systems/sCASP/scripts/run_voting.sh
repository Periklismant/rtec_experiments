#!/bin/bash
EventNos=(5 10 20 40)

for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
    echo "?- holdsAt(permitted_to_close(M), T)." > query.pl
    echo "#include '../input/voting-${event_no}.pl'." > event_description.pl
    cat ../event_descriptions/voting.pl >> event_description.pl
    time scasp --prev_forall -n0 event_description.pl query.pl > ../logs/voting-${event_no}.log &&
    rm query.pl
    rm event_description.pl
done

