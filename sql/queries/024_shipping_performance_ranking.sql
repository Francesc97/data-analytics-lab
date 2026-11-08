/*
Il responsabile della logistica vuole confrontare le performance delle compagnie di spedizione per individuare quelle più efficienti.

Creare un report che mostri:
- ID spedizioniere;
- nome spedizioniere;
- numero totale di ordini spediti;
- tempo medio di spedizione (giorni);
- posizione dello spedizioniere in base al tempo medio di spedizione.
*/

SELECT 
    o.Shipvia AS ShipperID,
    s.CompanyName,
    COUNT(ShippedDate) AS ShippedOrders,
    AVG(DATEDIFF(day, Orderdate, ShippedDate)) AS Avg_days_between_order_and_shipping,
    DENSE_RANK() OVER(ORDER BY AVG(DATEDIFF(day, Orderdate, ShippedDate)) ASC) AS Ranking_Shipping_Company
FROM Orders o
JOIN Shippers s 
    ON o.ShipVia = s.ShipperID
WHERE ShippedDate IS NOT NULL
GROUP BY o.Shipvia, s.CompanyName;

/*
Il grain finale dell'output è rappresentato da una riga per ogni compagnia di
spedizione.

La query utilizza la tabella Orders per calcolare i principali indicatori di
performance delle spedizioni, considerando esclusivamente gli ordini con una
data di spedizione valorizzata.

Per ogni compagnia vengono calcolati il numero totale di ordini spediti e il
tempo medio di spedizione, espresso come differenza in giorni tra la data
dell'ordine e la data di spedizione.

La funzione DENSE_RANK assegna una posizione alle compagnie in base al tempo
medio di spedizione, ordinando dalla più veloce alla più lenta e gestendo
correttamente eventuali pari merito.
*/