from sys import argv


def generate_rec_theory(agentsNo, system):
	maxCounter=1000

	agents=set()
	motions=set()

	inputFile="../../rtec/examples/voting_fragment/dataset/csv/voting-"+agentsNo+".csv"
	f=open(inputFile, 'r')
	fw=open("../programs/voting_" + agentsNo + "_" + system + ".pl", 'w')

	#fw.write("test(MVIs):-\n\tupdate([")
	fw.write("test(MVIs):-\n\tupdate([")

	windowNo=1
	windowSize=100
	first=True
	for line in f:
		lineSpl=line.strip().split("|")
		eventName, timestamp, _, agent, motion = lineSpl
		if not first:
			writeStr=","
		else:
			writeStr=""
			first=False
		writeStr+="happens(" + eventName + "(" + agent + "," + motion + ")," + timestamp + ")" #]),\n\tupdate(["
		if agent not in agents:
			agents.add(agent)
		if motion not in motions:
			motions.add(motion)
		fw.write(writeStr)
		if windowNo*windowSize<int(timestamp):
			windowNo+=1
			fw.write("]),\n\tupdate([")
			#fw.write("]),\n\tstatus,\n\tupdate([")
			#fw.write("]),\n\tstatus.\n\ntest("+str(windowNo)+"):-\n\tupdate([")
			first=True

	f.close()

	#fw.write("]),\n\tstatus(MVIs).\n\n")
	fw.write("]),\n\tstatus(MVIs).\n\n")

	for agent in agents:
		fw.write("agent("+agent+").\n")

	for motion in motions:
		fw.write("motion("+motion+").\n")

	f1=open("../programs/voting_theory.pl", 'r')
	for line in f1:
		fw.write(line)
	f1.close()

	f2=open("../bin/" + system + ".pl", 'r')
	#f2=open("../bin/rec_commented.pl", 'r')
	for line in f2:
		fw.write(line)
	f2.close()
	fw.close()

agentNos=["10", "20", "40", "80"]
systems=["rec"]

for agentNo in agentNos:
	for system in systems:
		generate_rec_theory(agentNo,system)

