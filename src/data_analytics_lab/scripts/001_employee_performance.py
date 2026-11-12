'''
Il responsabile commerciale richiede un report aggiornato sulle 
performance dei dipendenti.

La query SQL esiste già (039_high_performing_employees.sql), ma il report deve essere prodotto automaticamente tramite Python.

L'obiettivo non è riscrivere la query, ma costruire il primo piccolo processo ETL del progetto.
Obiettivo
Scrivere uno script Python che:
1. legga la query SQL da file;
2. esegua la query su SQL Server;
3. carichi il risultato in un DataFrame;
4. ispezioni il dataset;
5. effettui eventuali conversioni dei tipi di dato;
6. esporti il risultato in CSV.
'''

import pandas as pd
from data_analytics_lab.database import get_engine
from pathlib import Path

engine = get_engine()

query_path = Path("sql/queries/039_high_performing_employees.sql")
query = query_path.read_text(encoding="utf-8")

df = pd.read_sql(query, engine)

print("First five rows of the Dataframe:")
print()
print(df.head())
print()

print("Dataframe infos:")
print()
df.info()
print()

print("Dytpes of columns:")
print()
print(df.dtypes)
print()

print("Checking existance of nulls:")
print()
print(df.isna().sum())

output_folder = Path("output")
output_folder.mkdir(exist_ok=True)

df.to_csv(output_folder / "employee_performance.csv", index=False)

'''
Obiettivo:
Creazione di un processo ETL per generare un report sulle performance degli
impiegati partendo dai dati presenti su SQL Server.

La query SQL viene mantenuta separata dal codice Python e viene caricata
dinamicamente per separare il livello di estrazione dal livello applicativo.

Il risultato della query viene trasformato in un DataFrame Pandas dove vengono
eseguiti controlli preliminari sulla qualità dei dati:
- verifica delle prime righe;
- analisi dei tipi di dato;
- controllo della presenza di valori NULL.

In questo caso non sono state necessarie trasformazioni sui tipi perché Pandas
ha correttamente interpretato i valori numerici e le colonne risultano già
utilizzabili per analisi successive.

Il dataset finale viene esportato in formato CSV per essere utilizzato come
output del processo analitico.
'''