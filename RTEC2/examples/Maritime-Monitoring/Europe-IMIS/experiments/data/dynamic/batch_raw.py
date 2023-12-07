import csv

start_time=1451606401
end_time=1454284786
parts=6.0

diff=end_time-start_time
step=diff/parts
window=86400
i=1
t_e=int(start_time+step)
w = open('raw_points_rawsp_'+str(i)+'.csv', 'w')
with open('./preprocessed_dataset_RTEC_imis_enriched_nd.csv', 'r') as r:
    reader=csv.reader(r,delimiter='|')
    for line in reader:
        if int(line[1]) <= t_e:
            w.write('|'.join(line)+"\n")
        else:
            w.close()
            i=i+1
            if i > parts:
                break
            w = open('raw_points_rawsp_'+str(i)+'.csv', 'w')
            start_time=start_time+step
            t_e=int(start_time+step)
