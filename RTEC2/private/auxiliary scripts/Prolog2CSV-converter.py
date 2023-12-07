from string import *
import sys


for f in sys.argv[1:]:
	fl = open(f, "r")
	out = open(f.split('.prolog')[0]+'.csv', "w")
	for l in fl.readlines():
		if(l=="\n" or l=="" or l==" "):
			continue
		if(l[:6]=="update"):
			continue

		l=l.replace(' ' ,'')

		if(l.find('happensAt')!=-1):
			name= l.split('AtIE(')[1].split('(')[0]
			time= l.split('))')[0].split(',')[-1]
			att=l.split('AtIE(')[1].split(')')[0].split('(')[1].replace(',', '|')
			out.write(name+'|'+time+'|'+time+'|'+att+'\n')
		elif(l.find('holdsAt')!=-1):
                        name= l.split('AtIE(')[1].split('(')[0]
			time= l.split('))')[0].split(',')[-1]
			value= l.split('=')[1].split(',')[0]
			att= l.split('AtIE(')[1].split(')')[0].split('(')[1].replace(',', '|')
			out.write(name+'|'+time+'|'+time+'|'+value+'|'+att+'\n')
		elif(l.find('holdsFor')!=-1):
			name=l.split('IESI(')[1].split('(')[0]
			times=l.split('(')[-1].split(',')[0]
			timee=l.split('(')[-1].split(',')[1].split(')')[0]
			value=l.split('=')[1].split(',')[0]
			att=l.split('IESI(')[1].split('(')[1].split(')')[0].replace(',', '|')
			out.write(name+'|'+timee+'|'+times+'|'+timee+'|'+value+'|'+att+'\n')
	fl.close()
	out.close()
