from sys import argv

agentsNo=argv[1]
timepointsNo=argv[2]

agents=set()
motions=set()

inputFile="/home/periklis/Desktop/RTEC2_updated/RTEC2/examples/voting/experiments/data/csv/voting-"+agentsNo+"-"+timepointsNo+"-1.csv"
f=open(inputFile, 'r')
fw=open("voting-" + agentsNo + "-" + timepointsNo + ".pl", 'w')

fw.write("test(MVIs):-\n\tupdate([")

first=True
for line in f:
	lineSpl=line.split("|")
	eventName=lineSpl[0]
	if not first:
		writeStr=","
	else:
		writeStr=""
		first=False
	if eventName=="propose" or eventName=="second" or eventName=="close_ballot":
		_, timestamp, _, agent, motion = lineSpl
		writeStr+="happens(" + eventName + "(" + agent + "," + motion.replace("\n","") + ")," + timestamp + ")"
		if agent not in agents:
			agents.add(agent)
		if motion not in motions:
			motions.add(motion)
	elif eventName=="vote":
		continue
		#_, timestamp, _, agent, motion, vote = lineSpl
		#writeStr+="happens(" + eventName + "(" + agent + "," + motion + "," + vote.replace("\n", "") + ")," + timestamp + ")"
		#if agent not in agents:
		#	agents.add(agent)
		#if motion not in motions:
		#	motions.add(motion)
	elif eventName=="declare":
		_, timestamp, _, agent, motion, result = lineSpl
		writeStr+="happens(" + eventName + "(" + agent + "," + motion + "," + result.replace("\n", "") + ")," + timestamp + ")"
		if agent not in agents:
			agents.add(agent)
		if motion not in motions:
			motions.add(motion)
	fw.write(writeStr)

f.close()

fw.write("]),\n\tstatus(MVIs).\n\n")

'''
for agent in agents:
	fw.write("agent("+agent+").\n")

for motion in motions:
	fw.write("motion("+motion+").\n")
'''

f1=open("voting_theory.pl", 'r')
for line in f1:
	fw.write(line)
f1.close()

f2=open("rbt_rec.pl", 'r')
for line in f2:
	fw.write(line)
f2.close()
fw.close()
