/*
Il responsabile commerciale vuole identificare i clienti inattivi, cioè quelli che non effettuano ordini da più tempo.

Output:
- CustomerID
- CompanyName
- Ultima data ordine
- Giorni dall'ultimo ordine
- Ranking dei clienti meno recenti
Assunzione:
- utilizzare come riferimento la data massima presente negli ordini.
*/

WITH ActivityData AS 
    (SELECT
        c.CustomerID,
        c.CompanyName,
        MAX(OrderDate) AS LastOrder,
        DATEDIFF(day, MAX(OrderDate), (SELECT MAX(OrderDate) FROM Orders)) AS DaysSinceLastOrder
    FROM Orders o
    JOIN Customers c
        ON o.CustomerID = c.CustomerID 
    GROUP BY c.CustomerID, c.CompanyName
)
SELECT *,
        DENSE_RANK() OVER (ORDER BY DaysSinceLastOrder DESC) AS RN
FROM ActivityData;