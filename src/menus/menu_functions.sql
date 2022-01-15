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

    SELECT @StartDate = StartDate, @EndDate = @EndDate
    FROM Menu WHERE MenuID = @MenuID

    INSERT @MenuOrders
    SELECT OrderID, CompletionDate, Customers.CustomerID, [Name], Phone, Email
    From Orders
    JOIN CustomerNames ON CustomerNames.CustomerID = Orders.CustomerID
    JOIN Customers ON Customers.CustomerID = Orders.CustomerID
    WHERE CompletionDate BETWEEN @StartDate AND @EndDate
    RETURN
END
GO
--<