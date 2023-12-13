from sys import argv
from generate_datasets import gen_tick_event

readFile=argv[1]
writeFile=argv[2]
end_time=60
f=open(readFile,'r')
fw=open(writeFile, 'w')

def gen_voting_event(t,ids,eventType,agent,motion):
	myid=ids['eventid']
	votingEvent="ts,"+eventType+","+str(myid)+",agent"+agent+",[m"+motion+"] "+str(t)+"\n"\
					"tc,"+eventType+","+str(myid)+",agent"+agent+",[] "+str(t+1)+"\n"
	ids['eventid']+=1
	return votingEvent

global_timestamp=1
ids={'eventid': 1, 'tickid': 0}

for line in f:
	eventType, event_timestampstr, _, agent, motion = line.strip().split('|')
	event_timestamp=int(event_timestampstr)*2-1
	if global_timestamp<event_timestamp:
		for t in range(global_timestamp,event_timestamp):
			fw.write(gen_tick_event(t,ids))
		global_timestamp=event_timestamp
	fw.write(gen_voting_event(event_timestamp,ids,eventType,agent,motion))

while global_timestamp<end_time:
	global_timestamp+=1
	fw.write(gen_tick_event(global_timestamp,ids))

f.close()
fw.close()
