import requests

url = "https://api.open-meteo.com/v1/forecast?latitude=24.7136&longitude=46.6753&hourly=temperature_2m,relative_humidity_2m&temperature_unit=fahrenheit"

response = requests.get(url)
data = response.json()

print(data)
print(len(data['hourly']['temperature_2m']))

url_j = "https://api.open-meteo.com/v1/forecast?latitude=21.4858&longitude=39.1925&hourly=temperature_2m,relative_humidity_2m&temperature_unit=fahrenheit"

response_j = requests.get(url_j)
data_j = response_j.json()

print(data_j)
print(len(data_j['hourly']['temperature_2m']))

import pandas as pd
df = pd.DataFrame(data['hourly'])
df["celsius"] = (df["temperature_2m"] - 32) * 5/9
print(df.head())
df.isnull().sum()

df_j = pd.DataFrame(data_j['hourly'])
df_j["celsius"] = (df_j["temperature_2m"] - 32) * 5/9
print(df_j.head())
df_j.isnull().sum()

from sqlalchemy import create_engine
connection_string = "postgresql://postgres.peiiwoitwfqxepcsrfgn:pass@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres"
engine = create_engine(connection_string)

df.to_sql('weather_riyadh', engine, if_exists='replace', index=False)
df_j.to_sql('weather_jeddah', engine, if_exists='replace', index=False)