/*
Il responsabile commerciale vuole sapere quali clienti hanno effettuato ordini con il valore medio più alto.
Creare una classifica dei clienti ordinata per valore medio degli ordini.
*/
WITH order_value AS (
SELECT 
    orderid, 
    SUM(unitprice * quantity) AS TotalSale
FROM [Order Details]
GROUP BY orderid
)
SELECT 
    c.customerid,
    c.companyname,
    AVG(TotalSale) AS AverageOrderValue,
    DENSE_RANK() OVER (ORDER BY AVG(TotalSale) DESC) AS RankAvgValue
FROM Orders o
JOIN order_value ov
    ON o.orderid = ov.orderid
JOIN Customers c
    ON o.customerid = c.customerid
GROUP BY c.customerid, c.companyname;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente.

Per calcolare il valore medio degli ordini è necessario prima aggregare le
righe di Order Details al livello ordine, ottenendo il valore totale di ogni
singolo ordine.

La CTE order_value porta il dataset al grain ordine, permettendo nella query
finale di collegare ogni ordine al relativo cliente e calcolare il valore
medio degli ordini effettuati.

Viene utilizzata una INNER JOIN perché l'analisi riguarda esclusivamente i
clienti che hanno effettuato almeno un ordine.

La classifica viene calcolata tramite una window function, utilizzando
DENSE_RANK per mantenere il pari merito tra clienti con lo stesso valore medio
degli ordini senza creare salti nella numerazione.
*/