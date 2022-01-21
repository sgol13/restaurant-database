--> Widoki
--# ReservationsToAccept
--- Pokazuje rezerwacje, które nie zostały zaakceptowane.
CREATE OR ALTER VIEW ReservationsToAccept
AS SELECT ReservationID, CustomerID, Guests, Canceled
FROM Reservations WHERE Accepted = 0 AND Canceled = 0
GO
--<

--> Widoki
--# TodaysReservations
--- Pokazuje rezerwacje na aktualny dzień.
CREATE OR ALTER VIEW TodaysReservations
AS SELECT ReservationID, CustomerID, StartDate, EndDate, Guests
FROM Reservations
WHERE DAY(StartDate) = DAY(GETDATE())
AND MONTH(StartDate) = MONTH(GETDATE())
AND YEAR(StartDate) = YEAR(GETDATE())
GO
--<

--> Widoki
--# ReservationsDetails 
--- Pokazuje szczegóły wszystkich rezerwacji.
CREATE OR ALTER VIEW ReservationsDetails
AS
    SELECT 
        ReservationID, 
        CustomerID,
        (SELECT c.FullName FROM CustomersFullNames c WHERE c.CustomerID = r.CustomerID) FullName,
        StartDate, 
        EndDate, 
        Guests,
        (SELECT count(1) FROM TableDetails td WHERE td.ReservationID = r.ReservationID) TablesNum,
        (CASE
            WHEN (Accepted = 0 AND Canceled = 0) THEN 'do akceptacji'
            WHEN Canceled = 1 THEN 'anulowana'
            WHEN (Canceled = 0 AND EndDate < GETDATE()) THEN 'zakończona'
            WHEN (Accepted = 1 AND GETDATE() < StartDate) THEN 'zaakceptowana'
            ELSE 'trwajaca'
        END
        ) Status
    FROM 
        Reservations r
GO
--<

SELECT * FROM ReservationsDetails