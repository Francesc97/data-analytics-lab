/*
Il responsabile commerciale vuole identificare gli impiegati che hanno generato le migliori performance di vendita.

Un impiegato viene considerato ad alte prestazioni se:
- ha gestito almeno 50 ordini;
- ha generato un fatturato medio per ordine superiore a 1.500.
L'obiettivo è individuare i dipendenti con maggiore capacità commerciale, considerando sia il volume di attività sia il valore medio generato.
- Il fatturato è calcolato come:
Quantity × UnitPrice

- Il conteggio degli ordini deve rappresentare ordini distinti.
- La media per ordine deve essere calcolata come:
Revenue totale / Numero ordini

(non come media delle righe di dettaglio).
- Il filtro deve essere applicato al livello corretto.
- Ordinare per revenue totale decrescente.
*/

SELECT 
    e.EmployeeID,
    CONCAT(e.LastName, ' ', e.FirstName) AS EmployeeName,
    COUNT(DISTINCT o.OrderID) AS Frequency,
    SUM(Quantity * Unitprice) AS TotalRevenue,
    SUM(Quantity * Unitprice) / COUNT(DISTINCT o.OrderID) AS AverageOrderValue
FROM Employees e
JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od
    ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.LastName, e.FirstName
HAVING COUNT(DISTINCT o.OrderID) >= 50 AND SUM(Quantity * Unitprice) / COUNT(DISTINCT o.OrderID) > 1500
ORDER BY TotalRevenue DESC;

/*
Il grain finale dell'output è rappresentato da una riga per ogni impiegato.

La query identifica gli impiegati con migliori performance commerciali
calcolando il numero di ordini gestiti, il fatturato totale generato e il
valore medio per ordine.

Il conteggio degli ordini utilizza COUNT DISTINCT per evitare duplicazioni
dovute alla granularità della tabella Order Details, mentre il valore medio per
ordine viene calcolato come rapporto tra revenue totale e numero di ordini.

Il filtro viene applicato tramite HAVING perché entrambe le condizioni
dipendono da aggregazioni calcolate sul gruppo di appartenenza.
*/