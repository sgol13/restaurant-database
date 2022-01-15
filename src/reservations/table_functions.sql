--> Funkcje
--# TableAvailableAtTime(TableID, StartDate, EndDate)
--- Sprawdza czy dany stolik jest dostępny w danym przedziale czasowym.
CREATE OR ALTER FUNCTION TableAvailableAtTime(@TableID int, @StartDate datetime, @EndDate datetime)
RETURNS BIT
BEGIN
    IF ( @TableID NOT IN
    (SELECT TableID FROM TableDetails TD
    INNER JOIN Reservations R ON TD.ReservationID = R.ReservationID
    WHERE ((NOT (EndDate <= @StartDate OR StartDate >= @EndDate)) AND Canceled = 0)) )
    RETURN 1
    ELSE
    RETURN 0
END
GO
--<

--> Funkcje
--# EndOfTableOccupationTime(TableID)
--- Zwraca czas zakończenia rezerwacji jeśli stolik jest aktualnie zarezerwowany.
CREATE OR ALTER FUNCTION EndOfTableOccupationTime(@TableID int)
RETURNS datetime
BEGIN
    IF (TableAvailableAtTime(@TableID, GETDATE(), GETDATE()) = 1)
    BEGIN
        ;THROW 52000, 'Table is not occupied at the moment', 1
        RETURN 0
    END
    ELSE
    BEGIN
        RETURN (SELECT EndDate FROM Reservations R
        INNER JOIN TableDetails TD on R.ReservationID = TD.ReservationID
        WHERE TD.TableID = @TableID AND StartDate <= GETDATE() AND GETDATE() <= EndDate)
    END
END
GO
--<

--> Funkcje
--# CurrentTableReservation(TableID)
--- Zwraca numer rezerwacji jeśli stolik jest aktualnie zarezerwowany.
CREATE OR ALTER FUNCTION CurrentTableReservation(@TableID int)
RETURNS int
BEGIN
    IF (TableAvailableAtTime(@TableID, GETDATE(), GETDATE()) = 1)
    BEGIN
        ;THROW 52000, 'Table is not occupied at the moment', 1
        RETURN 0
    END
    ELSE
    BEGIN
        RETURN (SELECT R.ReservationID FROM Reservations R
        INNER JOIN TableDetails TD on R.ReservationID = TD.ReservationID
        WHERE TD.TableID = @TableID AND StartDate <= GETDATE() AND GETDATE() <= EndDate)
    END
END
GO
--<

--> Funkcje
--# TablesAvailableToReserve(StartDate, EndDate)
--- Zwraca tabelę zawierającą stoliki możliwe do zarezerwowania w danym przedziale czasowym.
CREATE OR ALTER FUNCTION TablesAvailableToReserve(@StartDate datetime, @EndDate datetime)
RETURNS @Tables TABLE (TableID int, Seats int)
BEGIN
    INSERT @Tables
        SELECT TableID, Seats FROM Tables WHERE dbo.TableAvailableAtTime(TableID, @StartDate, @EndDate) = 1
    RETURN
END
GO
--<
