import pandas as pd

flowSpec = pd.read_csv(r"C:\Users\User\Documents\4. Fourth Year\Project\Railway-Fares\Data Spec Files\\Flow.csv")
flowFile = pd.read_fwf(r"C:\Users\User\Documents\4. Fourth Year\Project\Railway-Fares\Data\Raw Fare Data\Split Out Data\flow", widths = flowSpec["Length"], header = None, names = flowSpec["Field Name"])
print(flowFile.head())
input()