from sys import argv

application=argv[1]
agentsNo=argv[2]
timepointsNo=argv[3]

theoryFile=application+'.l'
logicaFile=application+'-'+agentsNo+'.l'

f=open(theoryFile, 'r')
fw=open(logicaFile, 'w')
for line in f:
	fw.write(line)
f.close()

fw.write('\n')

fw.write("isTimepoint(t) :- t in Range(" + timepointsNo + ");\n\n")

if application=="netbill":
	datasetFile="../rtec/examples/netbill_fragment/dataset/csv/netbill-"+agentsNo+".csv"
elif application=="voting":
	datasetFile="../rtec/examples/voting_fragment/dataset/csv/voting-"+agentsNo+".csv"

f2=open(datasetFile, 'r')
for line in f2:
	lineSpl=line.split("|")
	eventName=lineSpl[0]
	if eventName=="present_quote" or eventName=="accept_quote":
		if eventName=="present_quote":
			_, timestamp, _, merchant, consumer, goods, _ = lineSpl
			writeStr="happensAt(event:\"presentQuote\", merchant:" + merchant + ", consumer:" + consumer + ", goods:\"" + goods + "\", t:" + timestamp + ");\n"
		elif eventName=="accept_quote":
			_, timestamp, _, consumer, merchant, goods = lineSpl
			writeStr="happensAt(event:\"acceptQuote\", consumer:" + consumer + ", merchant:" + merchant + ", goods:\"" + goods.replace('\n','') + "\", t:" + timestamp + ");\n"
		if "book" in goods:
			fw.write(writeStr)

f2.close()
fw.close()
