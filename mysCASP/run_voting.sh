#!/bin/bash


run_query() {
	    echo -e '\n\n----------\t QUERY: ' $1 ' \t\t--------------'
	    echo "$@" > query.pl	
	    time scasp --prev_forall -n0 voting.pl query.pl
}

END=50


if [ "$#" == 0 ]; then
    #MVals=(0 10)
    #for m in $MVals; do 
        echo -e '\t\t\t\t*** VOTING - BENCHMARK - using scasp'
        #run_query "?- holdsAt(voting_in_progress(M), T)."; 
        run_query "?- holdsAt(permitted_to_close(M), T)."; 
        #for i in $(seq 1 $END); do 
        #    run_query "?- holdsAt(quote(10,10,book), $i)."; 
        #    #run_query "?- -holdsAt(quote(agentM,agentC,goods1), $i)."; 
        #done
   # done
else
    run_query $@

fi

