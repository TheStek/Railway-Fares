import numpy as np
import pandas as pd
import sklearn

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

import os
cwd = os.getcwd()
project_path = (cwd, None)
while project_path[1] != "Code":
    project_path = os.path.split(project_path[0])
project_path = project_path[0]

data_dz = pd.read_csv(project_path + "/Datasets/data_dz.csv")
data_in = pd.read_csv(project_path + "/Datasets/data_in.csv")
data_ca = pd.read_csv(project_path + "/Datasets/data_ca.csv")

def generate_train_val_test_set(df, name):
    
    df = df.dropna()
    
    output = {"train": {}, "val": {}, "test": {}, "name": name}
    
    train = df.sample(frac=0.7)
    val_test = df.drop(train.index)
    
    val = val_test.sample(frac=0.7)
    test = val_test.drop(val.index)

    output["train"]["y"] = np.ravel(train[["FARE"]])
    output["val"]["y"] = np.ravel(val[["FARE"]])
    output["test"]["y"] = np.ravel(test[["FARE"]])
    
    
    output["train"]["dist"] = train[["Distance", ]]
    output["val"]["dist"] = val[["Distance"]]
    output["test"]["dist"] = test[["Distance"]]
    
    output["train"]["dist_remoteness"] = train[["Distance","Dist_from_Ed.origin", "Dist_from_Gls.origin", "Dist_from_Ed.destination", "Dist_from_Gls.destination"]]
    output["val"]["dist_remoteness"] = val[["Distance","Dist_from_Ed.origin", "Dist_from_Gls.origin", "Dist_from_Ed.destination", "Dist_from_Gls.destination"]]
    output["test"]["dist_remoteness"] = test[["Distance","Dist_from_Ed.origin", "Dist_from_Gls.origin", "Dist_from_Ed.destination", "Dist_from_Gls.destination"]]

    output["train"]["simd"] = train[list(set(df.columns).difference({"ORIGIN_CODE", "DESTINATION_CODE", "Distance", "FARE"}))]
    output["val"]["simd"] = val[list(set(df.columns).difference({"ORIGIN_CODE", "DESTINATION_CODE", "Distance", "FARE"}))]
    output["test"]["simd"] = test[list(set(df.columns).difference({"ORIGIN_CODE", "DESTINATION_CODE", "Distance", "FARE"}))]

    output["train"]["full"] = train[list(set(df.columns).difference({"ORIGIN_CODE", "DESTINATION_CODE", "FARE"}))]
    output["val"]["full"] = val[list(set(df.columns).difference({"ORIGIN_CODE", "DESTINATION_CODE", "FARE"}))]
    output["test"]["full"] = test[list(set(df.columns).difference({"ORIGIN_CODE", "DESTINATION_CODE", "FARE"}))]
    
    return output.copy()

dataset_dz = generate_train_val_test_set(data_dz, "datazone")
dataset_in = generate_train_val_test_set(data_in, "intermediate zone")
dataset_ca = generate_train_val_test_set(data_ca, "council area")

datasets = (dataset_dz, dataset_in, dataset_ca)
subsets = ("dist", "simd", "full", "dist_remoteness")

import json

def append_to_json(data, path):
    try:
        with open(path, 'r') as f:
            existing = json.load(f)
            new_data = existing + [data]
    except FileNotFoundError:
        new_data = [data]
    with open(path, 'w') as f:
        json.dump(new_data, f)

def fit_and_evaluate_ML_model(method, method_name, dataset, subset = "full", log_name = None, *args, **kwargs):
    model = method(*args, **kwargs)
    model.fit(dataset["train"][subset], dataset["train"]["y"])
    val_score = model.score(dataset["val"][subset], dataset["val"]["y"])

    if log_name == -1:
        log_name = method_name

    output = kwargs.copy()
    output["method"] = method_name
    output["dataset"] = dataset["name"]
    output["subset"] = subset
    output["val_score"] = val_score
    
    if not log_name is None:
        append_to_json(output, project_path + "/Logs/" +log_name + ".json")
    else:
        print(output)
    
    return model

def check_on_all_data(method, method_name, log_name, *args, **kwargs):
    for dataset in datasets:
        for subset in subsets:
            try:
                fit_and_evaluate_ML_model(method, method_name, dataset, subset = subset, log_name = log_name, *args, **kwargs)
            except Exception as e:
                with open(project_path + "/Logs/errors.txt", 'a') as log:
                    log.write(",".join((method_name, dataset["name"], subset, str(e))))
                    
                    
def check_on_dataset(method, method_name, log_name, dataset = dataset_in, *args, **kwargs):
    for subset in subsets:
        try:
            fit_and_evaluate_ML_model(method, method_name, dataset, subset = subset, log_name = log_name, *args, **kwargs)
        except Exception as e:
            with open(project_path + "/Logs/errors.txt", 'a') as log:
                log.write(",".join((method_name, dataset["name"], subset, str(e))))