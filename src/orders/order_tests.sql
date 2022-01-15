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

    DECLARE @OrderID int = 4;
    EXEC CreateOrder @CustomerID =1, @OrderDate = '2022-01-10', @CompletionDate = '2022-01-15', @OrderedItems = @items, @OrderID = @OrderID OUTPUT;

    SELECT * FROM OrderDetails WHERE OrderID = @OrderID
    SELECT * FROM Orders WHERE CustomerID = 1
ROLLBACK;
END


SELECT * FROM Orders

SELECT * FROM MenuItems mi INNER JOIN Meals m ON m.MealID = mi.MealID WHERE MenuID = 3
SELECT * FROM Menu

DELETE FROM Meals
DELETE FROM Menu 
DELETE FROM MenuItems