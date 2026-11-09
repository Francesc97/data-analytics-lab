/*
Calcolare il valore totale generato da ogni cliente e classificarlo.

Output:
- CustomerID
- CompanyName
- Numero ordini
- Primo ordine
- Ultimo ordine
- Revenue totale
- Segmentazione cliente in base al revenue
*/

SELECT 
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID) AS NumberOfOrders,
    MIN(o.OrderDate) AS FirstOrderDate,
    MAX(o.OrderDate) AS LastOrderDate,
    SUM(od.UnitPrice * od.Quantity) AS TotalRevenue,
    CASE
        WHEN SUM(od.UnitPrice * od.Quantity) < 5000 THEN 'Low Value'
        WHEN SUM(od.UnitPrice * od.Quantity) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'High Value'
    END AS CustomerSegment
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID, c.CompanyName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente.

La query combina informazioni anagrafiche, frequenza degli ordini, periodo di
attività e valore economico generato dal cliente.

Il fatturato totale viene calcolato sulle righe di dettaglio ordine, mentre il
numero degli ordini utilizza COUNT DISTINCT per evitare la duplicazione dovuta
alla granularità della tabella Order Details.

Infine, i clienti vengono classificati in segmenti di valore sulla base del
fatturato totale generato.
*/