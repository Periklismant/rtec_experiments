#!/bin/bash
EventNos=(5 10 20 40)

for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
    echo "?- holdsAt(quote_false(M,C,book), T)." > query.pl
    echo "#include '../input/netbill-${event_no}.pl'." > event_description.pl
    cat ../event_descriptions/netbillfi.pl >> event_description.pl
    time scasp --prev_forall -n0 event_description.pl query.pl > ../logs/netbillfi-${event_no}.txt &&
    rm query.pl
    rm event_description.pl
done

