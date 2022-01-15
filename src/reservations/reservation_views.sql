--> Widoki
--# TablesAvailableNow
--- Zwraca aktualnie dostępne stoliki
CREATE OR ALTER VIEW TablesAvailableNow
AS SELECT T.TableID, Seats
FROM Tables T INNER JOIN TableDetails TD ON T.TableID = TD.TableID
INNER JOIN Reservations R ON TD.ReservationID = R.ReservationID
WHERE Active = 1 AND
(T.TableID NOT IN (SELECT TableID FROM TableDetails)
OR T.TableID NOT IN (SELECT TableID FROM TableDetails TD1
    INNER JOIN Reservations R1 ON TD1.ReservationID = R1.ReservationID
    WHERE R1.StartDate <= GETDATE() AND GETDATE() <= EndDate AND R1.Canceled = 0))
GO
--<


--> Widoki
--# ReservationsToAccept
--- Pokazuje rezerwacje, które nie zostały zaakceptowane.
CREATE OR ALTER VIEW ReservationsToAccept
AS SELECT ReservationID, CustomerID, Guests, Canceled FROM Reservations WHERE Accepted = 0 AND Canceled = 0
GO
--<