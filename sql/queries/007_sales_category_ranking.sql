/*Il responsabile commerciale vuole sapere quali categorie di prodotti generano più fatturato.
Creare una classifica delle categorie ordinate dal valore di vendita più alto al più basso.
*/

SELECT 
    c.CategoryID, 
    c.CategoryName, 
    SUM(od.UnitPrice * od.Quantity) as Total,
    DENSE_RANK() OVER(ORDER BY SUM(od.UnitPrice * od.Quantity) DESC) AS SalesCategoryRank
FROM Products p
JOIN [Order Details] od 
    ON p.ProductID = od.ProductID
JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni categoria.

Per calcolare il fatturato generato da ciascuna categoria vengono utilizzate
le righe di dettaglio degli ordini, collegando Order Details ai prodotti e
successivamente alle categorie.

Il valore totale delle vendite viene calcolato aggregando quantità e prezzo
unitario al livello categoria.

Viene utilizzata una INNER JOIN perché l'analisi riguarda esclusivamente le
categorie che hanno generato vendite, escludendo quelle senza transazioni.

La classifica delle categorie viene calcolata tramite una window function,
utilizzando DENSE_RANK per mantenere il pari merito tra categorie con lo stesso
fatturato senza creare salti nella numerazione.
*/