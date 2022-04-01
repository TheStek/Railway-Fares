import numpy as np
import pandas as pd

from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

from data_helper import *

X_train = dataset_in["train"]["full"].copy()
y_train = dataset_in["train"]["y"].copy()

features = X_train.columns

from sklearn.inspection import permutation_importance
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler

results = []

def calculate_importance(model, model_name, n_repeats = 10):

    model.fit(X_train, y_train)
    result = permutation_importance(model, X_train, y_train, n_repeats = n_repeats)
    del result["importances"]

    df = pd.DataFrame(result)
    df["feature"] = features
    df["model"] = model_name
    df["n"] = n_repeats
    
    results.append(df)
    

from sklearn.linear_model import LinearRegression

calculate_importance(LinearRegression(), "lin_reg")


from sklearn.ensemble import RandomForestRegressor

calculate_importance(RandomForestRegressor(max_samples = 0.7), "rfr")


from GPR_Ensemble import GPR_Ensemble
from sklearn.gaussian_process.kernels import RationalQuadratic

calculate_importance(GPR_Ensemble(kernel = RationalQuadratic(alpha = 0.1), bootstrap = True), "gpr_ensemble", n_repeats = 5)

from sklearn.svm import SVR
calculate_importance(SVR(kernel = 'rbf', C = 1000, max_iter =1e5, epsilon = 0.5), "svr", n_repeats = 5)


pd.concat(results).to_csv("Permutation Importance Results.csv", index = False)