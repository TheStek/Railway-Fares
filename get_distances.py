import numpy as np
import pandas as pd

def haversine_np(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)

    All args must be of equal length.    

    """
    lon1, lat1, lon2, lat2 = map(np.radians, [lon1, lat1, lon2, lat2])

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = np.sin(dlat/2.0)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon/2.0)**2

    c = 2 * np.arcsin(np.sqrt(a))
    km = 6367 * c
    return km



df = pd.read_csv("Data/Station Locations.csv")

print(df.columns)

df = df.loc[df["Operator"].str.contains("Scotrail", na = False)][['Latitude', 'Longitude', 'Station']]

df_origin = df.rename(columns =  {"Latitude": "lat1", "Longitude": "lon1", "Station" : "Origin"})
df_dest = df.rename(columns = {"Latitude": "lat2", "Longitude": "lon2", "Station" : "Destination"})

df_cross = df_origin.merge(df_dest, how = "cross")

print(df_cross.columns, len(df_cross))

df_cross["Distance"] = haversine_np(df_cross["lon1"], df_cross["lat1"], df_cross["lon2"], df_cross["lat2"])


df_out = df_cross[df_cross["Origin"] != df_cross["Destination"]]

df_out.to_csv("Data/distances.csv", index = False)