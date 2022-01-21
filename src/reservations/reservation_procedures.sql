--> Procedury
--# AddReservation(StartDate, EndDate, CustomerID, Guests)
--- Dodaje nową rezerwację stolika na określony termin
CREATE OR ALTER PROCEDURE AddReservation (
    @StartDate datetime,
    @EndDate datetime,
    @Accepted bit = 1,
    @CustomerID int,
    @Guests nvarchar(max) = NULL,
    @Tables ReservationTablesListT READONLY,
    @ReservationID int = NULL OUTPUT
)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        IF dbo.AreTablesAvailable(@StartDate, @EndDate, @Tables) = 0 BEGIN
            ;THROW 52000, 'At least one of the tables is not available', 1
            RETURN
        END
        
        INSERT INTO Reservations(StartDate, EndDate, Accepted, CustomerID, Guests, Canceled)
        VALUES (@StartDate, @EndDate, @Accepted, @CustomerID, @Guests, 0)

        SET @ReservationID = @@IDENTITY

        INSERT INTO TableDetails(TableID, ReservationID)
        SELECT TableID, @ReservationID FROM @Tables
        
    COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<

--> Procedury
--# AddInstantReservation
--- Zarezerwowanie stolika w aktualnej chwili  (rezerwacja rozpoczyna się natychmiastowo).
CREATE OR ALTER PROCEDURE AddInstantReservation (
    @CustomerID int,
    @EndDate datetime,
    @Tables ReservationTablesListT READONLY,
    @ReservationID int = NULL OUTPUT
)
AS BEGIN

    DECLARE @StartDate datetime = GETDATE();

    EXEC AddReservation 
        @CustomerID = @CustomerID,
        @StartDate = @StartDate,
        @EndDate = @EndDate,
        @Tables = @Tables,
        @ReservationID = @ReservationID OUTPUT;
END
GO
--<

--> Procedury
--# PrivateOnlineReservation()
--- Tworzy rezerwację pojedynczego stolika dla klienta indywidualnego wraz ze złożeniem zamówienia
CREATE OR ALTER PROCEDURE PrivateOnlineReservation (
    @StartDate datetime,
    @EndDate datetime,
    @Accepted bit = 0,
    @CustomerID int,
    @Guests nvarchar(max) = NULL,
    @Tables ReservationTablesListT READONLY,
    @ReservationID int = NULL OUTPUT
)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION
        IF dbo.AreTablesAvailable(@StartDate, @EndDate, @Tables) = 1
        BEGIN
            INSERT INTO Reservations(StartDate, EndDate, Accepted, CustomerID, Guests, Canceled)
            VALUES (@StartDate, @EndDate, @Accepted, @CustomerID, @Guests, 0)

            SET @ReservationID = @@IDENTITY

            INSERT INTO TableDetails(TableID, ReservationID)
            SELECT TableID, @ReservationID FROM @Tables
        END
    COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END


GO
--<


--> Procedury
--# AcceptReservation(ReservationID)
--- Akceptuje rezerwację złożoną przez formularz internetowy
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
    BEGIN TRY
    BEGIN TRANSACTION

        IF(@ReservationID NOT IN (SELECT ReservationID FROM Reservations))
        BEGIN
            ;THROW 52000, 'Reservation does not exist', 1
            RETURN
        END

        IF(SELECT EndDate FROM Reservations WHERE ReservationID = @ReservationID) < GETDATE()
        BEGIN
            ;THROW 52000, 'Reservation already finished', 1
            RETURN
        END

        IF(SELECT Canceled FROM Reservations WHERE ReservationID = @ReservationID) = 1
        BEGIN
            ;THROW 52000, 'Reservation already cancelled', 1
            RETURN
        END

        IF(@ReservationID IN (SELECT ReservationID FROM Orders))
            BEGIN
                DECLARE @OrderID int;
                SET @OrderID = (SELECT OrderID FROM Orders WHERE ReservationID = @ReservationID)
                EXEC CancelOrder @OrderID = @OrderID;
            END

        UPDATE Reservations SET Canceled = 1
        WHERE ReservationID = @ReservationID

    COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# FinishCurrentReservation(ReservationID)
--- Zakończenie rezerwacji (jeśli klient opuścił restaurację przed końcem rezerwacji)
CREATE OR ALTER PROCEDURE FinishCurrentReservation(@ReservationID int)
AS BEGIN
    IF NOT (@ReservationID IN (SELECT ReservationID FROM Reservations WHERE StartDate <= GETDATE() AND GETDATE() <= EndDate))
    BEGIN
        ;THROW 52000, 'Wrong ReservationID or reservation has already ended or not started yet', 1
        RETURN
    END
    ELSE
    BEGIN
        UPDATE Reservations SET EndDate = GETDATE()
        WHERE ReservationID = @ReservationID
    END
END
GO
--<


--> Procedury
--# ExtendCurrrentReservation(ReservationID, NewEndDate)
--- Wydłużenie czasu rezerwacji do preferowanej godziny jeśli to możliwe
CREATE OR ALTER PROCEDURE ExtendCurrentReservation(@ReservationID int, @NewEndDate datetime)
AS BEGIN
    IF NOT (@ReservationID IN (SELECT ReservationID FROM Reservations WHERE StartDate <= GETDATE() AND GETDATE() <= EndDate))
    BEGIN
        ;THROW 52000, 'Wrong ReservationID or reservation has already ended or not started yet', 1
        RETURN
    END
    ELSE
    BEGIN
        IF (( SELECT COUNT (*) FROM (
            (SELECT TableID FROM TableDetails WHERE ReservationID = @ReservationID)
            EXCEPT
            (SELECT TableID FROM TableDetails TD
            INNER JOIN Reservations R ON TD.ReservationID = R.ReservationID
            WHERE dbo.TableAvailableAtTime(TableID, EndDate, @NewEndDate) = 1)  ) as TTI) != 0)
        BEGIN
            ;THROW 52000, 'Extension is not possible for this amount of time', 1
            RETURN
        END
        ELSE
        BEGIN
            UPDATE Reservations SET EndDate = @NewEndDate
            WHERE ReservationID = @ReservationID
        END
    END
END
GO
--<

