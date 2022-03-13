import pandas as pd
import numpy as np

from data_helper import *

train = dataset_in["train"]["full"].copy()
train['FARE'] = dataset_in["train"]["y"]

print(train.head())

train.to_csv("Train Data.csv", index = False)