import numpy as np
import bisect

agents = ['test-many'] #, '2000', '4000', '8000']
endTime = '100'
seed = '1'

for agentNo in agents:
	no_delays_csv_name = 'negotiation-test-many' #'negotiation-' + agentNo + '-' + endTime + '-' + seed
	no_delays_csv_path = './' + no_delays_csv_name + '.csv'
	delays_folder_path = './delayed_files/'

	# uniform
	degree_of_sampling = [80] #[5, 10, 20, 40, 80]

	# gamma
	shape = 2 # 2
	scale = 5 # 2

	# offset
	#gamma_x_offset = 20



	def createDelayedStream(data_file, dg):
		delays_csv_path = delays_folder_path + 'agents_' + agentNo + '_' + endTime + '_gamma_delayed_' + str(dg) + '_no_upper_bound%.csv'
		c=0
		cdelays=0
		no_delays_file = open(no_delays_csv_path, 'r')
		delays_file = open(delays_csv_path, 'w')

		lines_buffer = list()
		
		while 1:
			line = no_delays_file.readline()
			if not line:
				break
			current_timestamp = int(line.split('|')[1])

			while len(lines_buffer)>0:
				#print(current_timestamp)
				if current_timestamp>=lines_buffer[0][0]:
					delays_file.write(lines_buffer[0][1])
					lines_buffer.pop(0)
					
				else:
					break
			if c%10000==0:
				print(c)
			if np.random.uniform(0.0,1.0)<=dg/100:
				delay = int(np.random.gamma(shape, scale)) 
				#if delay < delay_bounds[0]:
				#	delay = delay_bounds[0]
				#elif delay > delay_bounds[1]:
				#	delay = delay_bounds[1]
				#print(delay)
				#print(current_timestamp)
				#print()
				#print((delay+current_timestamp,line))
				#print(lines_buffer)
				bisect.insort_left(lines_buffer, (delay+current_timestamp,line))
				#print(lines_buffer)
				cdelays+=1
			else:
				delays_file.write(line)
			c+=1

		no_delays_file.close()

		for line in lines_buffer:
			delays_file.write(line[1])
		
		print(cdelays)
		delays_file.close()

	def check_delayed(dg):
		delays_csv_path = delays_folder_path + 'agents_' + agentNo + '_' + endTime + '_gamma_delayed_' + str(dg) + '_no_upper_bound%.csv'

		delays_file = open(delays_csv_path, 'r')
		maxT = 0
		c=0
		cDelayed=0
		for line in delays_file:
			if not line:
				break
			myT = int(line.split('|')[1])
			if maxT>myT:
				cDelayed+=1
			elif myT>maxT:
				maxT=myT
			c+=1
		print()
		print(cDelayed)
		print(c)
		delays_file.close()

	for dg in degree_of_sampling:

		createDelayedStream(no_delays_csv_path,dg)
		check_delayed(dg)
		print('dg = ' + str(dg) + ' OK!') 

	print('Agents ' + agentNo + ' Done!')


	


