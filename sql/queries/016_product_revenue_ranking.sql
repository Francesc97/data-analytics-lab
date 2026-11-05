/* Il responsabile prodotto vuole identificare quali prodotti generano più fatturato e quali sono meno performanti.

Creare una classifica completa dei prodotti ordinati per fatturato generato. 
L'output deve mostrare tutti i prodotti con il relativo fatturato totale e posizione in classifica.
*/

SELECT 
    p.productid,
    p.productname,
    sum(quantity * od.unitprice) AS Revenue,
    DENSE_RANK() OVER (ORDER BY sum(quantity * od.unitprice) DESC) AS RankingRevenue
FROM [Order Details] od
JOIN Products p
    ON od.productid = p.productid
GROUP BY p.productid, p.productname;

/*
Il grain finale dell'output è rappresentato da una riga per ogni prodotto che
ha generato almeno una vendita.

La query parte da Order Details perché l'analisi riguarda esclusivamente i
prodotti con vendite effettuate. La metrica di performance viene calcolata
come somma del valore delle righe di vendita, ottenuto moltiplicando quantità
e prezzo unitario.

La join con Products permette di associare le vendite alle informazioni
descrittive del prodotto.

La classifica viene calcolata tramite DENSE_RANK, mantenendo il pari merito
tra prodotti con lo stesso fatturato senza creare salti nella numerazione.
*/