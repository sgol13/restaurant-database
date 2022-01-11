--> Procedury
--# CreateOrder(CustomerID, CompletionDate, OrderedItems)
--- Tworzy nowe zamówienie w systemie. Zamówienie jest przypisane do konkretnego klienta i ma datę odbioru.
CREATE OR ALTER PROCEDURE CreateOrder(@CustomerID int, @CompletionDate datetime, @OrderedItems OrderedItemsListT READONLY)
AS BEGIN

    SET XACT_ABORT ON

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

    BEGIN TRANSACTION
    -- BEGIN TRY

        INSERT INTO Orders(CustomerID, OrderDate, Paid) 
        VALUES (@CustomerID, GETDATE(), 0)

        DECLARE @OrderID int = @@IDENTITY

        INSERT INTO OrderDetails(OrderID, Quantity, MealID, MenuID)
        SELECT @OrderID, Quantity, MealID, @MenuID FROM @OrderedItems

    COMMIT TRANSACTION
    -- END TRY
    -- BEGIN CATCH
    --     ROLLBACK TRANSACTION
    -- END CATCH
    
END
GO
--<


--> Procedury
--# PayForOrder(OrderID)
--- Zapisuje informację, że klient zapłacił za dane zamówienie.
CREATE OR ALTER PROCEDURE PayForOrder (@OrderID int)
AS BEGIN

    -- check if the order exists
    IF NOT EXISTS (SELECT * FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        ;THROW 52000, 'The order does not exist', 1
        RETURN 
    END

    UPDATE Orders
    SET Paid = 1
    WHERE OrderID = @OrderID

END
GO
--<

--> Procedury
--# CompleteOrder(OrderID)
--- Zapisuje informację, że zamówienie zostało wydane klientowi.
CREATE OR ALTER PROCEDURE PayForOrder (@OrderID int)
AS BEGIN

    -- check if the order exists
    IF NOT EXISTS (SELECT * FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        ;THROW 52000, 'The order does not exist', 1
        RETURN
    END

    UPDATE Orders
    SET CompletionDate = GETDATE()
    WHERE OrderID = @OrderID

END
GO
--<

SELECT * FROM MenuItems WHERE MenuID = 2

declare @p1 dbo.OrderedItemsListT
insert into @p1 values(1, 1)
insert into @p1 values(8, 1)
EXEC CreateOrder @CustomerID = 1, @CompletionDate = '2022-01-05', @OrderedItems=@p1;

SELECT * FROM OrderDetails
SELECT * FROM Orders
DELETE FROM Orders