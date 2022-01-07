DROP PROCEDURE AddReservation
GO

--> Procedury
--# AddReservation(StartDate, EndDate, CustomerID, Guests)
--- Dodaje nową rezerwację
CREATE PROCEDURE AddReservation (@StartDate datetime, @EndDate datetime, @CustomerID int, @Guests nvarchar(max))
AS BEGIN
    INSERT INTO Reservations(StartDate, EndDate, Accepted, CustomerID, Guests, Canceled)
    VALUES (@StartDate, @EndDate, 0, @CustomerID, @Guests, 0)
END
GO
--<

DROP PROCEDURE AcceptReservation
GO

--> Procedury
--# AcceptReservation(ReservationID)
--- Akceptuje wybraną rezerwację
CREATE PROCEDURE AcceptReservation (@ReservationID int)
AS BEGIN
    IF(SELECT Accepted FROM Reservations WHERE ReservationID = @ReservationID) = 1
    BEGIN
        ;THROW 52000, 'Reservation already accepted', 1
        RETURN
    END

    IF(SELECT Canceled FROM Reservations WHERE ReservationID = @ReservationID) = 1
    BEGIN
        ;THROW 52000, 'Reservation cancelled before acceptation', 1
        RETURN
    END

    UPDATE Reservations SET Accepted = 1
    WHERE ReservationID = @ReservationID
END
GO
--<

DROP PROCEDURE CancelReservation
GO

--> Procedury
--# CancelReservation(ReservationID)
--- Anuluje wybraną rezerwację
CREATE PROCEDURE CancelReservation (@ReservationID int)
AS BEGIN

    IF(SELECT Canceled FROM Reservations WHERE ReservationID = @ReservationID) = 1
    BEGIN
        ;THROW 52000, 'Reservation already cancelled', 1
        RETURN
    END

    UPDATE Reservations SET Canceled = 1
    WHERE ReservationID = @ReservationID

END
GO
--<





