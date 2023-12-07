import sys

inputFile=sys.argv[1]
f=open(inputFile+'.csv', 'r')
fw=open(inputFile+'-rtecComparison.csv', 'w')
counter=0
makeSeq=True
ignoreEvents=['vote']
for line in f:
	values = line.split('|')
	eventName=values[0]
	if eventName not in ignoreEvents:
		timestamp=values[1]
		parameters=values[3:]
		params_str=parameters[0]
		for i in range(1,len(parameters)):
			params_str+='|'+parameters[i].strip()
		if makeSeq==True:
			jrec_line=eventName+'|'+str(counter)+'|'+str(counter)+'|'+params_str
		else:	
			jrec_line=eventName+'|'+timestamp+'|'+timestamp+'|'+params_str
		fw.write(jrec_line + '\n')
		counter+=1
f.close()
fw.close()