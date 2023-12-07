from os import sys, path

import sys
from multiprocessing import Process
from os import listdir
from os.path import isfile, join, exists
import argparse
import subprocess, os, time, re
from time import sleep
import timeit
import shutil
import string
import csv
import math
#import psycopg2
import random
#import matplotlib.pyplot as plt
#import matplotlib as mpl
import numpy as np
import itertools
from datetime import datetime
import collections
from itertools import islice


#topDir = os.environ['WORK']

inc_RTEC_data_file = './preprocessed_dataset_RTEC_critical_nd.csv'
results_dir = './delayed_files/'

degree_of_sampling = [40]

# gamma
shape = 2
scale = 5

#uniform
delay_bounds = [3600*1, 3600*12] # 12 - 168


def main():

	for dg in degree_of_sampling:

		delayed_data = createDelayedStream(inc_RTEC_data_file,dg)

		checkfile(dg)

	print('Done!')


def checkfile(dg):

	delayed_file = results_dir + 'gamma_delayed_' + str(dg) + '%.csv'

	with open(delayed_file) as df:
		csv_fr = csv.reader(df, delimiter='|')
		prev = 0
		for row in csv_fr:
			if row[0] == 'coord':
				prev = 1
			elif prev == 1 and row[0] != 'velocity':
				print(delayed_file + " not ok!!")
				print(row)
				return
				#prev = 0
			else:
				prev = 0

	print(delayed_file + " ok!!")


def createDelayedStream(data_file, dg):

	delayed_file = results_dir + 'gamma_delayed_' + str(dg) + '%.csv'

	with open(data_file) as f:

		nl = sum(1 for _ in f)
		print("nl value: " + str(nl))
		with open(data_file) as df:
			csv_fr = csv.reader(df, delimiter='|')
			steps = 10
			st = nl/steps
			print("st value: " + str(st))
			coord_indexes = []
			cur_id = 0
			for n, row in enumerate(csv_fr):
				if n >= cur_id and row[0] == 'coord':
					coord_indexes.append(n)
					cur_id += st

					if n == nl - 1:
						coord_indexes.append(n+1)

			if len(coord_indexes) > steps + 1:
					coord_indexes[-2] = coord_indexes[-1]
					coord_indexes = coord_indexes[:-1]
		print('Coords indexes:' +  str(coord_indexes))

	with open(delayed_file, 'w') as wf:

		csv_wr = csv.writer(wf, delimiter='|')

		out_samples = []

		#print coord_indexes

		for i in range(len(coord_indexes)-1):

			with open(data_file) as df:

				csv_fr = csv.reader(df, delimiter='|')
				sl = iter(islice(csv_fr, coord_indexes[i], coord_indexes[i+1]+1))

				lines = []
				tmp = [next(sl)]
				#print tmp

				for row in sl:

					if row[0] != 'coord' and row[0] != 'entersArea' and row[0] != 'leavesArea' and \
									row[0] != 'proximity':
						tmp.append(row)
					elif row[0] == 'coord':
						if tmp:
							lines.append(tmp)
						tmp = [row]
					else:
						if tmp:
							lines.append(tmp)
							tmp = []
						lines.append([row])

				if i == len(coord_indexes)-2 and tmp:
					lines.append(tmp)

				nl_sl = len(lines)

				sample_size = int(round(nl_sl * float(dg / 100.0)))

				sample_ids = np.random.choice(nl_sl, sample_size, replace=False)
				sample_ids = np.sort(sample_ids).tolist()

				#sample_dl = np.random.choice(np.arange(delay_bounds[0], delay_bounds[1]), sample_size)
				sample_dl = list(map(lambda x: int(x*delay_bounds[0]), np.random.gamma(shape, scale, sample_size)))

				for n, el in enumerate(sample_dl):

					if el < delay_bounds[0]:
						sample_dl[n] = delay_bounds[0]
					elif el > delay_bounds[1]:
						sample_dl[n] = delay_bounds[1]

				if out_samples is None:
					samples = []
				else:
					samples = out_samples
					out_samples = []

				last_time = 0

				lineno = sample_ids.pop(0)
				c = 1

				for n, l in enumerate(lines):
					#print l						
					if n == lineno:
						#if len(l) > 3:
						#	print l
						#	item = [random.choice(l[2:])]
						#	item = l[0:2] + item
						#	l.remove(item[0])
						#	print l
						#	samples.append([l, int(item[0][1])])
						#else:
						item = l
						samples.append([item, int(item[0][1]) + sample_dl[c-1]])
						if c < sample_size:
							lineno = sample_ids.pop(0)
							c += 1
						else:
							#print l
							samples.append([l, int(l[0][1])])

						if n == nl_sl - 1:
							last_time = int(l[0][1])
					else:
						samples.append([l, int(l[0][1])])

				samples.sort(key=lambda x: x[1])
				del lines, sample_ids, sample_dl

				for s in samples:
					#print(s)
					if s[1] <= last_time:
						csv_wr.writerows(s[0])
					else:
						out_samples.append(s)

				del samples

				if i == len(coord_indexes)-2:
					for s in out_samples:
						csv_wr.writerows(s[0])

	return delayed_file



if __name__ == "__main__":
	main()


