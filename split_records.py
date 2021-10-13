	# File taken in as IO Text Wrapper object
# Conditions taken in as {name:filtering function}
def split_file(file, conditions):
	file = file.read().split('\n')
	print(f"Generating {conditions.keys()} files")
	for recordName in conditions.keys():
		print(f"Generating {recordName} file")
		outputFile = open(f"Data\\Split Out Data\\{recordName}", 'w')
		outputFile.write("\n".join(filter(conditions[recordName], file)))
		print(f"{recordName} file generated")
		outputFile.close()
	print("All files generated")

flow_conditions = {"flow": lambda x: x[1] == 'F', "fare": lambda x: x[1] == 'T'}

split_file(open("Data\\RJFAF053.FFL", 'r'), flow_conditions)