import os
from statistics import mean, stdev

inc_RTEC_data_file = './preprocessed_dataset_RTEC_imis_critical_nd.csv'
f = open(inc_RTEC_data_file, 'r')
delayedNo = 0
delays=list()
total = 0
for line in f:
	lineSpl = line.split('|')
	if lineSpl[1]!=lineSpl[2]:
		delays.append((int(lineSpl[1]) - int(lineSpl[2])))
		delayedNo+=1
	if total%1000000==0:
		print(line)
		print(len(delays))
	total +=1
f.close()
delays.sort()
print("Delayed Events Number: " + str(delayedNo))
print("Total Events Number: " + str(total))
print("Delayed Percentage: " + str(delayedNo/total*100) + "%")
print("Delay Mean: " + str(mean(delays)))
print("Delay Min: " + str(delays[0]))
print("Delay Min: " + str(delays[-1]))
print("Delay Stdev: " + str(stdev(delays)))