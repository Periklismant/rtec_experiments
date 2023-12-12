import itertools

loop_vars_dict = {
		"simple_loop": ["x", "y"],
		"immune": ["h", "s"],
		"phage": ["cI", "cro", "cII", "n"]
		}

var_vals_dict = {
		"x": [0,1],
		"y": [0,1],
		"h": [0,1,2],
		"s": [0,1,2],
		"cI": [0,1,2],
		"cro": [0,1,2,3],
		"cII": [0,1],
		"n": [0,1]
	}

def write_variables(fw, loop):
	if loop=="simple_loop":
		fw.write("variable(x).\nvariable(y).\n")
	elif loop=="immune":
		fw.write("variable(h).\nvariable(s).\n")
	elif loop=="phage":
		fw.write("variable(cI).\nvariable(cro).\nvariable(cII).\nvariable(n).\n")
	else:
		print("ERROR")
		exit(1)
	return


def write_loop_config(fw, loop, config):
	write_variables(fw, loop)
	fw.write('\n')
	if loop=="simple_loop":
		fw.write("initially(val(x)="+str(config[0])+").\ninitially(val(y)="+str(config[1])+").\n")
	elif loop=="immune":
		fw.write("initially(val(h)="+str(config[0])+").\ninitially(val(s)="+str(config[1])+").\n")
	elif loop=="phage":
		fw.write("initially(val(cI)="+str(config[0])+").\ninitially(val(cro)="+str(config[1])+").\ninitially(val(cII)="+str(config[2])+").\ninitially(val(n)="+str(config[3])+").\n")
	else:
		print("ERROR")
		exit(1)
	return
	

file_name_prefix = "inits_"
file_name_suffix = ".prolog"
for loop in loop_vars_dict:
	config_space=list()
	for var in loop_vars_dict[loop]:
		config_space.append(var_vals_dict[var])
	for config in itertools.product(*config_space):
		file_name=file_name_prefix+loop
		for val in config:
			file_name+="_"+str(val)
		file_name+=file_name_suffix
		fw=open(file_name, 'w')
		write_loop_config(fw, loop, config)
		fw.close()

