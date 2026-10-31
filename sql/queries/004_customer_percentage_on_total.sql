/*Obiettivo:
Calcolare il peso percentuale di ciascun cliente sul fatturato totale aziendale
e creare una classifica dei clienti dal maggior contributo economico al minore. 
*/

WITH OrderSales AS (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS OrderValue
    FROM [Order Details]
    GROUP BY OrderID
), 
GrandTotal AS (
SELECT
    c.CustomerID,
    c.CompanyName,
    COALESCE(SUM(os.OrderValue),0) AS TotalSales
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
LEFT JOIN OrderSales os
    ON o.OrderID = os.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName
)
SELECT 
    CustomerID,
    CompanyName,
    TotalSales,
    (TotalSales * 100.0 / SUM(TotalSales) OVER()) as Percentage_on_Total,
    RANK() OVER (ORDER BY TotalSales DESC) AS RN
FROM GrandTotal;

/*
Ragionamento:
Il risultato finale mantiene un grain di una riga per cliente. Per ottenere questo
livello di dettaglio, il fatturato viene prima calcolato a livello ordine tramite
una CTE, evitando errori dovuti al diverso grain tra Orders e Order Details.

Successivamente il fatturato viene aggregato a livello cliente, includendo anche
i clienti senza ordini tramite LEFT JOIN e valorizzando il loro fatturato a 0.

La percentuale sul totale viene calcolata utilizzando una window function per
ottenere il fatturato complessivo dell'azienda mantenendo il dettaglio cliente.
In questo modo ogni riga può essere confrontata con il totale senza modificare
il grain del risultato.

Per la classifica viene utilizzata una window function senza PARTITION BY, poiché
il confronto deve avvenire tra tutti i clienti e non all'interno di gruppi separati.

Nota:
La funzione di ranking deve essere scelta in base al significato del report:
ROW_NUMBER assegna una posizione univoca, mentre RANK o DENSE_RANK possono essere
più adatte in presenza di clienti con lo stesso fatturato.
*/