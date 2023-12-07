import os
import subprocess

from difflib import Differ

for filename in os.listdir("FLECresults"):
	FLECfile = os.path.join("FLECresults", filename)
	RTECfile = os.path.join("results", filename)
	diffCommand = 'bash -c diff <(sort "' + FLECfile + '") <(sort "' + RTECfile + '")'
	#diff2Command = 'diff ' + FLECfile + ' ' + RTECfile 
	#print(diffCommand)
	subprocess.call("diff\ \<\(sort\ FLECresults/phage_g-50-1001.txt\)\ \<\(sort\ results/phage_g-50-1001.txt\)", shell=True)

	'''
	with open(FLECfile) as FLEC, open(RTECfile) as RTEC:
		differ = Differ()
		FLECsorted=sorted(FLEC)
		RTECsorted=sorted(RTEC)
		boolVal=True
		for line in differ.compare(FLECsorted, RTECsorted):
			if boolVal:
				print(filename)
				boolVal=False
				'''