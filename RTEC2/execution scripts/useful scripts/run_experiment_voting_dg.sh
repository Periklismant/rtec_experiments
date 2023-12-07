#!/bin/bash

agents='1000 2000 4000 8000'

rm -f experiments_log.txt

for agent in $agents; do
    echo "Running for $agent agents..."
    yap -s0 -h0 -q -l continuousQueries.prolog -g "continuousQueries(votingBigDG,$agent),halt." >> experiments_log.txt
done
