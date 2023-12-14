EventNos=(5 10 20 40)

for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
        start_time=`date +%s.%N`
        ./run_rtec.sh --app=netbill_fragment --window-size=50 --step=50 --end-time=50 --background-knowledge=../examples/netbill_fragment/dataset/auxiliary/netbill-${event_no}.prolog --input=../examples/netbill_fragment/dataset/csv/netbill-${event_no}.csv > logs/netbill-${event_no}.txt
        end_time=`date +%s.%N`
        run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
        run_time=${run_time_float%.*}
        echo $run_time
done
