/*
Il responsabile commerciale vuole individuare i clienti più attivi 
sulla base della frequenza degli acquisti.

Creare un report che mostri, per ogni cliente che ha effettuato almeno un ordine:
- ID cliente;
- nome cliente;
- numero totale di ordini effettuati;
- data del primo ordine;
- data dell'ultimo ordine;
- classificazione del cliente in base al numero di ordini.
Regole di classificazione:
- High Activity → più di 20 ordini;
- Medium Activity → tra 10 e 20 ordini;
- Low Activity → meno di 10 ordini.
*/

WITH CustomerOrdersDetails AS (
    SELECT 
        c.customerid,
        c.companyname,
        COUNT(o.orderid) AS TotalOrders,
        MIN(orderdate) AS FirstOrderDate,
        MAX(orderdate) AS LastOrderDate
    FROM Customers c
    JOIN Orders o
        ON c.customerid = o.customerid
    GROUP BY c.customerid, c.companyname
)
SELECT 
    customerid,
    companyname,
    FirstOrderDate,
    LastOrderDate,
    TotalOrders,
    CASE
        WHEN TotalOrders < 10 THEN 'Low Activity'
        WHEN TotalOrders BETWEEN 10 AND 20 THEN 'Medium Activity'
        ELSE 'High Activity'
    END AS ActivityClassification
FROM CustomerOrdersDetails;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente che
ha effettuato almeno un ordine.

La CTE CustomerOrdersDetails costruisce un dataset aggregato a livello cliente,
calcolando il numero totale di ordini effettuati, la data del primo ordine e la
data dell'ultimo ordine.

Successivamente viene applicata una classificazione basata sulla frequenza
degli ordini tramite una condizione CASE:
- meno di 10 ordini: Low Activity;
- tra 10 e 20 ordini: Medium Activity;
- oltre 20 ordini: High Activity.

La separazione tra aggregazione e classificazione tramite CTE permette di
mantenere distinta la fase di calcolo delle metriche dalla logica di business.
*/