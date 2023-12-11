from sys import argv

def rtec_csv_string(event_type,agent,motion,rtec_timestamp):
	return event_type+"|"+str(rtec_timestamp)+"|"+str(rtec_timestamp)+"|"+agent+"|"+motion+"\n"

input_file=argv[1]
output_file=argv[2]

f=open(input_file, 'r')
fw=open(output_file, 'w')

for line in f:
	if "tick" not in line:
		event_str, timestamp_str = line.split(" ")
		timestamp=int(timestamp_str)
		if timestamp%2==1:
			_, event_type, _, agent, motion_str = event_str.split(',')
			motion = motion_str.replace("[","").replace("]","")
			rtec_timestamp=(timestamp+1)
			fw.write(rtec_csv_string(event_type,agent,motion,rtec_timestamp))

f.close()
fw.close()

