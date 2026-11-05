/*
Il responsabile commerciale vuole monitorare l'andamento delle vendite mese per mese, confrontando ogni mese con quello precedente.

Creare un report che mostri:
- anno-mese;
- fatturato del mese;
- fatturato del mese precedente;
- variazione assoluta;
- variazione percentuale.
*/

WITH MonthlySalesTrend AS (
SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS MonthOfTheYear,
    SUM(Unitprice * Quantity) as Revenue
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
)
SELECT 
    MonthOfTheYear,
    Revenue,
    LAG(Revenue, 1) OVER (ORDER BY MonthOfTheYear ASC) AS PreviousMonthRevenue,
    (Revenue - LAG(Revenue, 1) OVER (ORDER BY MonthOfTheYear ASC)) AS GrowthAmount,
    ((Revenue - LAG(Revenue) OVER (ORDER BY MonthOfTheYear)) /
                        NULLIF(LAG(Revenue) OVER (ORDER BY MonthOfTheYear), 0)) * 100.0 AS 'Growth%'
FROM MonthlySalesTrend

/*
Il grain finale dell'output è rappresentato da una riga per ogni anno e mese.

La CTE MonthlySalesTrend viene utilizzata per aggregare il fatturato totale
al livello mensile, utilizzando la data dell'ordine come riferimento
temporale.

Successivamente la funzione window LAG() recupera il fatturato del mese
precedente, consentendo di calcolare sia la variazione assoluta
(GrowthAmount) sia la variazione percentuale (Growth%) rispetto al periodo
precedente.

Il primo mese della serie temporale non dispone di un mese precedente di
confronto e restituisce quindi valori NULL per le metriche di crescita.
*/