-- CREATE INVOICE
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 5);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;
    EXEC PayForOrder @OrderID = @OrderID;

    -- PRINT dbo.CanCreateInvoice(1)
    EXEC CreateOrderInvoice @OrderID = @OrderID;

    SELECT * FROM Invoices

ROLLBACK;
END

SELECT * FROM Customers
SELECT * FROM PrivateCustomers