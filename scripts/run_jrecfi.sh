#!/bin/bash

applications=("voting" "netbill")
events_nos=("10" "20" "40" "80")

cd ../systems/jrecfi/
for application in ${applications[@]}; do
    for events_no in ${events_nos}; do
        mv climb/model_${application}.txt climb/model.txt
        java -jar MobuconEC-tester.jar > log.txt &
        echo 'Select option: "Run"'
        echo 'Copy and Paste the data from "datasets/${application}_datasets/${application}-${events_no}.csv" into the "trace" pane"'
        echo 'Click "Start" and then "Log"'
        wait
        rm log.txt
    done
done

