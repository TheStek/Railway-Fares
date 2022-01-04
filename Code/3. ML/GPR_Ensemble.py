import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import RBF
from sklearn.preprocessing import StandardScaler

class GPR_Ensemble:
    def __init__(self, n = 50, kernel = RBF(), scaling = True):
        
        """
        n: number of Gaussian ProcessRegressor models
        kernels: either an instantiated kernel or n instantiated kernels
        """
        self.n = n
        self.scaling = scaling
        
        if hasattr(kernel, '__iter__'):
            assert len(kernel) == n, "Invalid number of kernels"
            
            self.models = [GaussianProcessRegressor(kernel = k, copy_X_train = False) for k in kernel]
        else:
            self.models = [GaussianProcessRegressor(kernel = kernel, copy_X_train = False) for k in range(n)]
            
        
    
    # Fits GPR models on different 
    def fit(self, X, y):
        
        if self.scaling:
            self.scaler = StandardScaler().fit(X)
            X = self.scaler.transform(X)
        
        X_split = np.array_split(X, self.n)
        y_split = np.array_split(y, self.n)
        
        assert list(map(len, X_split)) == list(map(len, y_split)), "Error while splitting data"
        
        for i in range(self.n):
            self.models[i].fit(X_split[i], y_split[i])
            
            
    def predict(self, X):
        
        if self.scaling:
            X = self.scaler.transform(X)
        
        preds = []
        weights = []
        
        for model in self.models:
            prediction, std = model.predict(X, return_std=True)
            preds.append(prediction)
            weights.append(1/(std + 1e-8))
        
        preds = np.array(preds)
        weights = np.array(weights)
        
        return np.average(preds, axis = 0, weights = weights)
        
    def score(self, X, y):
        y_pred = self.predict(X)
        u = ((y - y_pred)** 2).sum()
        v = ((y - y.mean()) ** 2).sum()
        return 1 - u/v
        
    