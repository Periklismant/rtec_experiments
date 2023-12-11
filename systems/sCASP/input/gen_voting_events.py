import random
from sys import argv

def gen_voting(timeline_size, motions_no):
    open_prob=0.2
    close_prob=0.1

    fw=open('voting-'+ str(timeline_size) + '-' + str(motions_no) + '.pl', 'w')

    for t in range(1, timeline_size):
        for motion in range(motions_no):
            rand_prob=random.uniform(0,1)
            if rand_prob<open_prob:
                fw.write('happens(open_ballot(1,' + str(motion) + '), ' + str(t) + ').\n')
            elif rand_prob>1-close_prob:
                fw.write('happens(close_ballot(1,' + str(motion) + '), ' + str(t) + ').\n')


    fw.write('\n')
    fw.write('agent(1).\n')
    for motion in range(motions_no):
        fw.write('motion('+str(motion)+').\n')
    fw.close()
    return 

def voting_to_rtec_format(timeline_size, motions_no):

    f=open('voting-'+ str(timeline_size) + '-' + str(motions_no) + '.pl', 'r')
    fw=open('rtec-voting-'+ str(timeline_size) + '-' + str(motions_no) + '.pl', 'w')

    for line in f: 
        if "happens" in line:
            eventTemp, timepointTemp = line.strip().split("happens(")[1].split("), ")
            tp=timepointTemp.replace(").", "")
            eventName, ArgsTemp=eventTemp.split('(')
            arg1, arg2 = ArgsTemp.replace("(", "").split(',')
            fw.write(eventName + "|" + tp + "|" + tp + "|" + arg1 + "|" + arg2 + "\n")

    f.close()
    fw.close()
    return 

if __name__=="__main__":
    timeline_size=int(argv[1])
    motions_no=int(argv[2])
    voting_to_rtec_format(timeline_size,motions_no)

