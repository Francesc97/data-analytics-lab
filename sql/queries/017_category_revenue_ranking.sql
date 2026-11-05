-- Il responsabile prodotto vuole capire quali categorie generano il maggior fatturato complessivo e quali categorie risultano meno rilevanti.

SELECT 
    c.categoryid,
    c.categoryname,
    SUM(od.unitprice * quantity) AS CategoryRevenue,
    DENSE_RANK() OVER (ORDER BY SUM(od.unitprice * quantity) DESC) AS CategoryRanking
FROM [Order Details] od
JOIN Products p
    ON od.productid = p.productid
JOIN Categories c
    ON p.categoryid = c.categoryid
GROUP BY c.categoryid, c.categoryname;

/*
Il grain finale dell'output è rappresentato da una riga per ogni categoria
prodotto che ha generato almeno una vendita.

La query parte da Order Details perché l'analisi considera esclusivamente le
vendite effettive. Attraverso la join con Products e Categories ogni riga di
vendita viene associata alla relativa categoria.

Il fatturato della categoria viene calcolato sommando il valore delle vendite,
ottenuto dal prodotto tra quantità e prezzo unitario.

La classifica viene calcolata tramite DENSE_RANK per mantenere il pari merito
tra categorie con lo stesso fatturato senza creare salti nella numerazione.
*/