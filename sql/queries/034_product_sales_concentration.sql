/*
Il responsabile vendite vuole capire quanto il fatturato aziendale dipende dai prodotti più venduti.

Output:
- ProductID
- ProductName
- CategoryName
- Revenue totale
- Percentuale sul fatturato totale
- Ranking prodotto per revenue
*/

SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    SUM(Quantity * od.UnitPrice) AS ProductRevenue,
    SUM(Quantity * od.UnitPrice) / NULLIF((SELECT SUM(Quantity * UnitPrice) FROM [Order Details]),0) * 100.0 AS PercentageOverTotalRevenue,
    DENSE_RANK() OVER(ORDER BY SUM(Quantity * od.UnitPrice) DESC) AS RN
FROM [Order Details] od
JOIN Products p
    ON od.ProductID = p.ProductID
JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY p.ProductID, p.ProductName, c.CategoryName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni prodotto.

La query calcola il fatturato generato da ciascun prodotto aggregando le righe
della tabella Order Details e arricchisce il risultato con le informazioni
relative a prodotto e categoria.

La percentuale sul fatturato totale viene calcolata confrontando il revenue
del singolo prodotto con il fatturato complessivo aziendale.

La funzione DENSE_RANK assegna una posizione ai prodotti in base al fatturato
generato, mantenendo lo stesso ranking in caso di pari merito.
*/