/*
Il responsabile commerciale vuole capire quanti clienti acquisiti in ciascun mese continuano ad effettuare ordini nei mesi successivi.

Creare un report che mostri, per ogni mese di acquisizione cliente:
- mese di acquisizione;
- mese dell'ordine successivo;
- numero di clienti attivi in quel mese.
*/

WITH CustomerCohort AS 
    (SELECT 
        CustomerID,
        FORMAT(MIN(OrderDate), 'yyyy-MM') AS Cohort_Month
    FROM Orders
    GROUP BY CustomerID
),
CustomerActivity AS 
    (SELECT DISTINCT
        cc.CustomerID,
        cc.Cohort_Month,
        FORMAT(o.OrderDate, 'yyyy-MM') AS Activity_Month
    FROM CustomerCohort cc
    JOIN Orders o
        ON cc.CustomerID = o.CustomerID
)
SELECT
    Cohort_Month,
    Activity_Month,
    COUNT(CustomerID) AS Active_Customers
FROM CustomerActivity
GROUP BY Cohort_Month, Activity_Month;

/*
Il grain finale dell'output è rappresentato da una riga per ogni combinazione
tra mese di acquisizione cliente e mese di attività.

La prima CTE identifica la coorte di appartenenza di ciascun cliente,
determinata dal mese del primo ordine effettuato.

La seconda CTE collega ogni cliente alla propria cronologia ordini, mantenendo
una sola occorrenza per combinazione cliente-mese attività tramite DISTINCT.

L'aggregazione finale consente di calcolare il numero di clienti attivi per
ciascuna coorte nei diversi mesi successivi all'acquisizione.
*/