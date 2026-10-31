/*Obiettivo:
Mostrare la classifica dei clienti per fatturato includendo anche quelli che
non hanno mai effettuato ordini. */

WITH OrderSales AS (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS OrderValue
    FROM [Order Details]
    GROUP BY OrderID
)

SELECT
    c.CustomerID,
    c.CompanyName,
    COALESCE(SUM(os.OrderValue),0) AS TotalSales
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
LEFT JOIN OrderSales os
    ON o.OrderID = os.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName
ORDER BY COALESCE(SUM(os.OrderValue),0) ASC;

/*

Ragionamento:
Il risultato finale deve avere un grain di una riga per cliente. Per questo motivo
la query parte dalla tabella Customers, utilizzando LEFT JOIN per preservare anche
i clienti privi di ordini.

Il fatturato viene prima calcolato a livello ordine e successivamente aggregato
per cliente. I clienti senza ordini producono un valore NULL, che viene convertito
in 0 tramite COALESCE per rendere il report più leggibile e coerente con le esigenze
di business.

Nota:
La scelta di visualizzare 0 invece di NULL è finalizzata alla consultazione del
report e non modifica il significato dei dati presenti nel database.
*/