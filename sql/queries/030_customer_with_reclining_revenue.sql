/*
Il responsabile vendite vuole individuare i clienti il cui 
fatturato è diminuito rispetto all'anno precedente, così da pianificare eventuali azioni commerciali.

Creare un report che mostri, per ogni cliente e anno:
- CustomerID;
- CompanyName;
- Anno;
- Revenue annuale;
- Revenue anno precedente;
- Variazione assoluta;
- Variazione percentuale.
Restituire solo i casi in cui:
- esiste un anno precedente;
- il fatturato è diminuito rispetto all'anno precedente.
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
FROM PreviousYearRevenue
WHERE PreviousYearRevenue IS NOT NULL
  AND AnnualRevenue < PreviousYearRevenue;

/*
Il grain finale dell'output è rappresentato da una riga per ogni combinazione
cliente-anno.

La prima CTE calcola il fatturato annuale di ciascun cliente aggregando le
righe di vendita della tabella Order Details e associando l'anno dell'ordine.

La seconda CTE utilizza la funzione LAG per recuperare il fatturato dell'anno
precedente dello stesso cliente.

La query finale calcola la variazione assoluta e percentuale del fatturato,
restituendo esclusivamente i clienti che presentano una diminuzione rispetto
all'anno precedente ed escludendo il primo anno di attività, per il quale non
esiste un termine di confronto.
*/