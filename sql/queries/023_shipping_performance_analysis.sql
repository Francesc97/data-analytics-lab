/*
Il responsabile della logistica vuole monitorare l'efficienza delle spedizioni e individuare eventuali ritardi.

Creare un report che mostri, per ogni spedizioniere (Shipper):
- ID spedizioniere;
- nome spedizioniere;
- numero totale di ordini spediti;
- tempo medio di spedizione (giorni tra OrderDate e ShippedDate);
- tempo minimo di spedizione;
- tempo massimo di spedizione.
*/

SELECT 
    o.Shipvia AS ShipperID,
    s.CompanyName,
    COUNT(ShippedDate) AS ShippedOrders,
    AVG(DATEDIFF(day, Orderdate, ShippedDate)) AS Avg_days_between_order_and_shipping,
    MIN(DATEDIFF(day, Orderdate, ShippedDate)) AS Minimum_days_between_order_and_shipping,
    MAX(DATEDIFF(day, Orderdate, ShippedDate)) AS Maximum_days_between_order_and_shipping
FROM Orders o
JOIN Shippers s 
    ON o.ShipVia = s.ShipperID
WHERE ShippedDate IS NOT NULL
GROUP BY o.Shipvia, s.CompanyName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni compagnia di
spedizione.

La query analizza le performance delle spedizioni utilizzando la tabella Orders,
poiché contiene tutte le informazioni necessarie per calcolare i KPI richiesti:
spedizioniere, data dell'ordine e data di spedizione.

Vengono considerati esclusivamente gli ordini già spediti, escludendo quelli
con ShippedDate NULL.

Per ogni spedizioniere vengono calcolati il numero totale di ordini spediti,
il tempo medio di spedizione e i tempi minimo e massimo intercorsi tra la data
dell'ordine e la data di spedizione.
*/