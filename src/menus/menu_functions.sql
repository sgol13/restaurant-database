--> Funkcje
--# GetMenuIDForDay(Day)
--- Zwraca ID menu obowiązującego w podanym czasie.
CREATE OR ALTER FUNCTION GetMenuIDForDay(@Day datetime) RETURNS int
BEGIN
    RETURN (SELECT MenuID FROM Menu WHERE Active = 1 AND @Day BETWEEN StartDate AND EndDate)
END
GO
--<

--> Funkcje
--# GetMenuOrders(MenuID)
--- Zwraca zamówienia korzystające z danego menu, a także klientów którzy je złożyli razem z danymi kontaktowymi.
CREATE OR ALTER FUNCTION GetMenuOrders(@MenuID int)
RETURNS @MenuOrders TABLE(
    OrderID int, 
    CompletionDate datetime, 
    CustomerID int, 
    [Name] nvarchar(256), 
    Phone nvarchar(16), 
    Email nvarchar(64))
BEGIN
    DECLARE @StartDate datetime;
    DECLARE @EndDate datetime;

    SELECT 
        @StartDate = StartDate, 
        @EndDate = @EndDate
    FROM 
        Menu 
    WHERE 
        MenuID = @MenuID

    INSERT @MenuOrders
        SELECT 
            OrderID, 
            CompletionDate, 
            Customers.CustomerID, 
            Name, 
            Phone, 
            Email
        FROM 
            Orders
            JOIN CustomerNames ON CustomerNames.CustomerID = Orders.CustomerID
            JOIN Customers ON Customers.CustomerID = Orders.CustomerID
        WHERE 
            CompletionDate BETWEEN @StartDate AND @EndDate
    RETURN
END
GO
--<


--> Funkcje
--# GetMenuForDay
--- Zwraca menu dostępne w danym dniu w przyszłości.
CREATE OR ALTER FUNCTION GetMenuForDay(@Date datetime)
RETURNS @DayMenu TABLE(
    MealID int,
    Name nvarchar(64),
    SeaFood varchar(4),
    Price money
)
BEGIN

    DECLARE @MenuID int = dbo.GetMenuIDForDay(@Date);
    DECLARE @ShowSeaFood bit = dbo.CanOrderSeafood(GETDATE(), @Date)

    INSERT @DayMenu
        SELECT
            m.MealID,
            m.Name,
            (CASE WHEN m.SeaFood = 1 THEN 'TAK' ELSE 'NIE' END) SeaFood,
            Price
        FROM Meals m
            INNER JOIN MenuItems mi ON mi.MealID = m.MealID
        WHERE 
            mi.MenuID = @MenuID
            AND (m.SeaFood = 0 OR @ShowSeaFood = 1)
    RETURN
END
GO
--<
