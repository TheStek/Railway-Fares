import json
import pandas as pd

file_mappings = json.loads(open("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Data Spec Files/dataspec.json", 'r').read())

for fname in file_mappings.keys():
	data_fname, spec_fname = file_mappings[fname]

	try:
		spec = pd.read_csv(spec_fname)
		try:
			data = pd.read_fwf(data_fname, widths = spec["Length"], header = None, names = spec["Field Name"])

			data = data[data.iloc[:, 0] != '/']

			data.to_csv(f"C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Data/Parsed Fare Data/{fname}.csv", index = False)
			print(f"Extracted {fname}")
		except Exception:
			print(f"Failed loading data file for {fname}")
	except Exception:
		print(f"Failed loading spec file for {fname}")

input()
	
