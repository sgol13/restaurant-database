--> Funkcje
--# AreTablesAvailable(StartDate, EndDate, Tables)
--- Sprawdza czy wszystkie stoliki z listy są dostępne w danym przedziale czasowym.
CREATE OR ALTER FUNCTION AreTablesAvailable(@StartDate datetime, @EndDate datetime, @Tables ReservationTablesListT READONLY)
RETURNS BIT
BEGIN
    IF (( SELECT COUNT (*) FROM ( (SELECT TableID FROM @Tables) EXCEPT (SELECT TableID FROM Tables WHERE dbo.TableAvailableAtTime(TableID, @StartDate, @EndDate) = 1)  ) as TTI) != 0)
    BEGIN
        ;THROW 52000, 'Not all selected tables will be available', 1
        RETURN 0
    END
    RETURN 1
END
GO
--<


--> Funkcje
--# ReservationDetails(ReservationID)
--- Zwraca szczegóły na temat danej rezerwacji.
CREATE OR ALTER FUNCTION ReservationDetails(@ReservationID int)
RETURNS @Details TABLE (ReservationID int, CustomerID int, StartDate datetime, EndDate datetime, Guests nvarchar(max), Status varchar(16))
BEGIN
    INSERT @Details
    SELECT ReservationID, CustomerID, StartDate, EndDate, Guests, Status FROM ReservationDetails WHERE ReservationID = @ReservationID
    ORDER BY StartDate
    RETURN
END
GO
--<


--> Funkcje
--# AllClientReservations(CustomerID)
--- Zwraca informacje na temat wszystkich rezerwacji danego klienta wraz z informacją o ich statusie.
CREATE OR ALTER FUNCTION AllClientReservations(@CustomerID int)
RETURNS @AllReservations TABLE (CustomerID int, ReservationID int, StartDate datetime, EndDate datetime, Guests nvarchar(max), Status varchar(16))
BEGIN
    INSERT @AllReservations
    SELECT CustomerID, ReservationID, StartDate, EndDate, Guests, Status FROM ReservationDetails WHERE CustomerID = @CustomerID
    ORDER BY StartDate
    RETURN
END
GO
--<