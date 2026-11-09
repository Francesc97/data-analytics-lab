/*
Il responsabile vendite vuole analizzare come cambia il fatturato delle categorie nel tempo.

Output:
- CategoryID
- CategoryName
- Anno
- Revenue annuale
- Revenue anno precedente
- Crescita percentuale
*/

WITH CategoryAnnualRevenue AS 
(    SELECT 
        c.CategoryID,
        c.CategoryName,
        YEAR(o.OrderDate) AS Year_,
        SUM(od.Quantity * od.UnitPrice) AS AnnualRevenue
    FROM [Order Details] od
    JOIN Products p
        ON od.ProductID = p.ProductID
    JOIN Categories c
        ON p.CategoryID = c.CategoryID
    JOIN Orders o
        ON od.OrderID = o.OrderID
    GROUP BY 
        c.CategoryID,
        c.CategoryName,
        YEAR(o.OrderDate)
),
CategoryTrend AS
(    SELECT *,
        LAG(AnnualRevenue) OVER(
            PARTITION BY CategoryID 
            ORDER BY Year_
        ) AS PreviousYearRevenue
    FROM CategoryAnnualRevenue
)
SELECT *,
    ((AnnualRevenue - PreviousYearRevenue) 
    / NULLIF(PreviousYearRevenue,0)) * 100.0 AS GrowthPercentage
FROM CategoryTrend;

/*
Il grain finale dell'output è rappresentato da una riga per ogni combinazione
categoria-anno.

La prima fase aggrega il fatturato annuale per categoria utilizzando le righe
di dettaglio degli ordini e collegando le informazioni relative a prodotti e
categorie.

La seconda fase utilizza la funzione LAG per recuperare il fatturato dell'anno
precedente della stessa categoria.

Infine viene calcolata la variazione percentuale anno su anno confrontando il
fatturato corrente con quello precedente. Il primo anno disponibile per ogni
categoria non presenta una variazione percentuale poiché manca un valore di
riferimento.
*/