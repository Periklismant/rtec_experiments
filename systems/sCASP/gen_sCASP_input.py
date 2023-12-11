from sys import argv

path_prefix = "/home/periklis/Desktop/RTEC2_updated/RTEC2/examples/negotiation/experiments/data/csv/"

agentsNo = int(argv[1])
timepointsNo = argv[2]

consumers=set()
merchants=set()

input_file = path_prefix + "negotiation-16-50-1.csv"
output_file = "input/netbill-" + str(agentsNo) + "-" + timepointsNo + ".pl"
prevTp = "-1"
f = open(input_file, 'r')
fw = open(output_file, 'w')
for line in f:
	lineSpl = line.strip().replace('\n','').split("|")
	event_name = lineSpl[0]
	timepoint = lineSpl[1]
	if timepoint!= prevTp:
		cache = set()
	if line not in cache and "music" not in line:
		fact_prefix = "happens(" + event_name + "("
		fact_suffix = "), " + timepoint + ").\n"
		
		if event_name=='present_quote': #4 args
			_, _, _, merchant, consumer, goodsDescr, price = lineSpl
			if int(merchant)%10==0 and (merchant in merchants or len(merchants)<agentsNo):
				if int(consumer)%3>0 and (consumer in consumers or len(consumers)<agentsNo):
					fw.write(fact_prefix+merchant+","+consumer+','+goodsDescr+','+price+fact_suffix)
					if len(merchants)<agentsNo:
						merchants.add(merchant)
					if len(consumers)<agentsNo:
						consumers.add(consumer)
		
		elif event_name==event_name=='accept_quote':
			_, _, _, merchant, consumer, goodsDescr = lineSpl
			if int(merchant)%10==0 and (merchant in merchants or len(merchants)<agentsNo):
				if int(consumer)%3>0 and (consumer in consumers or len(consumers)<agentsNo):
					fw.write(fact_prefix+merchant+","+consumer+','+goodsDescr+fact_suffix)
					if len(merchants)<agentsNo:
						merchants.add(merchant)
					if len(consumers)<agentsNo:
						consumers.add(consumer)
		'''
		elif event_name=='send_goods': #4 args
			_, _, _, merchant, consumer, goodsDescr, price, fifth = lineSpl
			if int(merchant)%10==0 and (merchant in merchants or len(merchants)<agentsNo):
				if int(consumer)%3>0 and (consumer in consumers or len(consumers)<agentsNo):
					fw.write(fact_prefix+merchant+","+consumer+','+goodsDescr+','+price+','+fifth+fact_suffix)
					if len(merchants)<agentsNo:
						merchants.add(merchant)
					if len(consumers)<agentsNo:
						consumers.add(consumer)
		'''
		cache.add(line)
	prevTp = timepoint
f.close()

fw.write('\n')

for m in merchants:
	fw.write("merchant("+str(m)+").\n")

for c in consumers:
	fw.write("consumer("+str(c)+").\n")

'''
for m in range(0, int(agentsNo)):
	if m%10==0:
		fw.write("merchant("+str(m)+").\n")

for c in range(0, int(agentsNo)):
	if c%3>0:
		fw.write("consumer("+str(c)+").\n")
'''
fw.close()
