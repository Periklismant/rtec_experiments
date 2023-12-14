from sys import argv

agentsNo=argv[1]
maxCounter=1000

merchants=set()
consumers=set()

inputFile="../../rtec/examples/netbill_fragment/dataset/csv/netbill-"+agentsNo+".csv"
f=open(inputFile, 'r')
fw=open("../programs/netbill-" + agentsNo + ".pl", 'w')

fw.write("test:-\n\tupdate([")

windowNo=1
windowSize=100
first=True
for line in f:
	lineSpl=line.split("|")
	eventName=lineSpl[0]
	if eventName=="present_quote" or eventName=="accept_quote":

		if eventName=="present_quote":
			_, timestamp, _, merchant, consumer, goods, _ = lineSpl
			if not first:
				writeStr=","
			else:
				writeStr=""
				first=False
			writeStr+="happens(presentQuote(" + merchant + "," + consumer + "," + goods + ")," + timestamp + ")"
		elif eventName=="accept_quote":
			_, timestamp, _, consumer, merchant, goods = lineSpl
			if not first:
				writeStr=","
			else:
				writeStr=""
				first=False
			writeStr+="happens(acceptQuote(" + merchant + "," + consumer + "," + goods.replace('\n','') + ")," + timestamp + ")"
		if "book" in goods:
			if merchant not in merchants:
				merchants.add(merchant)
			if consumer not in consumers:
				consumers.add(consumer)
			fw.write(writeStr)
			if windowNo*windowSize<int(timestamp):
				windowNo+=1
				fw.write("]),\n\tstatus.\n\ntest("+str(windowNo)+"):-\n\tupdate([")
				first=True

f.close()

fw.write("]),\n\tstatus.\n\n")

for merchant in merchants:
	fw.write("merchant("+merchant+").\n")

for consumer in consumers:
	fw.write("consumer("+consumer+").\n")

fw.write("goods(book).\n")

f1=open("../programs/netbill_theory.pl", 'r')
for line in f1:
	fw.write(line)
f1.close()

f2=open("../bin/rec_commented.pl", 'r')
for line in f2:
	fw.write(line)
f2.close()
fw.close()
