--> Funkcje
--# AreTablesAvailable(StartDate, EndDate, Tables)
--- Sprawdza czy wszystkie stoliki z listy są dostępne w danym przedziale czasowym.
CREATE OR ALTER FUNCTION AreTablesAvailable(@StartDate datetime, @EndDate datetime, @Tables ReservationTablesListT READONLY)
RETURNS BIT
BEGIN
    RETURN CASE 
        WHEN EXISTS (SELECT * FROM @Tables WHERE dbo.TableAvailableAtTime(TableID, @StartDate, @EndDate) = 0)
            THEN 0
        ELSE 1
    END
END
GO
--<


--> Funkcje
--# TableAvailableAtTime
--- Sprawdza


--> Funkcje
--# SingleReservationDetails(ReservationID)
--- Zwraca szczegóły na temat danej rezerwacji.
CREATE OR ALTER FUNCTION SingleReservationDetails(@ReservationID int)
RETURNS TABLE
AS RETURN
    SELECT *
    FROM 
        ReservationsDetails
    WHERE 
        ReservationID = @ReservationID
GO
--<

--> Funkcje
--# GetCustomersReservations
--- Zwraca informacje na temat wszystkich rezerwacji danego klienta wraz z informacją o ich statusie.
CREATE OR ALTER FUNCTION GetCustomersReservations(@CustomerID int)
RETURNS TABLE
AS RETURN
    SELECT *
    FROM 
        ReservationsDetails
    WHERE 
        CustomerID = @CustomerID
GO
--<
