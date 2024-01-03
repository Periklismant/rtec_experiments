#!/bin/bash

timestamp() { 
    date '+%s%N' --date="$1"
}

# Outer parens turn string into an array of string, based on space separator.
times=($(stat $1 | awk 'NR==8{ birth_time=$3 } NR==6{ modify_time=$3 } END { print birth_time " " modify_time }'))
birth_time=${times[0]}
modify_time=${times[1]}
echo $birth_time
echo $modify_time
birth_epoch=$(( $(timestamp "${birth_time}") ))
modify_epoch=$(( $(timestamp "${modify_time}") ))
echo $birth_epoch
echo $modify_epoch
elapsed_time=$(( $modify_epoch - $birth_epoch )) 
echo $elapsed_time
echo $(date +"%S.%N" --date=@$elapsed_time) 
