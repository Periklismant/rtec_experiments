import csv	

file1 = './preprocessed_dataset_RTEC_critical_nd.csv'
file2 = './gamma_delayed_5%.csv'

c = 0
f1=open(file1, 'r')
f2=open(file2, 'r')

while 1:
	line1 = f1.readline()
	line2 = f2.readline()

	if not line1 or not line2:
		break
	elif line1!= line2:
		print(line1)
		print(line2)
		print('Diff found in line: ' + str(c))
		exit(1)
	c+=1
f1.close()
f2.close()
		