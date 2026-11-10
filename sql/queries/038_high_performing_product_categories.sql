/*
Il responsabile vendite vuole identificare le categorie di prodotti che rappresentano il vero motore del business.

Una categoria viene considerata ad alte prestazioni se soddisfa entrambe le seguenti condizioni:
- ha generato un fatturato totale di almeno 50.000;
- ha venduto almeno 1.000 unità complessive.
L'obiettivo è individuare le categorie su cui concentrare investimenti di marketing e gestione dell'inventario.
Output richiesto
Per ogni categoria mostrare:
- CategoryID
- CategoryName
- TotalRevenue
- TotalUnitsSold
- NumberOfProductsSold (numero di prodotti distinti appartenenti alla categoria che sono stati effettivamente venduti)
Vincoli
- Il fatturato è definito come:
Quantity × UnitPrice
- Le unità vendute sono la somma delle quantità vendute.
- NumberOfProductsSold deve contare solo i prodotti che compaiono almeno una volta negli ordini.
- Il filtro deve essere applicato nel punto più naturale possibile.
- Ordinare il risultato per Revenue totale decrescente.
*/


SELECT 
        c.CategoryID,
        c.CategoryName,
        SUM(Quantity * od.Unitprice) AS TotalRevenue,
        SUM(Quantity) AS TotalUnitSold,
        COUNT(DISTINCT od.ProductID) AS NumberOfProductSold
FROM [Order Details] od
JOIN Products p
    ON od.ProductID = p.ProductID
JOIN Categories c
    ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING SUM(Quantity * od.Unitprice) >= 50000 AND SUM(Quantity) >= 1000
ORDER BY TotalRevenue DESC;

/*
Il grain finale dell'output è rappresentato da una riga per ogni categoria.

La query aggrega le informazioni presenti nella tabella Order Details,
arricchendole con le dimensioni Product e Category, per calcolare il fatturato
totale, le unità vendute e il numero di prodotti distinti venduti per ciascuna
categoria.

Il filtro viene applicato tramite HAVING poiché le condizioni richieste
dipendono da valori aggregati calcolati dopo il GROUP BY.

COUNT DISTINCT viene utilizzato per determinare il numero effettivo di prodotti
venduti evitando di contare più volte lo stesso prodotto presente in ordini
differenti.
*/