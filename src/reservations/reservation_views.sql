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
--- Pokazuje szczegóły rezerwacji.
CREATE OR ALTER VIEW ReservationsDetails
AS
    ((SELECT ReservationID, CustomerID, StartDate, EndDate, Guests, 'do akceptacji' as Status
    FROM Reservations
    WHERE Accepted = 0)
    UNION
    (SELECT ReservationID, CustomerID, StartDate, EndDate, Guests, 'zaakceptowana'
    FROM Reservations
    WHERE Accepted = 1 AND Canceled = 0 AND GETDATE() <= EndDate)
    UNION
    (SELECT ReservationID, CustomerID, StartDate, EndDate, Guests, 'zakończona'
    FROM Reservations
    WHERE Accepted = 1 AND Canceled = 0 AND EndDate < GETDATE())
    UNION
    (SELECT ReservationID, CustomerID, StartDate, EndDate, Guests, 'anulowana'
    FROM Reservations
    WHERE Accepted = 1 AND Canceled = 1))
GO
--<

SELECT * FROM ReservationsDetails