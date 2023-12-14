from sys import argv

readFile=argv[1]
writeFile=argv[2]
f=open(readFile,'r')
fw=open(writeFile, 'w')

def gen_netbill_event(t,eventType,merchant,consumer,goods):
	if eventName=="presentQuote":
		netbillEvent="present_quote|"+str(t)+"|"+str(t)+"|"+merchant+"|"+consumer+"|"+goods+"|10\n"
	elif eventName=="acceptQuote":
		netbillEvent="accept_quote|"+str(t)+"|"+str(t)+"|"+merchant+"|"+consumer+"|"+goods+"\n"
	return netbillEvent

count=0
for line in f:
	if count==1:
		linenopref=line[9:-5]
		print(linenopref)
		happensAtList=linenopref.split('),h')
		for factStr in happensAtList:
			print(factStr)
			eventInfoStr, timestampStr=factStr.split('),')
			event_timestamp=int(timestampStr.strip())
			_, eventName, argsStr = eventInfoStr.split('(')
			if eventName=="presentQuote":
				merchant, consumer, goods = argsStr.split(',')
			elif eventName=="acceptQuote":
				consumer, merchant, goods = argsStr.split(',')
			fw.write(gen_netbill_event(event_timestamp,eventName,merchant,consumer,goods))
		break
	count+=1

f.close()
fw.close()
