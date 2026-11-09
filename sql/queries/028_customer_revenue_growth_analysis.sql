/*
Il responsabile vendite vuole identificare i clienti che hanno
 aumentato o ridotto il proprio fatturato rispetto
 all'anno precedente.

Creare un report che mostri, per ogni cliente e anno:
- ID cliente;
- nome cliente;
- anno;
- fatturato annuale;
- fatturato anno precedente;
- variazione assoluta;
- variazione percentuale.
*/

WITH CustomerAnnualRevenue AS (
     SELECT 
        c.CustomerID,
        c.CompanyName,
        YEAR(o.OrderDate) AS OrderYear,
        SUM(od.UnitPrice * od.Quantity) as AnnualRevenue
    FROM Orders o
    JOIN Customers c
        ON o.CustomerID = c.CustomerID
    JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY 
        c.CustomerID,
        c.CompanyName,
        YEAR(o.OrderDate)
    ),
PreviousYearRevenue AS (
    SELECT *,
            LAG(AnnualRevenue) OVER (PARTITION BY CustomerID ORDER BY OrderYear) AS PreviousYearRevenue
    FROM CustomerAnnualRevenue
)
SELECT *,
        AnnualRevenue - PreviousYearRevenue AS AbsoluteChange,
        (AnnualRevenue -PreviousYearRevenue) / NULLIF(PreviousYearRevenue,0) * 100.0 AS PercentChange
FROM PreviousYearRevenue;

/*
Il grain finale dell'output è rappresentato da una riga per ogni combinazione
cliente-anno.

La prima CTE aggrega il fatturato annuale per cliente utilizzando la tabella
Order Details come fonte della misura economica e collegandola agli ordini per
ottenere la dimensione temporale.

La seconda CTE applica la funzione LAG per recuperare il fatturato dell'anno
precedente dello stesso cliente.

Infine vengono calcolate la variazione assoluta e percentuale del fatturato
rispetto all'anno precedente.
*/