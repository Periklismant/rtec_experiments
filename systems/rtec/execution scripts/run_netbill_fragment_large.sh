EventNos=(4000 8000 16000 32000)

for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
        start_time=`date +%s.%N`
        ./run_rtec.sh --app=netbill_fragment --window-size=10 --step=10 --end-time=100 --input=../examples/netbill_fragment/dataset/csv/netbill-${event_no}.csv > logs/netbill-${event_no}.txt
        end_time=`date +%s.%N`
        run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
        run_time=${run_time_float%.*}
        echo $run_time
done
