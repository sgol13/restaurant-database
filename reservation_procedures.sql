--> Procedury
--# AddReservation(StartDate, EndDate, CustomerID, Guests)
--- Dodaje nową rezerwację
CREATE OR ALTER PROCEDURE AddReservation (@StartDate datetime, @EndDate datetime, @CustomerID int, @Guests nvarchar(max), @Tables ReservationTablesList READONLY)
AS BEGIN

    -- IF (AreTablesAvailable (@StartDate, @EndDate, @Tables))

    INSERT INTO Reservations(StartDate, EndDate, Accepted, CustomerID, Guests, Canceled)
    VALUES (@StartDate, @EndDate, 0, @CustomerID, @Guests, 0)

    DECLARE @ReservationID int = @@IDENTITY

    INSERT INTO TableDetails(TableID, ReservationID)
    SELECT @TableID, @ReservationID FROM @Tables
END
GO
--<


--> Procedury
--# AcceptReservation(ReservationID)
--- Akceptuje wybraną rezerwację
CREATE OR ALTER PROCEDURE AcceptReservation (@ReservationID int)
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


--> Procedury
--# CancelReservation(ReservationID)
--- Anuluje wybraną rezerwację
CREATE OR ALTER PROCEDURE CancelReservation (@ReservationID int)
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


--> Funkcje
--# AreTablesAvailable(StartDate, EndDate, Tables)
--- Sprawdza czy stoliki z listy są dostępne w danym przedziale czasowym
CREATE OR ALTER FUNCTION AreTablesAvailable(@StartDate datetime, @EndDate datetime, @Tables ReservationTablesList READONLY)
RETURNS BIT
BEGIN
    IF ( @Tables.TableID IN
    (SELECT TableID FROM TableDetails TD
    INNER JOIN Reservations R ON TD.ReservationID = R.ReservationID
    WHERE TableID = @Tables.TableID
    AND ((NOT EndDate <= @StartDate OR StartDate >= @EndDate) AND Canceled = 0)))
    BEGIN
        ;THROW 52000, 'Not all selected tables will be available', 1
        RETURN 0
    END
    RETURN 1
END
GO
--<


