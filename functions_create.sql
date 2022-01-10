DROP FUNCTION TotalOrderAmount
GO

--> Funkcje
--# TotalOrderAmount(OrderID)
--- Zwraca całkowitą cenę zamówienia biorąc pod uwagę rabaty.
CREATE FUNCTION TotalOrderAmount(@OrderID int) RETURNS money
BEGIN
    RETURN (
        SELECT SUM(OD.Number * MI.Price) * (1-SUM(Discounts.Discount)) FROM Orders
        JOIN OrderDetails AS OD ON OD.OrderID = Orders.OrderID
        JOIN MenuItems AS MI ON MI.MenuID = OD.MenuID AND MI.MealID = OD.MealID
        JOIN OrderDiscounts AS Discounts ON Discounts.OrderID = Orders.OrderID
        WHERE Orders.OrderID = @OrderID
        GROUP BY Orders.OrderID
    )
END
GO

DROP FUNCTION IsDiscountType1
GO


--> Funkcje
--# IsDiscountType1(CustomerID)
--- Sprawdza czy klientowi przysługuje w tej chwili rabat typu pierwszego (co najmniej Z1 zamówień za kwotę przynajmniej K1)
CREATE FUNCTION IsDiscountType1(@CustomerID int) Returns bit
BEGIN
    DECLARE @MinOrdersNumber int = (SELECT Z1 FROM CurrentConstants)
    DECLARE @MinSingleOrderAmount int  = (SELECT K1 FROM CurrentConstants)

    DECLARE @BigOrdersNumber money = (
        SELECT COUNT(1)
        FROM Orders o 
        WHERE o.CustomerID = @CustomerID AND dbo.TotalOrderAmount(o.OrderID) > @MinSingleOrderAmount
    )

    RETURN CASE WHEN (@BigOrdersNumber >= @MinOrdersNumber) THEN 1 ELSE 0 END
END
GO
--<


DROP FUNCTION IsDiscountType2
GO

--> Funkcje
--# IsDiscountType2(CustomerID)
--- Sprawdza czy klientowi przysługuje w tej chwili rabat typu drugiego (zamówienia za co najmniej K2 w ciągu ostatich D1 dni)
CREATE FUNCTION IsDiscountType2(@CustomerID int) RETURNS bit
BEGIN
    DECLARE @MinTotalAmount int = (SELECT K2 FROM CurrentConstants)
    DECLARE @LastDays int  = (SELECT D1 FROM CurrentConstants)

    DECLARE @TotalAmount money = (
        SELECT SUM(dbo.TotalOrderAmount(o.OrderID))
        FROM Orders o 
        WHERE o.CustomerID = @CustomerID AND DATEDIFF(DAY, o.OrderDate, GETDATE()) <= @LastDays
    )

    RETURN CASE WHEN @TotalAmount >= @MinTotalAmount THEN 1 ELSE 0 END
END
GO
--<


--> Funkcje
--# GetMenuForDay(Day datetime)
--- Zwraca ID menu obowiązującego w podanym czasie.
CREATE OR ALTER FUNCTION GetMenuForDay(@Day datetime) RETURNS int
BEGIN
    RETURN (SELECT MenuID FROM Menu WHERE Active = 1 AND @Day BETWEEN StartDate AND EndDate)
END
GO
--<