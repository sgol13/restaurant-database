-- SEAFOOD CHECKING TESTS

SELECT dbo.CanOrderSeafood('2022-01-10', '2022-01-15') returned , 1 expected
UNION ALL
SELECT dbo.CanOrderSeafood('2022-01-10', '2022-01-16') returned , 0 expected
UNION ALL
SELECT dbo.CanOrderSeafood('2021-12-10', '2022-01-12') returned , 0 expected
UNION ALL
SELECT dbo.CanOrderSeafood('2021-12-10', '2022-01-14') returned , 0 expected
UNION ALL
SELECT dbo.CanOrderSeafood('2022-01-04', '2022-01-13') returned , 1 expected
UNION ALL
SELECT dbo.CanOrderSeafood('2022-01-10 09:35:10', '2022-01-13 11:40') returned , 1 expected
UNION ALL
SELECT dbo.CanOrderSeafood('2022-01-09 11:30:10', '2022-01-15 18:40') returned , 1 expected


-- EXPECTED ERROR incorrect date
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (12, 1);
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-15', @CompletionDate = '2022-01-14', @OrderedItems = @items;
ROLLBACK;
END

-- EXPECTED ERROR no customer
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (12, 1);
    EXEC CreateOrder @CustomerID =7543, @OrderDate = '2022-01-15', @CompletionDate = '2022-01-27', @OrderedItems = @items;
ROLLBACK;
END

-- EXPECTED ERROR no menu
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2021-05-04', @CompletionDate = '2021-06-27', @OrderedItems = @items;
ROLLBACK;
END


-- EXPECTED ERROR incorrect items
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (13, 1);
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-15', @CompletionDate = '2022-01-27', @OrderedItems = @items;
ROLLBACK;
END

-- EXPECTED ERROR incorrect items
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (2, 1);
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-15', @CompletionDate = '2022-01-27', @OrderedItems = @items;
ROLLBACK;
END


-- EXPECTED ERROR seafood
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-11', @CompletionDate = '2022-01-14', @OrderedItems = @items;
ROLLBACK;
END


-- EXPECTED ERROR seafood
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-12', @OrderedItems = @items;
ROLLBACK;
END


-- EXPECTED OK
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    SELECT * FROM OrderDetails WHERE OrderID = @OrderID
    SELECT * FROM Orders WHERE CustomerID = 1
ROLLBACK;
END


-- EXPECTED OK
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (4, 1);

    DECLARE @OrderID int;
    EXEC CreateInstantOrder @CustomerID =1, @CompletionDate = '2022-01-15 16:32', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    SELECT * FROM OrderDetails WHERE OrderID = @OrderID
    SELECT * FROM Orders WHERE CustomerID = 1
ROLLBACK;
END


-- INTEGRATION TEST 1
BEGIN
BEGIN TRANSACTION;

    DECLARE @items1 OrderedItemsListT;
    INSERT INTO @items1 VALUES (1, 1), (3, 20), (4, 1);

    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-15 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-16 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-17 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-18 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-19 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-20 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-21 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-22 16:32', @OrderedItems = @items1;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-23 16:32', @OrderedItems = @items1;

    -- SELECT * FROM CurrentConstants
    -- SELECT * FROM OrderDiscounts
    SELECT * FROM CalculatedOrders
    SELECT * FROM dbo.CustomerOrders(1)
    
ROLLBACK;
END

-- CANCEL TEST OK
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    SELECT * FROM Orders WHERE CustomerID = 1

    EXEC CancelOrder @OrderID = @OrderID;

    SELECT * FROM Orders WHERE CustomerID = 1

ROLLBACK;
END


-- CANCEL TEST - error expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC CompleteOrder @OrderID = @OrderID;

    EXEC CancelOrder @OrderID = @OrderID;

ROLLBACK;
END


-- CANCEL TEST - error expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC CancelOrder @OrderID = @OrderID;

    EXEC CancelOrder @OrderID = @OrderID;

ROLLBACK;
END


-- COMPLETE AND PAY TEST - OK expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC CompleteOrder @OrderID = @OrderID;
    EXEC PayForOrder @OrderID = @OrderID;

    SELECT * FROM Orders WHERE CustomerID = 1

ROLLBACK;
END


-- COMPLETE AND PAY TEST - OK expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC PayForOrder @OrderID = @OrderID;
    EXEC CompleteOrder @OrderID = @OrderID;

    SELECT * FROM Orders WHERE CustomerID = 1

ROLLBACK;
END

-- COMPLETE AND PAY TEST - error expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC CancelOrder @OrderID = @OrderID;

    EXEC PayForOrder @OrderID = @OrderID;
    EXEC CompleteOrder @OrderID = @OrderID;

    SELECT * FROM Orders WHERE CustomerID = 1

ROLLBACK;
END

-- CURRENT WEEK SEAFOOD VIEW TEST
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 1);

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-21', @OrderedItems = @items;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-22', @OrderedItems = @items;


    DECLARE @items2 OrderedItemsListT;
    INSERT INTO @items2
    VALUES (1, 1), (3, 2);

    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-23', @OrderedItems = @items2;
    EXEC CreateOrder @CustomerID = 1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-24', @OrderedItems = @items2;

    SELECT * FROM CurrentWeekSeaFoodOrders

ROLLBACK;
END

-- ORDERS TO COMPLETE TODAY TEST
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    EXEC CancelOrder @OrderID = @OrderID;

    EXEC CreateOrder @CustomerID = 1, @CompletionDate = '2022-01-20 19:50', @OrderedItems = @items;
    EXEC CreateOrder @CustomerID = 1, @CompletionDate = '2022-01-20 20:50', @OrderedItems = @items;

    SELECT * FROM OrdersToCompleteToday

ROLLBACK;
END


-- GET ORDER DETAILS TEST
-- ORDERS TO COMPLETE TODAY TEST
BEGIN
BEGIN TRANSACTION;
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items
    VALUES (1, 1), (3, 2), (6, 5);

    DECLARE @OrderID int;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-20 19:40', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    SELECT * FROM dbo.GetOrderDetails(@OrderID)

ROLLBACK;
END

SELECT * FROM Meals

SELECT * FROM MenuItems mi INNER JOIN Meals m ON m.MealID = mi.MealID WHERE MenuID = 3
SELECT * FROM Menu

-- DELETE FROM Meals
-- DELETE FROM Menu 
-- DELETE FROM MenuItems