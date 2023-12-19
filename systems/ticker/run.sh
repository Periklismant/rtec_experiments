
python3 generateTheory.py $1 $2
echo $(date)
cat eventNarrative.txt | java -Xms1G -Xmx6G -jar target/scala-2.12/ticker-assembly-1.0.jar --program netbill-$1.lars -e signal -c 200ms >> out-$1.txt &
python3 inputProvider.py

wait
echo $SECONDS
