--> Funkcje
--# TableAvailableAtTime(TableID, StartDate, EndDate)
--- Sprawdza czy dany stolik jest dostępny w danym przedziale czasowym.
CREATE OR ALTER FUNCTION TableAvailableAtTime(@TableID int, @StartDate datetime, @EndDate datetime)
RETURNS BIT
BEGIN
    RETURN CASE
        WHEN @TableID NOT IN
            (SELECT 
                TableID 
            FROM 
                TableDetails TD
                INNER JOIN Reservations R ON TD.ReservationID = R.ReservationID
            WHERE 
                NOT EndDate <= @StartDate 
                AND NOT StartDate >= @EndDate
                AND Canceled = 0 
            )
        THEN 1
        ELSE 0
    END
END
GO
--<

--> Funkcje
--# EndOfTableOccupationTime(TableID)
--- Zwraca czas zakończenia rezerwacji jeśli stolik jest aktualnie zarezerwowany.
CREATE OR ALTER FUNCTION EndOfTableOccupationTime(@TableID int)
RETURNS datetime
BEGIN
    RETURN 
        (SELECT 
            EndDate 
        FROM 
            Reservations R
            INNER JOIN TableDetails TD on R.ReservationID = TD.ReservationID
        WHERE 
            TD.TableID = @TableID 
            AND StartDate <= GETDATE() 
            AND GETDATE() <= EndDate
        )
END
GO
--<

--> Funkcje
--# CurrentTableReservation(TableID)
--- Zwraca numer rezerwacji jeśli stolik jest aktualnie zarezerwowany.
CREATE OR ALTER FUNCTION CurrentTableReservation(@TableID int)
RETURNS int
BEGIN
    RETURN 
        (SELECT 
            R.ReservationID 
        FROM 
            Reservations R
            INNER JOIN TableDetails TD on R.ReservationID = TD.ReservationID
        WHERE 
            TD.TableID = @TableID 
            AND StartDate <= GETDATE() 
            AND GETDATE() <= EndDate
        )
END
GO
--<

--> Funkcje
--# TablesAvailableToReserve(StartDate, EndDate)
--- Zwraca tabelę zawierającą stoliki możliwe do zarezerwowania w danym przedziale czasowym.
CREATE OR ALTER FUNCTION TablesAvailableToReserve(@StartDate datetime, @EndDate datetime)
RETURNS TABLE
AS RETURN
    SELECT 
        TableID, 
        Seats 
    FROM 
        Tables
    WHERE 
        dbo.TableAvailableAtTime(TableID, @StartDate, @EndDate) = 1
GO
--<