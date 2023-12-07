from random import random

prob1 = 0.5
prob2 = 0.5
prob3 = 0.5
prob4 = 0.5
prob5 = 0.5
step = 1
startT=1
lineNum=1000

customers=range(2,100,3)
merchants=range(10,200,10)

def create_line(linePrefix, T, lineSuffix):
	line = linePrefix + str(T) + '|' + str(T) + lineSuffix + '\n'
	return line

def create_line_request(merchant, customer, T):
	linePrefix='request_quote|'
	lineSuffix='|' + str(merchant) + '|' + str(customer) +'|book'
	line = linePrefix + str(T) + '|' + str(T) + lineSuffix + '\n'
	return line

def create_line_present(merchant, customer, T):
	linePrefix='present_quote|'
	lineSuffix='|' + str(merchant) + '|' + str(customer) +'|book|5'
	line = linePrefix + str(T) + '|' + str(T) + lineSuffix + '\n'
	return line

def create_line_accept(merchant, customer, T):
	linePrefix='accept_quote|'
	lineSuffix='|' + str(merchant) + '|' + str(customer) +'|book'
	line = linePrefix + str(T) + '|' + str(T) + lineSuffix + '\n'
	return line

def create_line_EPO(merchant, T):
	linePrefix='send_EPO|'
	lineSuffix='|' + str(merchant) + '|iServer|book|10'
	line = linePrefix + str(T) + '|' + str(T) + lineSuffix + '\n'
	return line

def create_line_good(customer, T):
	linePrefix='send_goods|'
	lineSuffix='|' + str(customer) + '|iServer|book|key|dec'
	line = linePrefix + str(T) + '|' + str(T) + lineSuffix + '\n'
	return line

f = open("./negotiation-test-many-3.csv", 'w')

#f.write(create_line('present_quote|', 1, '|10|2|book|5'))
#f.write(create_line('accept_quote|', 3, '|2|10|book'))

for T in range(startT,lineNum+1, step):
	for cust in customers:
		for merch in merchants:
			rand1 = random()
			if rand1>prob1:
				f.write(create_line_present(merch, cust, T))
			rand2 = random()
			if rand2>prob2:
				f.write(create_line_present(merch, cust, T))
			rand3 = random()
			if rand3>prob3:
				f.write(create_line_accept(merch, cust, T))
			rand4 = random()
			if rand4>prob4:
				f.write(create_line_EPO(merch, T))
			rand5 = random()
			if rand5>prob5:
				f.write(create_line_good(cust, T))				
			#else:
			#	f.write(create_line_term(T))
	if T % 10000==0:
		print(T)
print('DONE')
f.close()