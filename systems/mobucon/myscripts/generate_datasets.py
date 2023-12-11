from sys import argv
from random import uniform,randrange

# Voting
OPEN_BALLOT_PROB=0.25
CLOSE_BALLOT_PROB=0.2

def gen_voting_event(t,ids,eventType,actuator,motion):
	myid=ids['eventid']
	votingEvent="ts,"+eventType+","+str(myid)+",agent"+str(actuator)+",[m"+str(motion)+"] "+str(t)+"\n"\
					"tc,"+eventType+","+str(myid)+",agent"+str(actuator)+",[] "+str(t+1)+"\n"
	ids['eventid']+=1
	return votingEvent

def gen_tick_event(t,ids):
	myid=ids['tickid']
	tickEvent="ts,tick,"+str(myid)+",o,[] "+str(t)+"\n"\
				"tc,tick,"+str(myid)+",o,[] "+str(t+1)+"\n"
	ids['tickid']-=1
	return tickEvent

def gen_dataset(app,fileName,parameters):
	if app=="voting":
		agentsNo,motionsNo,timeLength=parameters
		eventTypeProbs={"open_ballot": OPEN_BALLOT_PROB, "close_ballot": CLOSE_BALLOT_PROB}
		f=open(fileName,'w')
		ids={'eventid': 1, 'tickid': 0}
		for t in range(1,timeLength+1,2):
			f.write(gen_tick_event(t,ids))
			for eventType in eventTypeProbs:
				if uniform(0,1)<eventTypeProbs[eventType]:
					actuator=randrange(agentsNo)+1
					motion=randrange(motionsNo)+1
					f.write(gen_voting_event(t,ids,eventType,actuator,motion))
		f.close()

if __name__=="__main__":
	app=argv[1]
	fileName=argv[2]
	parameters=[int(argv[3]),int(argv[4]),int(argv[5])]
	gen_dataset(app,fileName,parameters)
