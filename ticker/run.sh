
python3 generateTheory.py $1 $2
tail -n 0 -F input.txt | java -jar target/scala-2.12/ticker-assembly-1.0.jar --program netbill-$1-$2.lars -e signal >> out-$1-$2.txt &
python3 inputProvider.py

wait
echo $SECONDS