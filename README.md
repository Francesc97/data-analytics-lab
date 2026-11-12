# Data Analytics Lab

Portfolio di analisi dati su SQL Server e Python, costruito partendo da
requisiti di business realistici invece che da esercizi di sintassi
isolati.

L'obiettivo del progetto è sviluppare un flusso di lavoro end-to-end per
analisi dati, dalla modellazione della domanda di business fino
all'estrazione, trasformazione e analisi dei dati.

------------------------------------------------------------------------

## Cosa dimostra questo repository

-   Capacità di tradurre una richiesta di business in una soluzione
    analitica, partendo dalla definizione del **grain** del dataset
    finale.
-   Padronanza di SQL avanzato: CTE semplici e concatenate, window
    function, window frame, analisi temporali, analisi di coorte,
    segmentazione RFM e utilizzo di `HAVING` su risultati aggregati.
-   Capacità di individuare e correggere errori di logica analitica, non
    soltanto errori di sintassi.
-   Capacità di costruire un flusso di lavoro integrato **SQL Server →
    Python (SQLAlchemy/Pandas)**.
-   Utilizzo di un ambiente riproducibile tramite Docker e gestione del
    progetto Python tramite package structure.

------------------------------------------------------------------------

## Stato del progetto

### Fase 1 --- SQL avanzato su Northwind

Completata.

Include:

-   fondamentali SQL (`JOIN`, `GROUP BY`, subquery);
-   CTE semplici e concatenate;
-   gestione del grain e del livello di aggregazione;
-   window function:
    -   `ROW_NUMBER`;
    -   `RANK` / `DENSE_RANK`;
    -   `LAG` / `LEAD`;
    -   `NTILE`;
-   window frame:
    -   rolling analysis;
    -   cumulative analysis;
-   analisi temporali:
    -   crescita YoY;
    -   trend mensili;
    -   analisi coorti;
-   segmentazione clienti tramite RFM.

### Fase 2 --- Python + SQLAlchemy + Pandas

In corso.

Obiettivi:

-   estrazione dati da SQL Server;
-   validazione e pulizia dei DataFrame;
-   analisi temporali con Pandas;
-   pipeline ibride SQL/Python;
-   produzione di output analitici.

------------------------------------------------------------------------

## Stack tecnologico

-   Python 3.13
-   SQL Server 2022
-   Docker Compose
-   SQLAlchemy
-   PyODBC
-   Pandas
-   VS Code
-   Git / GitHub
-   uv per gestione ambiente e dipendenze

------------------------------------------------------------------------

## Struttura del progetto

``` text
data-analytics-lab
│
├── sql/
│   ├── setup/
│   │   └── northwind.sql
│   │
│   └── queries/
│
├── src/
│   └── data_analytics_lab/
│       ├── scripts/
│       ├── database.py
│       ├── extract_data.py
│       └── __init__.py
│
├── output/
│
├── compose.yaml
├── pyproject.toml
├── uv.lock
└── README.md
```

------------------------------------------------------------------------

## Setup ambiente

### Avvio SQL Server tramite Docker

``` bash
docker compose up -d
```

### Installazione dipendenze

``` bash
uv sync
```

### Configurazione variabili ambiente

Creare un file `.env` contenente i parametri di connessione al database.

Il file `.env` non viene versionato tramite Git.

------------------------------------------------------------------------

## Metodo di lavoro

Ogni analisi nasce da una domanda di business.

Prima di scrivere la query vengono definiti:

-   il risultato atteso;
-   il grain finale del dataset;
-   le tabelle necessarie;
-   il livello corretto di aggregazione.

Ogni esercizio viene sviluppato considerando:

-   correttezza logica;
-   gestione delle join;
-   controllo della duplicazione dei dati;
-   scelta delle trasformazioni più appropriate.

L'obiettivo non è soltanto scrivere query funzionanti, ma progettare
analisi dati seguendo un approccio simile a un contesto lavorativo
reale.

------------------------------------------------------------------------

## Esempio: segmentazione RFM

**Domanda di business:**\
Il team marketing vuole segmentare i clienti sulla base del
comportamento storico per identificare clienti ad alto valore, fedeli o
inattivi.

Il grain finale scelto è:

``` text
1 riga = 1 cliente
```

``` sql
WITH CustomerRFM AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        DATEDIFF(
            DAY,
            MAX(o.OrderDate),
            (SELECT MAX(OrderDate) FROM Orders)
        ) AS Recency,
        COUNT(DISTINCT o.OrderID) AS Frequency,
        SUM(od.UnitPrice * od.Quantity) AS Monetary
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY 
        c.CustomerID,
        c.CompanyName
)
SELECT *,
    NTILE(5) OVER (ORDER BY Recency DESC) AS RecencyScore,
    NTILE(5) OVER (ORDER BY Frequency ASC) AS FrequencyScore,
    NTILE(5) OVER (ORDER BY Monetary ASC) AS MonetaryScore
FROM CustomerRFM;
```

La direzione degli score è stata uniformata:

``` text
1 = peggiore performance
5 = migliore performance
```

Questo permette di combinare le tre dimensioni e identificare segmenti
ad alto valore.

------------------------------------------------------------------------

## Revisione critica

Durante lo sviluppo sono emersi alcuni problemi di logica analitica
successivamente corretti:

-   **RFM --- direzione degli score incoerente**\
    La prima versione assegnava bucket migliori ai clienti con score più
    bassi per alcune metriche. Gli ordinamenti sono stati corretti per
    mantenere una convenzione uniforme tra Recency, Frequency e
    Monetary.

-   **Retention per coorte --- utilizzo di valori assoluti**\
    Una prima versione misurava il numero assoluto di clienti attivi
    senza normalizzare rispetto alla dimensione iniziale della coorte.
    La metrica è stata rivista per rappresentare correttamente il tasso
    di retention.

------------------------------------------------------------------------

## Obiettivo finale

Costruire un portfolio che dimostri non soltanto conoscenza degli
strumenti, ma capacità di:

-   analizzare problemi reali;
-   progettare dataset corretti;
-   scegliere dove applicare SQL e Python;
-   costruire pipeline riproducibili.
