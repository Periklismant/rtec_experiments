f = open("eventNarrative.txt", 'r')
inpFile = "input.txt"

for line in f:
	fw = open(inpFile, 'w')
	fw.write(line)
	fw.close()

f.close()