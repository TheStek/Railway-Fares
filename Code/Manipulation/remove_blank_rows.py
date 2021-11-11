import os
import pandas as pd 

directory = os.fsencode("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Data Spec Files")
    
for file in os.listdir(directory):
	filename = os.fsdecode(file)
	if filename.endswith(".csv"):
		df = pd.read_csv(f"Data Spec Files\\{filename}", header = None)
		print(df.head())
		df = df.dropna(subset = [1])
		df.to_csv(f"Data Spec Files\\{filename}", index = False)
