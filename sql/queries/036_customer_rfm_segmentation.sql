/*
Il marketing vuole segmentare i clienti sulla base del comportamento storico.

Calcolare per ogni cliente:
- CustomerID
- CompanyName
- Recency → giorni trascorsi dall'ultimo ordine
- Frequency → numero totale di ordini
- Monetary → fatturato totale generato
Successivamente assegnare un punteggio:
- Recency score (1-5)
- Frequency score (1-5)
- Monetary score (1-5)
usando i quintili della distribuzione.
Vincoli
- Il riferimento temporale per la recency è la data massima presente negli ordini.
- Il ranking deve essere fatto tra tutti i clienti.
- Per gli score usare le window function.
*/

WITH CustomerRFM AS (
SELECT 
    c.CustomerID,
    c.CompanyName,
    DATEDIFF(DAY, MAX(o.OrderDate), (SELECT MAX(OrderDate) FROM Orders)) AS Recency,
    COUNT(DISTINCT o.OrderID) AS Frequency,
    SUM(od.UnitPrice * od.Quantity) AS Monetary
FROM 
    Customers c
JOIN Orders o 
    ON c.CustomerID = o.CustomerID
JOIN [Order Details] od 
    ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerID, c.CompanyName
)
SELECT *,
    NTILE(5) OVER (ORDER BY Recency DESC) AS RecencyScore,
    NTILE(5) OVER (ORDER BY Frequency DESC) AS FrequencyScore,
    NTILE(5) OVER (ORDER BY Monetary DESC) AS MonetaryScore
FROM CustomerRFM;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente.

La CTE calcola le tre metriche fondamentali dell'analisi RFM:
- Recency: giorni trascorsi dall'ultimo ordine del cliente rispetto alla data
  più recente presente nel dataset.
- Frequency: numero totale di ordini effettuati dal cliente.
- Monetary: fatturato complessivo generato dal cliente.

Le metriche vengono successivamente trasformate in punteggi tramite la funzione
NTILE(5), suddividendo i clienti in cinque gruppi di pari numerosità in base
alla distribuzione dei valori.

Il risultato costituisce una segmentazione RFM utile per identificare clienti
ad alto valore, clienti fedeli e clienti inattivi, supportando attività di
marketing e customer relationship management.
*/