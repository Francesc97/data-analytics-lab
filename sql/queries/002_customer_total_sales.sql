/*Obiettivo:
Calcolare il fatturato totale generato da ciascun cliente.*/

WITH OrderSales AS (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS OrderValue
    FROM [Order Details]
    GROUP BY OrderID
)

SELECT
    c.CustomerID,
    c.CompanyName,
    SUM(os.OrderValue) AS TotalSales
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderSales os
    ON o.OrderID = os.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName;

/*

Ragionamento:
La tabella Order Details ha un grain più basso rispetto a Orders, poiché un ordine
può contenere più prodotti. Per evitare errori di aggregazione, il fatturato viene
calcolato prima a livello di singolo ordine tramite una CTE.

Successivamente, il valore di ogni ordine viene aggregato a livello cliente,
ottenendo una riga per ciascun cliente che ha effettuato almeno un acquisto.

Nota:
Questa versione considera esclusivamente i clienti con almeno un ordine.
*/