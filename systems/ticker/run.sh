#!/bin/bash

eventsNo=$1
timelineLength=$2

rm -f output/out-${eventsNo}.txt
rm -f netbill-${eventsNo}.lars

python3 scripts/generateTheory.py ${eventsNo} ${timelineLength}
#echo $(date)
cat input/eventNarrative.txt | java -Xms1G -Xmx6G -jar target/scala-2.12/ticker-assembly-1.0.jar --program netbill-${eventsNo}.lars -e signal -c 200ms >> output/out-${eventsNo}.txt &
PID=$!
#python3 scripts/inputProvider.py
while [ $(wc -l output/out-${eventsNo}.txt | awk '{print $1}') -lt ${eventsNo} ];
do
    #echo "Time: $SECONDS"
    sleep 1
done
kill ${PID}
#echo $SECONDS
#rm netbill-${eventsNo}.lars
