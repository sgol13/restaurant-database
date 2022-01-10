CREATE OR ALTER PROCEDURE CreateOrder(@CustomerID int, @CompletionDate datetime, @OrderedItems OrderedItemsListT READONLY)
AS BEGIN


    -- check if the customer exists
    IF NOT EXISTS (SELECT * FROM Customers WHERE CustomerID = @CustomerID)
    BEGIN
        ;THROW 52000, 'The customer does not exist', 1
        RETURN 
    END

    DECLARE @MenuID int = dbo.GetMenuForDay(@CompletionDate)
    IF @MenuID IS NULL
    BEGIN
        ;THROW 52000, 'The menu does not exist', 1
        RETURN 
    END

    -- check if all items belong to the proper menu
    IF (SELECT count(1) FROM @OrderedItems) != (SELECT count(1) FROM MenuItems WHERE MenuID = @MenuID AND MealID IN (SELECT MealID FROM @OrderedItems))
    BEGIN
        ;THROW 52000, 'The ordered items list is incorrect', 1
        RETURN 
    END

    INSERT INTO Orders(CustomerID, OrderDate, Paid) 
    VALUES (@CustomerID, GETDATE(), 0)

    DECLARE @OrderID int = @@IDENTITY

    INSERT INTO OrderDetails(OrderID, Quantity, MealID, MenuID)
    SELECT @OrderID, Quantity, MealID, @MenuID FROM @OrderedItems

END
GO


SELECT * FROM MenuItems WHERE MenuID = 2
declare @p1 dbo.OrderedItemsListT
insert into @p1 values(1, 1)
insert into @p1 values(8, 1)
EXEC CreateOrder @CustomerID = 1, @CompletionDate = '2022-01-05', @OrderedItems=@p1;

SELECT * FROM OrderDetails