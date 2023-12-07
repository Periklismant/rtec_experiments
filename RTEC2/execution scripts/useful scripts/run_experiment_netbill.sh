#!/bin/bash

agents='1000 2000 4000 8000'
#agents='16000'

rm -f experiments_log.txt

for agent in $agents; do
    echo "Running for $agent agents..."
    yap -q -s0 -h0 -l continuousQueries.prolog -g "continuousQueries(netbillBig,$agent),halt." >> experiments_log.txt
done
