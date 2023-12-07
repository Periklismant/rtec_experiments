# edit here the three arguments of the script as follows:
# first argument: ground truth file; second argument: predictions file; third argument: f1-score
GTFile=$1
PFile=$2
SCFile=$3

echo $GTFile
echo $PFile
echo $SCFile

yap -l ./f1-score-computation.prolog -q -g "compare_all_events,halt." -- "$GTFile" "$PFile" "$SCFile"
