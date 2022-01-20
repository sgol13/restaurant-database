-- CREATE INVOICE - error - already has an invoice
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 5);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID = @OrderID;

    EXEC CreateOrderInvoice @OrderID = @OrderID;

    EXEC CreateOrderInvoice @OrderID = @OrderID;
    SELECT * FROM Invoices

    SELECT *FROM Orders

ROLLBACK;
END

-- ERROR not paid
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 5);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC CreateOrderInvoice @OrderID = @OrderID;

    SELECT * FROM Invoices

    SELECT *FROM Orders

ROLLBACK;
END

-- TEST OK
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 5);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID = @OrderID;

    EXEC CreateOrderInvoice @OrderID = @OrderID;

    SELECT * FROM Invoices

    SELECT *FROM Orders

ROLLBACK;
END

SELECT * FROM Customers
SELECT * FROM PrivateCustomers
-- DELETE FROM OrderDetails
-- DELETE FROM Orders