from sys import argv
from random import uniform,choice

events_no_str=argv[1] # > 100
# 30 agents seems ok 
motions_no=8 #30 # argv[2]
timeline_length=40
agent="1"
fw=open('dataset/csv/voting-'+events_no_str+'.csv', 'w')

events_no=int(events_no_str)
events_per_timepoint=events_no/timeline_length

motions=list(range(1,motions_no))

def gen_open_ballot(t,motion,agent):
	return "open_ballot|"+str(t)+"|"+str(t)+"|"+motion+"|"+agent+"\n"

def gen_close_ballot(t,motion,agent):
	return "close_ballot|"+str(t)+"|"+str(t)+"|"+motion+"|"+agent+"\n"

timepoint=1
event_at_tp=0
while timepoint<=timeline_length:
	prob=uniform(0,1)
	motion=str(choice(motions))
	if prob>0.44:
		fw.write(gen_open_ballot(timepoint,motion,agent))
	else:
		fw.write(gen_close_ballot(timepoint,motion,agent))
	event_at_tp+=1
	if event_at_tp+1>events_per_timepoint:
		timepoint+=1
		event_at_tp=0

fw.close()
	
	
