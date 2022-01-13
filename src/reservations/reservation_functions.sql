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


