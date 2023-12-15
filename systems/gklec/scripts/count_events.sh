#!/bin/bash 

App=$1
TimelineSize=$2

results_dir=../results/

count=0
number_of_events_sum=0
for results_file in "$results_dir"/$1-$2-*.txt ; do
    read my_number_of_events_sum <<< $(awk -F, 'BEGIN{number_of_events=0}
                                            $2=="f"{number_of_events+=NF/2-2}
                                            END{print number_of_events}' ${results_file})
    ((number_of_events_sum+=my_number_of_events_sum))
    ((count++))
done

echo "Sum of events over all possible initial values: ${number_of_events_sum}"
echo "Number of initial value configurations: ${count}"

echo "Average number of events per experiment: $((number_of_events_sum/count))"



