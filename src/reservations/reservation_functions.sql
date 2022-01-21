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
RETURNS @Details TABLE (
    ReservationID int, 
    CustomerID int, 
    StartDate datetime, 
    EndDate datetime, 
    Guests nvarchar(max), 
    Status varchar(16)
)
BEGIN
    INSERT @Details
        SELECT 
            ReservationID, 
            CustomerID, 
            StartDate, 
            EndDate, 
            Guests, 
            Status 
        FROM 
            ReservationsDetails
        WHERE 
            ReservationID = @ReservationID
        ORDER BY 
            StartDate
    RETURN
END
GO
--<

--> Funkcje
--# GetCustomersReservations
--- Zwraca informacje na temat wszystkich rezerwacji danego klienta wraz z informacją o ich statusie.
CREATE OR ALTER FUNCTION GetCustomersReservations(@CustomerID int)
RETURNS 
    @AllReservations TABLE (
        CustomerID int, 
        ReservationID int, 
        StartDate datetime, 
        EndDate datetime, 
        Guests nvarchar(max), 
        Status varchar(16)
    )
BEGIN
    INSERT @AllReservations
        SELECT 
            CustomerID, 
            ReservationID, 
            StartDate, 
            EndDate, 
            Guests, 
            Status 
        FROM 
            ReservationDetails 
        WHERE 
            CustomerID = @CustomerID
        ORDER BY 
            StartDate
    RETURN
END
GO
--<


