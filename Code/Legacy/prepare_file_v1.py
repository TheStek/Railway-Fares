import pandas as pd
import time

"""

For this we want the file to come in in a list of strings, each being a line
The spec should be in the form {FIELDNAME:POSITION} where position is 'start-end'

"""

def parse_file(fileList, spec):	
	def parse_field(line, position):
		pos = position.split('-')
		return line[int(pos[0])-1:int(pos[1])]

	n = len(fileList)
	print(f"Parsing {n} lines...")
	time.sleep(2)
	x = 1
	output = []
	for line in fileList:
		lineMap = {}
		for i in range(len(spec)):
			field, position = spec.iloc[i]
			lineMap[field] = parse_field(line, position)
		output.append(lineMap)
		print(f"{round(x/n*100, 2)}% complete")
		x+= 1

	return output




spec = pd.read_csv("Data Spec Files/tabula-Data Spec-0.csv").dropna(subset = ["Position"])[["Field Name", "Position"]]


with open("Data/RJFAF053.FFL", 'r') as file:
	fileLines = list(filter( lambda x: x[1] == "F", file.read().split("\n")))

	print(parse_file([fileLines[0]], spec))



