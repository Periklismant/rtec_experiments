#!/bin/bash


run_query() {
    echo -e '\n\n----------\t QUERY: ' $1 ' \t\t--------------'
    echo "$@" > query.pl	
    time scasp --prev_forall -n0 ../event_descriptions/netbill.pl query.pl
}

END=50


if [ "$#" == 0 ]; then
    echo -e '\t\t\t\t*** NETBILL - BENCHMARK - using scasp'
    run_query "?- holdsAt(quote(M,C,book), T)."; 
else
    run_query $@

fi

