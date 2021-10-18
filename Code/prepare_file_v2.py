import pandas as pd

flowSpec = pd.read_csv("Data Spec Files\\Flow.csv")
flowFile = pd.read_fwf("Data\\Split Out Data\\flow", widths = flowSpec["Length"], header = None, names = flowSpec["Field Name"])
print(flowFile.head())