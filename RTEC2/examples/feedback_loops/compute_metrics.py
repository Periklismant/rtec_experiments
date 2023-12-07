import os
from statistics import mean, stdev


directory = os.listdir('.')

directoryRTEC = os.listdir('./results')

searchstring = "time"

endtimes = ['100', '200', '400', '800']
apps = ['phage_g', 'immune_g']
times = dict()
for app in apps:
	for endtime in endtimes:
		for fname in directory:
			if os.path.isfile('.' + os.sep + fname):
				if searchstring in fname and endtime in fname and app in fname:
					f = open('.' + os.sep + fname, 'r')
					times = list()
					for line in f:
						msTime = int(line.strip())
						sTime = msTime/1000.0
						times.append(sTime)
					print('FLEC: App = ' + app + ' EndTime = ' + endtime + ' : avg = ' + str(mean(times)) + ', stdev = ' + str(stdev(times)))
					f.close()

		
		times=list()
		for fname in directoryRTEC:
			pathToFile = './results' + os.sep + fname 
			if os.path.isfile(pathToFile):
				if searchstring in fname and endtime in fname and app in fname:
					f = open(pathToFile, 'r')
					for line in f:
						if "Recognition Time average (ms)" in line:
							msTime = int(float(line.strip().split(':')[1]))
							sTime = msTime/1000.0
							times.append(sTime)
					f.close()
		print('RTEC: App = ' + app + ' EndTime = ' + endtime + ' : avg = ' + str(mean(times)) + ', stdev = ' + str(stdev(times)))
		