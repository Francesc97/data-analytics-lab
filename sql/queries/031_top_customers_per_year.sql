/*
Il responsabile vendite vuole conoscere i 5 migliori clienti 
per fatturato di ogni anno.

Output
- Anno
- CustomerID
- CompanyName
- AnnualRevenue
- Ranking
*/

WITH AnnualRevenueByCustomer AS
    (SELECT 
        YEAR(o.OrderDate) AS Year_,
        c.CustomerID,
        c.CompanyName,
        SUM(od.Unitprice * od.quantity) AS Revenue
    FROM [Order Details] od
    JOIN Orders o
        ON od.OrderID = o.OrderID
    JOIN Customers c 
        ON o.CustomerID = c.CustomerID
    GROUP BY YEAR(o.OrderDate), c.CustomerID, c.CompanyName
),
Ranking AS 
    (SELECT *,
            DENSE_RANK() OVER (PARTITION BY Year_ ORDER BY Revenue DESC) AS RN
    FROM AnnualRevenueByCustomer
)
SELECT *
FROM Ranking
WHERE RN <=5;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente e anno.

La prima CTE calcola il fatturato annuale generato da ciascun cliente,
aggregando le righe di dettaglio ordine.

La seconda CTE assegna un ranking ai clienti all'interno di ciascun anno
utilizzando DENSE_RANK, ordinando per fatturato decrescente e mantenendo tutti
i clienti in caso di pari merito.

Il risultato finale restituisce esclusivamente i primi cinque clienti per
fatturato di ogni anno.
*/