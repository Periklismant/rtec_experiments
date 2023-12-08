from sys import argv 

FVPsbyApplication = {"simple_neg": ["val(x,0)", "val(x,1)", "val(y,0)", "val(y,1)", "occurs(f(x),0)", "occurs(f(x),1)", "occurs(f(y),0)", "occurs(f(y),1)"],
					"immune_g": ["val(h,0)", "val(h,1)", "val(h,2)", "val(s,0)", "val(s,1)", "val(s,2)",\
					"occurs(f(h),0)", "occurs(f(h),1)", "occurs(f(h),2)","occurs(f(s),0)", "occurs(f(s),1)", "occurs(f(s),2)"],
					"phage_g": ["val(cI,0)", "val(cI,1)", "val(cI,2)", "val(cro,0)", "val(cro,1)", "val(cro,2)", "val(cro,3)",\
								"val(cII,0)", "val(cII,1)", "val(n,0)", "val(n,1)",\
								"occurs(f(cI),0)", "occurs(f(cI),1)", "occurs(f(cI),2)","occurs(f(cro),0)", "occurs(f(cro),1)", "occurs(f(cro),2)", "occurs(f(cro),3)",\
								"occurs(f(cII),0)", "occurs(f(cII),1)", "occurs(f(n),0)", "occurs(f(n),1)"]
					}

def getInitsID(valsList):
	counter = 1
	currNum = 0
	for valStr in valsList:
		val = int(valStr)
		valID = val*counter
		currNum = currNum + valID
		counter = counter * 10
	return str(currNum)

def getFVPsOfApplication(inputFile):
	if "simple_neg" in inputFile:
		FVPs=FVPsbyApplication["simple_neg"]
	elif "immune_g" in inputFile:
		FVPs=FVPsbyApplication["immune_g"]
	elif "phage_g" in inputFile:
		FVPs=FVPsbyApplication["phage_g"]
	else:
		FVPs=list()
	return FVPs

def FVPtoString(FVP):
	FVPString = ""
	if "val" in FVP:
		FVPSpl = FVP.split(",")
		Var = FVPSpl[0].split("(")[1]
		Val = FVPSpl[1].split(")")[0]
		FVPString="val,[["+Var+"],"+Val+"]"
	elif "occurs" in FVP:
		FVPSpl = FVP.split(",")
		Func = FVPSpl[0].split("(")[1]
		Var = FVPSpl[0].split("(")[2].split(")")[0]
		Val = FVPSpl[1].split(")")[0]
		FVPString=Func+",[["+Var+"],"+Val+"]"
	return FVPString

def intervalListToString(intervals):
	intervalsStr=""
	for index in range(0, len(intervals)):
		intervalsStr+=intervals[index]
		if index<len(intervals)-1:
			intervalsStr+=","
	return intervalsStr


def createIntervalString(FVP, intervals):
	return "recognitions(predictions," + FVPtoString(FVP) +\
			",[" + intervalListToString(intervals) + ']).\n'

def createIntervalsFromTimePoints(timepoints):
	intervals=list()
	intStart=-1
	prev=-1

	for timepoint in timepoints:
		if intStart==-1 and prev==-1:
			intStart=timepoint 
			prev=timepoint
		elif timepoint==prev+1:
			prev=timepoint
		else:
			intervals.append("(" + str(intStart) + "," + str(prev+1) + ")")
			intStart=timepoint
			prev=timepoint

	if intStart!=-1 and prev!=-1:
		intervals.append("(" + str(intStart) + "," + str(prev+1) + ")")

	return intervals 



inputFile="../results/gklec/" + argv[1] + "-" + argv[2] + "-" + getInitsID(argv[3:]) +  ".txt"
outputFile="../results/gklec/" + argv[1] + "-" + argv[2] + "-" + getInitsID(argv[3:]) +  ".txt"
#print(inputFile)
f = open(inputFile, 'r')
timePointsDict = dict()
FVPs = getFVPsOfApplication(inputFile)
for FVP in FVPs:
	timePointsDict[FVP] = list()
prevLine=""
for line in f:
	for FVP in FVPs:
		if FVP in line and line!=prevLine: 
			timeStamp = int(line.split(',')[-1].split(')')[0])
			timePointsDict[FVP].append(timeStamp)
			prevLine=line
			break
f.close()
intervalsDict = dict()
for key in timePointsDict:
	intervalsDict[key]=createIntervalsFromTimePoints(timePointsDict[key])

fw = open(outputFile, 'w')
for key in intervalsDict:
	if len(intervalsDict[key])>0:
		fw.write(createIntervalString(key, intervalsDict[key]))

fw.close()


