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
--# GetCustomersReservations(CustomerID)
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


--> Funkcje
--# CanReserveOnline(CustomerID, CompletionDate, OrderedItems)
--- Zwraca informację czy dany klient indywidualny spełnia warunki do złożenia rezerwacji online.
CREATE OR ALTER FUNCTION CanReserveOnline(@CustomerID int, @CompletionDate datetime, @OrderedItems OrderedItemsListT READONLY)
RETURNS bit
BEGIN

    DECLARE @MenuID int = dbo.GetMenuIDForDay(@CompletionDate)

    DECLARE @MinAmount money = (SELECT WZ FROM CurrentConstants)
    DECLARE @MinOrdersNum int = (SELECT WK FROM CurrentConstants)

    DECLARE @TotalAmount money = (
        SELECT
            sum(oi.Quantity * mi.Price)
        FROM
            @OrderedItems oi
            INNER JOIN MenuItems mi ON mi.MealID = oi.MealID AND mi.MenuID = @MenuID
        )

    DECLARE @OrdersNum int = (
        SELECT 
            count(1)
        FROM 
            Orders
        WHERE
            CustomerID = @CustomerID
            AND Completed = 1
        )

    RETURN CASE WHEN @TotalAmount >= @MinAmount AND @OrdersNum >= @MinOrdersNum THEN 1 ELSE 0 END
END
--<