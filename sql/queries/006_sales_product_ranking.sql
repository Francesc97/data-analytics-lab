/*Il responsabile commerciale vuole sapere quali prodotti generano più fatturato.
Creare una classifica dei prodotti ordinata dal valore di vendita più alto al più basso.
*/

SELECT 
    p.productID, 
    p.ProductName, 
    SUM(od.UnitPrice * od.Quantity) as Total,
    DENSE_RANK() OVER(ORDER BY SUM(od.UnitPrice * od.Quantity) DESC) AS SalesRank
FROM Products p
JOIN [Order Details] od 
    ON p.ProductID = od.ProductID
GROUP BY p.productID, p.ProductName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni prodotto.

Per calcolare il fatturato generato da ciascun prodotto viene utilizzata la
tabella Order Details, che contiene il dettaglio delle vendite. Il valore
totale del prodotto viene calcolato aggregando la quantità venduta moltiplicata
per il prezzo unitario.

La join con Products permette di aggiungere le informazioni descrittive del
prodotto mantenendo il livello di dettaglio richiesto.

Viene utilizzata una INNER JOIN perché l'analisi riguarda esclusivamente i
prodotti che hanno generato vendite, escludendo quelli senza transazioni.

La classifica dei prodotti viene calcolata tramite una window function,
utilizzando DENSE_RANK per mantenere il pari merito tra prodotti con lo stesso
fatturato senza creare salti nella numerazione.
*/