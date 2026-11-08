/*
Il responsabile vendite vuole conoscere i 3 prodotti con il maggior fatturato all'interno di ogni categoria.

Creare un report che mostri:
- ID categoria;
- nome categoria;
- ID prodotto;
- nome prodotto;
- fatturato totale del prodotto;
- posizione del prodotto nella categoria.
*/

WITH Ranking_product_by_category AS
    (SELECT 
        c.CategoryID, 
        c.CategoryName, 
        p.productID,
        p.productName,
        SUM(od.UnitPrice * od.Quantity) as Total,
        DENSE_RANK() OVER(PARTITION BY c.CategoryID ORDER BY SUM(od.UnitPrice * od.Quantity) DESC) AS RN
    FROM [Order Details] od
    JOIN Products p 
        ON od.ProductID = p.ProductID
    JOIN Categories c
        ON p.CategoryID = c.CategoryID
    GROUP BY c.CategoryID, c.CategoryName, p.productID, p.productName
)
SELECT *
FROM Ranking_product_by_category
WHERE RN BETWEEN 1 AND 3; -- <= 3

/*
Il grain finale dell'output è rappresentato da una riga per ogni prodotto.

La query calcola il fatturato totale di ciascun prodotto aggregando il valore
delle righe di vendita e assegna un ranking all'interno della categoria di
appartenenza mediante la funzione DENSE_RANK.

La partizione per categoria consente di ottenere una classifica indipendente
per ciascun gruppo di prodotti, mentre il filtro finale restituisce
esclusivamente i primi tre classificati di ogni categoria, includendo eventuali
pari merito.
*/