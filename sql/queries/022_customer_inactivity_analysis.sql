/*
Il responsabile commerciale vuole identificare i clienti che non effettuano ordini da molto tempo, 
così da poter pianificare eventuali azioni di recupero.

Creare un report che mostri, per ogni cliente che ha effettuato almeno un ordine:
- ID cliente;
- nome cliente;
- data dell'ultimo ordine;
- numero totale di ordini effettuati;
- giorni trascorsi dall'ultimo ordine;
- stato del cliente.
Regole di classificazione:
- Active → ultimo ordine negli ultimi 90 giorni;
- At Risk → ultimo ordine tra 91 e 180 giorni fa;
- Inactive → ultimo ordine oltre 180 giorni fa.
*/

WITH CustomerOrdersDetails AS (
    SELECT 
        c.customerid,
        c.companyname,
        COUNT(o.orderid) AS TotalOrders,
        MAX(orderdate) AS LastOrderDate,
        DATEDIFF(day, MAX(orderdate), (SELECT MAX(orderdate) FROM Orders)) AS Days_Since_Last_Order
    FROM Customers c
    JOIN Orders o
        ON c.customerid = o.customerid
    GROUP BY c.customerid, c.companyname
)
SELECT 
    customerid,
    companyname,
    TotalOrders,
    FORMAT(LastOrderDate, 'yyyy-MM') AS LastOrderDay,
    Days_Since_Last_Order,
    CASE
        WHEN Days_Since_Last_Order <= 90 THEN 'Active'
        WHEN Days_Since_Last_Order BETWEEN 91 AND 180 THEN 'At Risk'
        ELSE 'Inactive'
    END AS ActivityClassification
FROM CustomerOrdersDetails
ORDER BY Days_Since_Last_Order DESC;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente che
ha effettuato almeno un ordine.

La CTE CustomerOrdersDetails aggrega le informazioni a livello cliente,
calcolando il numero totale di ordini, la data dell'ultimo ordine e i giorni
trascorsi dall'ultimo acquisto.

Poiché Northwind è un dataset storico, il calcolo dei giorni di inattività
utilizza come data di riferimento la data massima disponibile nel database,
simulando il momento più recente dell'attività aziendale.

Infine, una condizione CASE classifica i clienti in tre livelli di attività:
Active, At Risk e Inactive, in base ai giorni trascorsi dall'ultimo ordine.
*/