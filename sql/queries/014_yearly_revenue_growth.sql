/*
Il direttore commerciale vuole confrontare il fatturato di ogni anno 
con quello dell'anno precedente, evidenziando la variazione.
*/

WITH Yearly_sales AS (
SELECT 
    YEAR(OrderDate) AS Year_,
    SUM(Unitprice * Quantity) as Revenue
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
GROUP BY YEAR(OrderDate)
)
SELECT 
    Year_,
    Revenue,
    LAG(Revenue, 1) OVER (ORDER BY Year_ ASC) AS PreviousYearRevenue,
    (Revenue - LAG(Revenue, 1) OVER (ORDER BY Year_ ASC)) AS GrowthAmount,
    ((Revenue - LAG(Revenue, 1) OVER (ORDER BY Year_)) 
                    / LAG(Revenue, 1) OVER (ORDER BY Year_)) * 100.0 AS 'Growth%'
FROM Yearly_sales;

/*
Il grain finale dell'output è rappresentato da una riga per ogni anno.

La CTE Yearly_sales viene utilizzata per creare un dataset aggregato a livello
annuale, calcolando il fatturato totale generato in ciascun anno.

Successivamente viene applicata la funzione window LAG() per recuperare il
fatturato dell'anno precedente mantenendo l'ordinamento temporale.

Questo permette di calcolare sia la variazione assoluta del fatturato
(GrowthAmount), ottenuta dalla differenza tra anno corrente e anno precedente,
sia la variazione percentuale (Growth%), calcolata rapportando il delta al
valore dell'anno precedente.

Il primo anno della serie temporale non presenta un confronto disponibile e
restituisce quindi un valore NULL per le metriche di crescita.
*/
