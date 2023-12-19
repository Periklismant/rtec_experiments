from sys import argv

agentsNo = argv[1]
inpFile = "log-" + agentsNo + '.txt'
merchants=set()
consumers=set()
holdsAtTPs = dict()

f = open(inpFile, 'r')
for line in f:
	 if "HoldsAt" in line and "quote" in line and "NEG" not in line:
	 	_, timeDirty, _, merchantDirty, consumerDirty, _ = line.split('(')
	 	time = timeDirty.split(',')[0]
	 	merchant = merchantDirty.split(')')[0]
	 	consumer = consumerDirty.split(')')[0] 
	 	if (merchant, consumer) not in holdsAtTPs:
	 		holdsAtTPs[(merchant, consumer)] = [time]
	 	else: 
	 		holdsAtTPs[(merchant, consumer)].append(time)
f.close()

fw = open('rec-' + agentsNo + '.txt', 'w') 
for (merchant, consumer) in holdsAtTPs:
	fw.write('quote between merchant ' + merchant + ' and consumer ' + consumer + ' at ' + str(holdsAtTPs[(merchant, consumer)]) + '\n')
fw.close()