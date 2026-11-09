/*
Il reparto commerciale vuole individuare i clienti più frequenti, non per valore generato ma per numero di ordini effettuati.

Output:
- CustomerID
- CompanyName
- Numero ordini
- Primo ordine
- Ultimo ordine
- Ranking per frequenza ordini
Vincolo:
- ranking globale, non per anno.
*/

SELECT 
    c.customerID,
    c.companyName,
    COUNT(DISTINCT OrderID) AS OrderQuantity,
    MIN(OrderDate) AS FirstOrder,
    MAX(OrderDate) AS LastOrder,
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT OrderID) DESC) AS RN
FROM Orders o
JOIN Customers c
    ON o.CustomerID = c.CustomerID
GROUP BY c.customerID, c.companyName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente.

La query analizza la frequenza degli ordini utilizzando la tabella Orders,
calcolando il numero totale di ordini effettuati da ciascun cliente e le date
del primo e ultimo ordine.

La funzione DENSE_RANK assegna una posizione ai clienti in base al numero di
ordini effettuati, mantenendo lo stesso ranking in caso di pari merito.
*/