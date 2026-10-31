from data_analytics_lab.database import get_engine

engine = get_engine()

with engine.connect() as connection:
    print("Connessione a SQL Server riuscita!")