from sys import argv
from generate_datasets import gen_tick_event

readFile=argv[1]
writeFile=argv[2]
f=open(readFile,'r')
fw=open(writeFile, 'w')

def gen_netbill_event(t,ids,eventName,merchant,consumer,goods):
	myid=ids['eventid']
	if eventName=="presentQuote":
		netbillEvent="ts,"+eventName+","+str(myid)+",agent"+merchant+",[agent"+consumer+","+goods+"] "+str(t)+"\n"\
					"tc,"+eventName+","+str(myid)+",agent"+merchant+",[] "+str(t+1)+"\n"
	elif eventName=="acceptQuote":
		netbillEvent="ts,"+eventName+","+str(myid)+",agent"+consumer+",[agent"+merchant+","+goods+"] "+str(t)+"\n"\
					"tc,"+eventName+","+str(myid)+",agent"+consumer+",[] "+str(t+1)+"\n"
	ids['eventid']+=1
	print(netbillEvent)
	return netbillEvent

count=0
for line in f:
	if count==1:
		linenopref=line[9:-5]
		print(linenopref)
		happensAtList=linenopref.split('),h')
		ids={'eventid': 1, 'tickid': 0}
		global_timestamp=1
		for factStr in happensAtList:
			print(factStr)
			eventInfoStr, timestampStr=factStr.split('),')
			event_timestamp=int(timestampStr.strip())
			if global_timestamp<event_timestamp:
				for t in range(global_timestamp,event_timestamp):
					fw.write(gen_tick_event(t,ids))
				global_timestamp=event_timestamp
			_, eventName, argsStr = eventInfoStr.split('(')
			if eventName=="presentQuote":
				merchant, consumer, goods = argsStr.split(',')
			elif eventName=="acceptQuote":
				consumer, merchant, goods = argsStr.split(',')
			fw.write(gen_netbill_event(event_timestamp,ids,eventName,merchant,consumer,goods))
		break
	count+=1

f.close()
fw.close()
