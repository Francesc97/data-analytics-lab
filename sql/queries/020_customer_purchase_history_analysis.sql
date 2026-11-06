/*
Il responsabile commerciale vuole analizzare il comportamento dei clienti nel tempo.

Creare un report che mostri, per ogni cliente che ha effettuato almeno un ordine:
- ID cliente;
- nome cliente;
- data del primo ordine;
- data dell'ultimo ordine;
- numero totale di ordini effettuati;
- giorni trascorsi tra primo e ultimo ordine.
*/

SELECT 
    c.customerid,
    c.companyname,
    MIN(orderdate) AS FirstOrderDate,
    MAX(orderdate) AS LastOrderDate,
    COUNT(o.orderid) AS TotalOrders,
    DATEDIFF(day, MIN(orderdate), MAX(orderdate)) AS DaysBetweenFirstAndLastOrder
FROM Customers c
JOIN Orders o
    ON c.customerid = o.customerid
GROUP BY c.customerid, c.companyname;

/*
Il grain finale dell'output è rappresentato da una riga per ogni cliente che
ha effettuato almeno un ordine.

La query analizza lo storico degli ordini a livello cliente utilizzando la
tabella Orders, in quanto tutte le metriche richieste sono disponibili al
livello dell'ordine e non richiedono il dettaglio delle righe di vendita.

Vengono calcolate la prima e l'ultima data di acquisto tramite MIN e MAX,
il numero totale di ordini effettuati tramite COUNT e l'intervallo temporale
tra il primo e l'ultimo ordine tramite DATEDIFF.

La join con Customers permette di associare gli identificativi degli ordini
alle informazioni descrittive del cliente.
*/