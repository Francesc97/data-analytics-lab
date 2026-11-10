/*
Il responsabile commerciale vuole analizzare il comportamento recente dei clienti, 
calcolando quanto fatturato hanno generato considerando solamente gli ultimi 
3 ordini effettuati.

L'obiettivo è individuare clienti che stanno aumentando o riducendo il loro valore recente, 
senza essere influenzati da tutta la loro storia passata.
*/

WITH OrdersData AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        o.OrderID,
        o.OrderDate,
        SUM(UnitPrice * Quantity) AS OrderRevenue
    FROM Orders o
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    JOIN Customers c
        ON o.CustomerID = c.CustomerID
    GROUP BY 
        c.CustomerID,
        c.CompanyName,
        o.OrderID,
        o.OrderDate
)
SELECT *,
    SUM(OrderRevenue) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Last3OrdersRevenue
FROM OrdersData;

/*
Il grain finale dell'output è rappresentato da una riga per ogni ordine.

La prima fase aggrega le righe di dettaglio degli ordini per ottenere il
fatturato generato da ogni singolo ordine, trasformando il dataset dal livello
di dettaglio prodotto al livello ordine.

La seconda fase utilizza una window function con PARTITION BY CustomerID per
separare il calcolo per ciascun cliente e un window frame ROWS BETWEEN
2 PRECEDING AND CURRENT ROW per calcolare il fatturato degli ultimi tre ordini
effettuati, incluso l'ordine corrente.

L'utilizzo di ORDER BY OrderDate, OrderID garantisce un ordinamento temporale
deterministico della sequenza degli ordini.
*/