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

-- TEST OK, double invoice
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 5);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID = @OrderID;

    EXEC CreateOrderInvoice @OrderID = @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID = @OrderID;

    EXEC CreateOrderInvoice @OrderID = @OrderID;

    SELECT * FROM Invoices

    SELECT *FROM Orders

ROLLBACK;
END

-- MONTHLY INVOICE TESTS ok
BEGIN
BEGIN TRANSACTION;

    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (2, 1), (3, 2), (4, 3);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-25', @CompletionDate = '2021-12-26 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-24', @CompletionDate = '2021-12-25 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-23', @CompletionDate = '2021-12-24 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateMonthlyInvoice @CustomerID = 1, @Month = 12, @Year = 2021;

    SELECT * FROM Invoices
    SELECT *FROM Orders

ROLLBACK;
END

-- MONTHLY INVOICE TESTS - error, the month has not passed
BEGIN
BEGIN TRANSACTION;

    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (2, 1), (3, 2), (4, 3);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-25', @CompletionDate = '2021-12-26 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-24', @CompletionDate = '2021-12-25 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-23', @CompletionDate = '2021-12-24 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateMonthlyInvoice @CustomerID = 1, @Month = 1, @Year = 2022;

    SELECT * FROM Invoices
    SELECT *FROM Orders

ROLLBACK;
END

-- MONTHLY INVOICE TESTS - error, amount must be positive
BEGIN
BEGIN TRANSACTION;

    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (2, 1), (3, 2), (4, 3);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-25', @CompletionDate = '2021-12-26 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-24', @CompletionDate = '2021-12-25 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2021-12-23', @CompletionDate = '2021-12-24 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID;

    EXEC CreateMonthlyInvoice @CustomerID = 1, @Month = 11, @Year = 2021;

    SELECT * FROM Invoices
    SELECT *FROM Orders

ROLLBACK;
END


SELECT * FROM MenuItems

SELECT * FROM Customers
SELECT * FROM PrivateCustomers
-- DELETE FROM OrderDetails
-- DELETE FROM Orders