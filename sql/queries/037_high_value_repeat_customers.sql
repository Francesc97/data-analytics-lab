/*
Il responsabile commerciale vuole identificare i clienti più fedeli e profittevoli, ossia quelli che:
- hanno effettuato almeno 10 ordini;
- hanno un valore medio per ordine superiore a 1.000.
Questi clienti saranno i candidati ideali per campagne di fidelizzazione e programmi premium.
- Il numero di ordini deve rappresentare il numero reale di ordini, non il numero di righe di dettaglio.
- Il fatturato di un ordine è dato dalla somma di:
Quantity × UnitPrice di tutte le sue righe.
- Il filtro sui clienti deve essere applicato dopo l'aggregazione, nel punto più naturale possibile.
- Ordinare il risultato per Revenue totale decrescente.
*/

SELECT 
        c.CustomerID,
        c.CompanyName,
        COUNT(DISTINCT o.OrderID) AS Frequency,
        SUM(Quantity * UnitPrice) AS TotalRevenue,
        SUM(Quantity * Unitprice) / COUNT(DISTINCT o.OrderID) AS AvgRevenue
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerID,
        c.CompanyName
HAVING COUNT(DISTINCT o.OrderID) > 10 AND SUM(Quantity * Unitprice) / COUNT(DISTINCT o.OrderID) > 1000
ORDER BY SUM(Quantity * UnitPrice) DESC;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente.

La query identifica i clienti che combinano un'elevata frequenza di acquisto
con un alto valore medio degli ordini.

Il numero di ordini viene calcolato tramite COUNT DISTINCT per evitare la
duplicazione dovuta alla granularità della tabella Order Details, mentre il
fatturato medio per ordine è ottenuto come rapporto tra il fatturato totale e
il numero di ordini effettuati.

Il filtro viene applicato tramite HAVING, poiché entrambe le condizioni
dipendono da valori aggregati calcolati dopo il GROUP BY.
*/