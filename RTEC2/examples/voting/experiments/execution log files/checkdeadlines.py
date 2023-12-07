import sys



inpfile=sys.argv[1]
d=int(sys.argv[2])
eventsAndDeadlines={'status':10*d, 'auxPerCloseBallot':8*d, 'sanctioned':4*d}
counter=dict()
matches=dict()
for key in eventsAndDeadlines:
	matches[key]=list()
	counter[key]=0

previousIntervals = dict() # key is eventName-id0

numberOfIntervals = dict()

f=open(inpfile, 'r')
for line in f:
	if len(line)>1:
		eventName=line.split(',')[1]
		if eventName in eventsAndDeadlines.keys():
			counter[eventName]+=1
			id0=line.split('[[')[1].split(']')[0]
			prevDictKey = eventName+'-'+id0
			print(prevDictKey)
			value=line.split('],')[1]
			all_intervals_sep=line.split('[(')[-1].split(')]')[0].split('),(')
			print(all_intervals_sep)
			deadline=eventsAndDeadlines[eventName]
			print('Deadline: ' + str(deadline))
			intervalsCount=0
			for intervalStr in all_intervals_sep:
				start = int(intervalStr.split(',')[0])
				end = int(intervalStr.split(',')[1])
				duration = end - start
				print('Duration: ' + str(duration))
				if duration==deadline:
					print("MATCH!!")
					print("in instance: " + str(counter[eventName]))
					matches[eventName].append(counter[eventName])
				if intervalsCount==0 and prevDictKey in previousIntervals and previousIntervals[prevDictKey][1]==start:
					durationAdj=end-previousIntervals[prevDictKey][0]
					print('DurationAdj: ' + str(durationAdj))
					if durationAdj==deadline:
						print("Adj MATCH!!")
						print("in instance: " + str(counter[eventName]))
						matches[eventName].append(counter[eventName])

				if intervalsCount==len(all_intervals_sep)-1:
					if prevDictKey in previousIntervals and previousIntervals[prevDictKey][1]==start:
						previousIntervals[prevDictKey]=(previousIntervals[prevDictKey][0], end)
					else:
						previousIntervals[prevDictKey]=(start, end)
				intervalsCount+=1
			if eventName in numberOfIntervals:
				numberOfIntervals[eventName]+=intervalsCount
			else:
				numberOfIntervals[eventName]=intervalsCount

for eventName in eventsAndDeadlines:
	print("For the event: " + eventName + ",")
	print("we have " + str(len(matches[eventName])) + ' uses of deadlines ')
	#print("at")
	#print(matches[eventName])
	print(" and " + str(numberOfIntervals[eventName]) + ' intervals.')

					
f.close()
