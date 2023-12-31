EventNos=(10 20 40 80)

for event_no in ${EventNos[@]}; do
    echo "Number of events: ${event_no}"
            start_time=`date +%s.%N`
            ./run_rtec.sh --app=voting_fragment --window-size=40 --step=40 --end-time=40 --background-knowledge=../examples/voting_fragment/dataset/auxiliary/voting-${event_no}.prolog --input=../examples/voting_fragment/dataset/csv/voting-${event_no}.csv > logs/voting-${event_no}.txt
            end_time=`date +%s.%N`
            run_time_float=$( echo "($end_time - $start_time)*1000" | bc -l )
            run_time=${run_time_float%.*}
            echo $run_time
done
