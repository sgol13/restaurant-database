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