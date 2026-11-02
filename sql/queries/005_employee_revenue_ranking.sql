/* Il responsabile vendite vuole sapere quali dipendenti hanno generato più fatturato.
Creare una classifica degli employee in base al valore totale degli ordini gestiti.
*/

WITH OrdersAmount AS (
SELECT employeeid, 
    o.orderid, 
    SUM(unitprice * quantity) as Total
FROM Orders o 
JOIN [Order Details] od 
    ON o.OrderID = od.OrderID
GROUP BY employeeid, o.orderid
)
SELECT e.employeeID, 
    CONCAT(e.LastName, ' ', e.FirstName) AS EmployeeName, 
    COALESCE(SUM(Total), 0) as EmployeeRevenues, 
    ROW_NUMBER() OVER (Order By COALESCE(SUM(Total), 0) DESC) AS RN
FROM Employees e
LEFT JOIN OrdersAmount oa 
    ON e.employeeID = oa.employeeID
GROUP BY e.employeeID, CONCAT(e.LastName, ' ', e.FirstName);

/*
Il grain finale dell'output è rappresentato da una riga per ogni employee.

Per calcolare il fatturato generato da ogni dipendente è necessario prima
aggregare il valore delle righe ordine al livello ordine, tramite la somma
di quantità moltiplicata per prezzo unitario.

La CTE OrdersAmount porta il dataset al grain ordine, mantenendo EmployeeID
per consentire la successiva aggregazione per dipendente.

La query finale parte da Employees con una LEFT JOIN verso gli ordini aggregati
per includere anche gli employee senza vendite. Il valore nullo viene
trasformato in zero tramite COALESCE.

La classifica degli employee viene ottenuta ordinando il fatturato totale
generato in ordine decrescente tramite una window function.
*/