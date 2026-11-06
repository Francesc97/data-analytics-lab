/*
Il responsabile prodotto vuole identificare, per ogni categoria, 
il prodotto che genera il maggior fatturato.

Creare un report che mostri:
- categoria;
- prodotto;
- fatturato generato dal prodotto;
- posizione del prodotto all'interno della propria categoria.
*/

SELECT 
    p.productid,
    p.productname,
    c.categoryname,
    c.categoryid,
    SUM(od.quantity * od.unitprice) AS Revenue,
    DENSE_RANK() OVER (PARTITION BY c.categoryid ORDER BY SUM(od.quantity * od.unitprice) DESC) AS ProductRanking 
FROM [Order Details] od
JOIN Products p
    ON od.productid = p.productid
JOIN Categories c
    ON p.categoryid = c.categoryid
GROUP BY c.categoryid, c.categoryname, p.productid, p.productname;

/*
Il grain finale dell'output è rappresentato da una riga per ogni prodotto che
ha generato almeno una vendita.

La query calcola il fatturato totale di ciascun prodotto aggregando il valore
delle righe di vendita e associa ogni prodotto alla relativa categoria.

La funzione window DENSE_RANK() utilizza PARTITION BY CategoryID per creare
una classifica indipendente all'interno di ogni categoria. In questo modo il
ranking riparte da 1 per ciascuna categoria, consentendo di identificare i
prodotti con le migliori performance senza confrontare categorie diverse.

L'utilizzo di DENSE_RANK garantisce la corretta gestione dei pari merito,
evitando salti nella numerazione della classifica.
*/