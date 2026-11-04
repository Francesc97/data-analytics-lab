/*
Il direttore commerciale vuole confrontare il fatturato complessivo generato in ciascun anno.
Creare un report che mostri il fatturato totale per anno.
*/

SELECT 
    YEAR(OrderDate) AS Year_,
    SUM(Unitprice * Quantity) as Revenue
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) ASC;

/*
Il grain finale dell'output è rappresentato da una riga per ogni anno.

Per analizzare il fatturato annuale viene utilizzata la data dell'ordine
(OrderDate), estraendo l'anno di riferimento.

Le righe di Order Details vengono aggregate direttamente al livello annuale
dopo la join con Orders, calcolando il fatturato totale tramite la somma del
prodotto tra quantità e prezzo unitario.

Non è necessario un livello intermedio di aggregazione poiché il fatturato è
una misura additiva.

Il risultato viene ordinato cronologicamente per facilitare il confronto tra
gli anni.
*/