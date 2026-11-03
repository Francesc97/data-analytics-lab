/*
Il responsabile commerciale vuole analizzare in quali Paesi vengono generate più vendite.
Creare una classifica dei Paesi ordinata per fatturato totale generato.
*/

SELECT 
    ShipCountry , 
    SUM(Quantity * Unitprice) AS Total,
    DENSE_RANK() OVER(ORDER BY SUM(Quantity * Unitprice) DESC) AS RankGeo
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
GROUP BY ShipCountry;

/*
Il grain finale dell'output è rappresentato da una riga per ogni paese.

Per calcolare il fatturato generato da ciascun paese vengono utilizzate le
righe di dettaglio degli ordini, collegate alla tabella Orders per recuperare
il paese di spedizione associato all'ordine.

Il valore totale delle vendite viene calcolato aggregando quantità e prezzo
unitario al livello paese.

Viene utilizzata una INNER JOIN perché l'analisi riguarda esclusivamente i
paesi che hanno generato vendite, escludendo quelli senza transazioni.

La classifica geografica viene calcolata tramite una window function,
utilizzando DENSE_RANK per mantenere il pari merito tra paesi con lo stesso
fatturato senza creare salti nella numerazione.

*/