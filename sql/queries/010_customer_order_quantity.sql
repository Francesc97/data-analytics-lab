/*
Il responsabile commerciale vuole sapere quali clienti effettuano più ordini.
Creare una classifica dei clienti ordinata per numero totale di ordini effettuati.
*/

SELECT 
    c.CustomerID, 
    c.CompanyName, 
    COUNT(o.OrderID) AS NumberOfOrders,
    DENSE_RANK() OVER(ORDER BY COUNT(o.OrderID) DESC) AS RankingByOrders
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente.

Per calcolare la frequenza di acquisto viene contato il numero totale di
ordini effettuati da ciascun cliente.

La query parte dalla tabella Customers con una LEFT JOIN verso Orders per
includere anche i clienti che non hanno mai effettuato acquisti. Il conteggio
viene effettuato su OrderID per contare esclusivamente gli ordini effettivi
ed evitare di considerare righe generate dalla join.

La classifica dei clienti viene calcolata tramite una window function,
utilizzando DENSE_RANK per mantenere il pari merito tra clienti con lo stesso
numero di ordini senza creare salti nella numerazione.
*/