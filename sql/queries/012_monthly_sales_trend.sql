/*
Il responsabile commerciale vuole analizzare l'evoluzione del fatturato nel tempo.
Creare un report che mostri il fatturato totale per anno e mese.
*/

SELECT 
    FORMAT(OrderDate, 'yyyy-MM') AS Month_Year,
    SUM(Unitprice * Quantity) as Revenue
FROM [Order Details] od
JOIN Orders o
    ON od.OrderID = o.OrderID
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY FORMAT(OrderDate, 'yyyy-MM') ASC;

/*
Il grain finale dell'output è rappresentato da una riga per ogni anno e mese.

Per analizzare l'andamento temporale delle vendite viene utilizzata la data
dell'ordine (OrderDate), che rappresenta il momento in cui la vendita viene
generata.

Le righe di Order Details vengono collegate a Orders per recuperare il
riferimento temporale e il fatturato viene calcolato aggregando quantità e
prezzo unitario al livello mese.

Non è necessario un livello intermedio ordine perché la metrica richiesta è
una somma aggregabile direttamente dalle righe di vendita.

Il risultato viene ordinato cronologicamente per evidenziare l'evoluzione
temporale del fatturato.
*/