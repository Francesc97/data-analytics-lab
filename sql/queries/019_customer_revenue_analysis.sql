/*
Il responsabile commerciale vuole identificare i clienti che hanno generato 
più fatturato nel tempo, per capire quali clienti hanno maggior valore per l'azienda.

Creare un report che mostri:
- ID cliente;
- nome cliente;
- fatturato totale generato;
- numero totale di ordini effettuati;
- posizione del cliente per fatturato.
*/


WITH CustomerRevenue AS (
    SELECT 
        c.customerID,
        c.companyname,
        SUM(od.unitprice * quantity) AS total_revenue,
        COUNT(DISTINCT o.orderid) AS total_orders
    FROM [Order Details] od
    JOIN Orders o
        ON od.orderid = o.orderid
    JOIN Customers c
        ON o.customerid = c.customerid
    GROUP BY c.customerID, c.companyname
)
SELECT 
    customerID,
    companyname,
    total_revenue,
    total_orders,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM CustomerRevenue;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente che
ha effettuato almeno un ordine.

La CTE CustomerRevenue costruisce un dataset aggregato a livello cliente,
calcolando sia il fatturato totale generato tramite la somma del valore delle
righe d'ordine, sia il numero totale di ordini distinti effettuati.

La query parte da Order Details perché rappresenta il livello di dettaglio
delle vendite, mentre Orders e Customers vengono utilizzate per risalire alle
informazioni dell'ordine e del cliente.

La funzione DENSE_RANK assegna una posizione ai clienti in base al fatturato
generato, mantenendo il pari merito tra clienti con lo stesso valore.
*/