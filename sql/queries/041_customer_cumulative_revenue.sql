/*
Il responsabile commerciale vuole analizzare come cresce nel tempo 
il valore generato da ciascun cliente.

L'obiettivo è calcolare il fatturato cumulativo di ogni cliente, mese dopo mese, per capire:
- quando un cliente ha raggiunto determinati livelli di valore;
- quali clienti hanno avuto una crescita più rapida nel tempo.
*/

WITH CustomerMonthlyRevenue AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        YEAR(OrderDate) AS Year_,
        MONTH(OrderDate) AS Month_,
        SUM(UnitPrice * Quantity) AS MonthlyRevenue
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    JOIN Customers c
        ON o.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CompanyName, YEAR(OrderDate), MONTH(OrderDate)
)
SELECT *,
    SUM(MonthlyRevenue) OVER (
        PARTITION BY CustomerID 
        ORDER BY Year_, Month_
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeRevenue
FROM CustomerMonthlyRevenue;

/*
Il grain finale dell'output è rappresentato da una riga per ogni combinazione
cliente-mese.

La prima fase aggrega il fatturato mensile generato da ciascun cliente,
trasformando il livello di dettaglio delle righe ordine nel livello temporale
necessario per l'analisi.

La seconda fase utilizza una window function con PARTITION BY CustomerID e un
frame cumulativo ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW per calcolare
il fatturato progressivo di ogni cliente nel tempo.

Il frame permette di mantenere tutta la storia precedente del cliente fino al
mese corrente, facendo ripartire il calcolo per ogni cliente.
*/