--> Funkcje
--# TotalDiscountForOrder
--- Zwraca całkowity rabat (w %) udzielony na dane zamówienie
CREATE OR ALTER FUNCTION TotalDiscountForOrder(@OrderID int) RETURNS decimal(5, 2)
BEGIN
    RETURN (
        SELECT COALESCE(SUM(Discount), 0)
        FROM OrderDiscounts
        WHERE OrderID = @OrderID
    )
END
GO
--<

--> Funkcje
--# TotalOrderAmount(OrderID)
--- Zwraca całkowitą cenę zamówienia biorąc pod uwagę rabaty.
CREATE OR ALTER FUNCTION TotalOrderAmount(@OrderID int) RETURNS money
BEGIN
    RETURN (
        SELECT SUM(OD.Quantity * MI.Price) * (1 - dbo.TotalDiscountForOrder(@OrderID)) FROM Orders
            INNER JOIN OrderDetails AS OD ON OD.OrderID = Orders.OrderID
            INNER JOIN MenuItems AS MI ON MI.MenuID = OD.MenuID AND MI.MealID = OD.MealID
        WHERE Orders.OrderID = @OrderID
        GROUP BY Orders.OrderID
    )
END
GO
--<


--> Funkcje
--# CanOrderSeafood(OrderDate, CompletionDate)
--- Zwraca informację czy w dniu OrderDate można złożyć zamówienie na owoce morza, które ma zostać odebrane w dniu CompletionDate
CREATE OR ALTER FUNCTION CanOrderSeafood(@OrderDate datetime, @CompletionDate datetime) RETURNS bit
BEGIN

    IF NOT DATENAME(weekday, @CompletionDate) IN ('Thursday', 'Friday', 'Saturday')
        RETURN 0;

    IF NOT (@OrderDate < @CompletionDate AND (
        DATENAME(week, @OrderDate) < DATENAME(week, @CompletionDate) OR
            DATENAME(weekday, @OrderDate) IN ('Sunday', 'Monday')))
        RETURN 0;

    RETURN 1;
END
GO


--> Funkcje
--# IsDiscountType1(CustomerID)
--- Sprawdza czy klientowi przysługuje w danej chwili rabat typu pierwszego (co najmniej Z1 zamówień za kwotę przynajmniej K1)
--- na zamówienie dokonane w danym terminie.
CREATE OR ALTER FUNCTION IsDiscountType1(@CustomerID int, @CheckDate datetime) RETURNS bit
BEGIN
    DECLARE @MinOrdersNumber int = (SELECT Z1 FROM CurrentConstants)
    DECLARE @MinSingleOrderAmount int  = (SELECT K1 FROM CurrentConstants)

    DECLARE @BigOrdersNumber money = (
        SELECT COUNT(1)
        FROM Orders o 
        WHERE 
            o.CustomerID = @CustomerID AND 
            dbo.TotalOrderAmount(o.OrderID) > @MinSingleOrderAmount AND 
            o.Completed = 1 AND
            o.CompletionDate < @CheckDate
    )

    RETURN CASE WHEN (@BigOrdersNumber >= @MinOrdersNumber) THEN 1 ELSE 0 END
END
GO
--<


--> Funkcje
--# IsDiscountType2(CustomerID)
--- Sprawdza czy klientowi przysługuje w danej chwili rabat typu drugiego (zamówienia za co najmniej K2 w ciągu poprzedzająych D1 dni)
CREATE OR ALTER FUNCTION IsDiscountType2(@CustomerID int, @CheckDate datetime) RETURNS bit
BEGIN
    DECLARE @MinTotalAmount int = (SELECT K2 FROM CurrentConstants)
    DECLARE @LastDays int  = (SELECT D1 FROM CurrentConstants)

    DECLARE @TotalAmount money = (
        SELECT SUM(dbo.TotalOrderAmount(o.OrderID))
        FROM Orders o 
        WHERE
            o.CustomerID = @CustomerID AND 
            DATEDIFF(DAY, o.OrderDate, GETDATE()) <= @LastDays AND 
            o.Completed = 1 AND
            o.CompletionDate < @CheckDate
    )

    RETURN CASE WHEN @TotalAmount >= @MinTotalAmount THEN 1 ELSE 0 END
END
GO
--<