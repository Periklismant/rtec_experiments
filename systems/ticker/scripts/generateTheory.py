from sys import argv

agentsNo=argv[1]
timepointsNo=argv[2]

#netbillTheory="netbillTheory.lars"
netbillTheory="event_description/netbillTheoryInitTerm.lars"
#netbillTheory="event_description/netbillTheory.lars"
f=open(netbillTheory, 'r')
outputFile="netbill-"+agentsNo+".lars"
fw=open(outputFile, 'w')

for line in f:
	fw.write(line)

f.close()
fw.write('\n')

datasetFile="../rtec/examples/netbill_fragment/dataset/csv/netbill-"+agentsNo+".csv"

for t in range(0, int(timepointsNo)):
	fw.write("timepoint("+str(t)+").\n")

merchants=set()
consumers=set()

f2=open(datasetFile, 'r')
fw2=open("input/eventNarrative.txt", 'w')
for line in f2:
	lineSpl=line.split("|")
	eventName=lineSpl[0]
	if eventName=="present_quote" or eventName=="accept_quote":
		if eventName=="present_quote":
			_, timestamp, _, merchant, consumer, goods, _ = lineSpl
			writeStr="presentQuote(" + merchant + "," + consumer + "," + timestamp + ")\n"
		elif eventName=="accept_quote":
			_, timestamp, _, consumer, merchant, goods = lineSpl
			writeStr="acceptQuote(" + consumer + "," + merchant + "," +  timestamp + ")\n"
		if "book" in goods:
			if merchant not in merchants:
				merchants.add(merchant)
				fw.write("merchant("+merchant+").\n")
			if consumer not in consumers:
				consumers.add(consumer)
				fw.write("consumer("+consumer+").\n")
			fw2.write(writeStr)

f2.close()
fw.close()
fw2.close()
