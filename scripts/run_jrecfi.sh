#!/bin/bash

applications=("voting" "netbill")
events_nos=("10" "20" "40" "80")

cd ../systems/jrecfi/
for events_no in ${events_nos}; do
    for application in ${applications[@]}; do
        cp climb/model_${application}.txt climb/model.txt
        java -jar MobuconEC-tester.jar > log.txt &
        PID=$!
        echo "Select option: 'Run'"
        echo "Copy and Paste the data from datasets/${application}_datasets/${application}-${events_no}.csv into the 'trace' pane"
        echo "Click 'Start', then click 'Log' *once* and wait for the results."
        echo "Sleeping for 1 minute..."
        sleep 60 
        kill $!
        rm log.txt
    done
done

