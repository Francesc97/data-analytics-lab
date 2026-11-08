/*
Il responsabile commerciale vuole capire come è cresciuta la base clienti nel tempo.

Creare un report che mostri, per ogni mese, il numero di nuovi clienti acquisiti.
Output
- Anno-Mese;
- Numero di nuovi clienti.
Assunzioni
- Un cliente è considerato nuovo nel mese del suo primo ordine.
- Ogni cliente deve essere conteggiato una sola volta.
- Ordinare cronologicamente il risultato.
*/

WITH Acquisition_analysis AS 
    (SELECT 
        CustomerID,
        MIN(OrderDate) AS New_Customer_Acquisition_Day
    FROM Orders
    GROUP BY CustomerID
)
SELECT 
    FORMAT(New_Customer_Acquisition_Day, 'yyyy-MM') AS Month_,
    COUNT(*) AS Number_of_new_clients
FROM Acquisition_analysis
GROUP BY FORMAT(New_Customer_Acquisition_Day, 'yyyy-MM');

/*
Il grain iniziale della CTE è rappresentato da una riga per ogni cliente.

La query identifica il primo ordine effettuato da ciascun cliente tramite la
funzione MIN sulla data dell'ordine, trasformando lo storico degli ordini in un
dataset di acquisizione clienti.

Successivamente ogni cliente viene associato al mese del primo acquisto e viene
calcolato il numero di nuovi clienti acquisiti per ciascun periodo.

La logica considera ogni cliente una sola volta, evitando duplicazioni dovute
agli ordini successivi al primo acquisto.
*/