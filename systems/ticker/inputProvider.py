from time import sleep

f = open("eventNarrative.txt", 'r')
inpFile = "input.txt"

for line in f:
	fw = open(inpFile, 'w')
	print(line)
	fw.write(line)
	fw.close()

f.close()

