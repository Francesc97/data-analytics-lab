/*
Il responsabile commerciale vuole identificare i clienti con il maggior fatturato complessivo generato.
Creare una classifica dei clienti ordinata per valore totale degli acquisti.
*/

SELECT 
    c.CustomerID,
    c.CompanyName,
    SUM(unitprice * quantity) AS Revenue,
    DENSE_RANK() OVER (ORDER BY SUM(unitprice * quantity) DESC) AS RankingByRevenue
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
JOIN Customers c 
    ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CompanyName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente che
ha effettuato almeno un ordine.

Il fatturato totale generato da ciascun cliente viene calcolato aggregando le
righe di Order Details attraverso il valore dato da quantità moltiplicata per
prezzo unitario.

Le join con Orders e Customers permettono di collegare ogni transazione al
cliente responsabile dell'acquisto.

Viene utilizzata una INNER JOIN perché l'analisi riguarda esclusivamente i
clienti che hanno generato fatturato, escludendo quelli senza ordini.

La classifica dei clienti viene calcolata tramite una window function,
utilizzando DENSE_RANK per mantenere il pari merito tra clienti con lo stesso
fatturato senza creare salti nella numerazione.
*/