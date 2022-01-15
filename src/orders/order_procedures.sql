--> Procedury
--# CreateOrder
--- Tworzy nowe zamówienie w systemie. Zamówienie jest przypisane do konkretnego klienta i ma ustaloną datę odbioru.
CREATE OR ALTER PROCEDURE CreateOrder(
    @CustomerID int, 
    @OrderDate datetime = NULL, 
    @CompletionDate datetime, 
    @OrderedItems OrderedItemsListT READONLY,
    @OrderID int = NULL OUTPUT
)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        IF @OrderDate IS NULL
            SET @OrderDate = GETDATE()

        IF @CompletionDate < @OrderDate BEGIN
            ;THROW 52000, 'The completion date is before the order date', 1
            RETURN 
        END

        -- check if the customer exists
        IF NOT EXISTS (SELECT * FROM Customers WHERE CustomerID = @CustomerID) BEGIN
            ;THROW 52000, 'The customer does not exist', 1
            RETURN 
        END

        DECLARE @MenuID int = dbo.GetMenuIDForDay(@CompletionDate)
        IF @MenuID IS NULL
        BEGIN
            ;THROW 52000, 'The menu does not exist', 1
            RETURN 
        END

        -- check if all items belong to the proper menu
        IF (SELECT count(1) FROM @OrderedItems) !=  (SELECT count(1) FROM MenuItems WHERE MenuID = @MenuID AND MealID IN (SELECT MealID FROM @OrderedItems)) BEGIN
            ;THROW 52000, 'The ordered items list is incorrect', 1
            RETURN 
        END

        -- check if order incluing seafood is placed in enough advance
        IF EXISTS (SELECT * FROM @OrderedItems oi INNER JOIN Meals m ON m.MealID = oi.MealID WHERE m.SeaFood = 1)
        AND 0 = dbo.CanOrderSeafood(@OrderDate, @CompletionDate) BEGIN
            ;THROW 52000, 'The order including seafood must be placed in advance', 1
        END


        INSERT INTO Orders(CustomerID, OrderDate, CompletionDate, Paid, Canceled, Completed) 
        VALUES (@CustomerID, @OrderDate, @CompletionDate, 0, 0, 0)

        SET @OrderID = @@IDENTITY

        INSERT INTO OrderDetails(OrderID, Quantity, MealID, MenuID)
        SELECT @OrderID, Quantity, MealID, @MenuID FROM @OrderedItems
        
    COMMIT  
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<

--> Procedury
--# CreateOrder
--- Tworzy nowe zamówienie w systemie i ustawia je jako zrealizowane. Funkcja jes wykorzystywana, gdy klient kupuje towar na miejscu.
CREATE OR ALTER PROCEDURE CreateInstantOrder(
    @CustomerID int, 
    @CompletionDate datetime, 
    @OrderedItems OrderedItemsListT READONLY,
    @OrderID int = NULL OUTPUT
)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        EXEC CreateOrder 
            @CustomerID = @CustomerID,
            @OrderDate = @CompletionDate,
            @CompletionDate = @CompletionDate,
            @OrderedItems = @OrderedItems,
            @OrderID = @OrderID OUTPUT;

        UPDATE Orders SET Completed = 1 WHERE OrderID = @OrderID
        
    COMMIT  
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# CancelOrder
--- Anuluje zamówienie, które nie zostało jeszcze zrealizowane.
CREATE OR ALTER PROCEDURE CancelOrder (@OrderID int)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        -- check if the order exists
        IF NOT EXISTS (SELECT * FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order does not exist', 1
            RETURN 
        END

        -- check if the order was completed
        IF 1 = (SELECT Completed FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order has been already completed', 1
            RETURN;
        END

        -- check if the order was canceled
        IF 1 = (SELECT Canceled FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order has been already canceled', 1
            RETURN;
        END

        -- set order as canceled
        UPDATE Orders SET Canceled = 1 WHERE OrderID = @OrderID

    COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# PayForOrder
--- Zapisuje informację, że klient zapłacił za dane zamówienie.
CREATE OR ALTER PROCEDURE PayForOrder (@OrderID int)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        -- check if the order exists
        IF NOT EXISTS (SELECT * FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order does not exist', 1
            RETURN 
        END

        -- check if the order was paid
        IF 1 = (SELECT Paid FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order has been already paid', 1
            RETURN;
        END

        -- check if the order was canceled
        IF 1 = (SELECT Canceled FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order was canceled', 1
            RETURN;
        END

        UPDATE Orders SET Paid = 1 WHERE OrderID = @OrderID

    COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<



--> Procedury
--# CompleteOrder
--- Zapisuje informację, że zamówienie zostało wydane klientowi.
CREATE OR ALTER PROCEDURE CompleteOrder (@OrderID int, @CompletionDate datetime = NULL)
AS BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        -- check if the order exists
        IF NOT EXISTS (SELECT * FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order does not exist', 1
            RETURN 
        END

        -- check if the order was canceled
        IF 1 = (SELECT Canceled FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order was canceled', 1
            RETURN;
        END

        -- check if the order was completed
        IF 1 = (SELECT Completed FROM Orders WHERE OrderID = @OrderID) BEGIN
            ;THROW 52000, 'The order has been already completed', 1
            RETURN;
        END

        UPDATE Orders 
        SET Completed = 1,
            CompletionDate = ISNULL(@CompletionDate, GETDATE())
        WHERE OrderID = @OrderID

    COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<
