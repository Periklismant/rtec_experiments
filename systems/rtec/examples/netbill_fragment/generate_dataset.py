from sys import argv
from random import uniform,choice

events_no_str=argv[1] # > 100
# 30 agents seems ok 
agents_no=10 #30 # argv[2]
timeline_length=80
goods="book"
fw=open('dataset/csv/netbill-'+events_no_str+'.csv', 'w')

events_no=int(events_no_str)
events_per_timepoint=events_no/timeline_length

merchants=list(range(1,agents_no))
consumers=list(range(1,agents_no))

def gen_present_quote(t,merchant,consumer,goods):
	return "present_quote|"+str(t)+"|"+str(t)+"|"+merchant+"|"+consumer+"|"+goods+"|10\n"

def gen_accept_quote(t,merchant,consumer,goods):
	return "accept_quote|"+str(t)+"|"+str(t)+"|"+consumer+"|"+merchant+"|"+goods+"\n"

timepoint=1
event_at_tp=0
while timepoint<=timeline_length:
	prob=uniform(0,1)
	merch=str(choice(merchants))
	cons=str(choice(consumers))
	if prob>0.44:
		fw.write(gen_present_quote(timepoint,merch,cons,goods))
	else:
		fw.write(gen_accept_quote(timepoint,merch,cons,goods))
	event_at_tp+=1
	if event_at_tp+1>events_per_timepoint:
		timepoint+=1
		event_at_tp=0

fw.close()
	
	
