#!/bin/bash

timestamp() { 
    date '+%s%N' --date="$1"
}

# Outer parens turn string into an array of string, based on spaces as separators.
times=($(stat $1 | awk 'NR==5{ access_time=$3 } NR==6{ modify_time=$3 } END { print access_time " " modify_time }'))
access_time=${times[0]}
modify_time=${times[1]}
echo $access_time
echo $modify_time
access_epoch=$(( $(timestamp "${access_time}") ))
modify_epoch=$(( $(timestamp "${modify_time}") ))
echo $access_epoch
echo $modify_epoch
elapsed_time=$(( $modify_epoch - $access_epoch )) 
echo $elapsed_time
echo $(date +"%S.%N" --date=@$elapsed_time) 
