/*
Il responsabile commerciale vuole analizzare l'andamento del fatturato nel tempo 
riducendo l'effetto delle oscillazioni mensili.

L'obiettivo è calcolare una media mobile a 3 mesi del fatturato totale aziendale, 
così da individuare meglio i trend di crescita o calo.
Vincoli
- Il fatturato mensile è calcolato come: Quantity × UnitPrice
*/

WITH MonthlyRevenueData AS (
    SELECT 
        YEAR(OrderDate) AS Year_,
        MONTH(OrderDate) AS Month_,
        SUM(od.Quantity * od.UnitPrice) AS MonthlyRevenue
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT *,
    AVG(MonthlyRevenue) OVER (
        ORDER BY Year_, Month_
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage3M
FROM MonthlyRevenueData;

/*
Il grain finale dell'output è rappresentato da una riga per ogni mese.

La prima fase aggrega il fatturato aziendale a livello mensile utilizzando le
informazioni presenti nelle tabelle Orders e Order Details.

La funzione AVG con window frame calcola una media mobile considerando il mese
corrente e i due mesi precedenti disponibili tramite ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW.

Il window frame permette di analizzare l'andamento del fatturato nel tempo
riducendo l'effetto delle variazioni mensili isolate e mettendo in evidenza
trend più stabili.
*/