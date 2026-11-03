/*
Il responsabile commerciale vuole analizzare l'evoluzione del fatturato nel tempo.
Creare un report che mostri il fatturato totale per anno e mese.
*/

SELECT 
    YEAR(OrderDate) AS Year_
    MONTH(OrderDate) AS Month_
    SUM(Unitprice * Quantity) as Revenue
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY FORMAT(OrderDate, 'yyyy-MM') ASC;