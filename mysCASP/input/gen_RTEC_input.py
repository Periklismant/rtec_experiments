from sys import argv

agents = argv[1]

input_file = "netbill-"+agents+"-50.pl"

output_path = "/home/periklis/rtec/hub/examples/netbill/dataset/csv/"
output_file = output_path + "netbill-"+agents+"-50-1.csv"

f=open(input_file, 'r')
fw=open(output_file, 'w')

for line in f:
	if "happens" in line:
		_, event_name, rest = line.split('(')
		params, tpDirty, _ = rest.split(')')
		if event_name == "present_quote":
			merchant, consumer, goods, price = params.split(",")
			timepoint = tpDirty.replace(" ", "").replace(",", "")
			fw.write(event_name+'|'+timepoint+'|'+timepoint+'|'+merchant+'|'+consumer+'|'+goods+'|'+price+'\n')
		elif event_name == "accept_quote":
			merchant, consumer, goods = params.split(",")
			timepoint = tpDirty.replace(" ", "").replace(",", "")
			fw.write(event_name+'|'+timepoint+'|'+timepoint+'|'+merchant+'|'+consumer+'|'+goods+'\n')

f.close()
fw.close()
