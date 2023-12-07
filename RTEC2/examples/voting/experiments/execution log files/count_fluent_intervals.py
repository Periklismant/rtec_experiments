input_path = "log-votingDeadlinesTest-yap-80-10-4000-1-1-100-recognised-intervals.txt"
windowNo = 3
fluents=["status", "Per", "sanctioned"]
intervalsCount=dict()

for fluent in fluents:
	intervalsCount[fluent]=0

f = open(input_path, 'r')

for line in f:
	for fluent in fluents:
		if fluent in line:
			intervalsStr=line.split("],[")[1]
			intervalsNo = len(intervalsStr.split(","))/2
			#print(intervalsNo)
			intervalsCount[fluent]+=intervalsNo

print()
print("Final Count:")
intervalsFinalCount=0
for fluent in fluents:
	print("Fluent: " + fluent + " Count: " + str(intervalsCount[fluent]))
	intervalsFinalCount+=intervalsCount[fluent]

intervalsPerWindow = intervalsFinalCount/windowNo
print()
print("Average Number of FVP Intervals: " + str(intervalsPerWindow))