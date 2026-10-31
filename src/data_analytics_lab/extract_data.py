import pandas as pd
from data_analytics_lab.database import get_engine

engine = get_engine()

with open("sql/queries/first_request.sql") as f:
    query = f.read()

df = pd.read_sql(query, engine)
print(df)