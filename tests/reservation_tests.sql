-- TABLES test - ok
BEGIN
BEGIN TRANSACTION;

    DBCC CHECKIDENT (Tables, RESEED, 0)

    DELETE FROM Tables
    EXEC AddTable @Seats = 5;
    EXEC AddTable @Seats = 2;

    SELECT * FROM Tables

    EXEC DisableTable @TableID = 1;

    SELECT * FROM Tables

    EXEC EnableTable @TableID = 1;

    SELECT * FROM Tables

ROLLBACK;
END

-- ADD NEW RESERVATION - ok
BEGIN
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);

    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (1), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    SELECT * FROM Reservations

ROLLBACK;
END

-- ADD NEW RESERVATION -error expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);

    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (2), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    SELECT * FROM Reservations

ROLLBACK;
END

-- ADD NEW RESERVATION -ok expected
BEGIN
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);

    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (2), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 04:10', @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    SELECT * FROM Reservations

ROLLBACK;
END

-- ADD NEW RESERVATION NOW
BEGIN
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (1), (3), (5);
    EXEC AddReservation @CustomerID = 1, @Guests = "a b c", @StartDate='2022-01-21 0:10', 
                    @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    DECLARE @tables3 ReservationTablesListT;
    INSERT INTO @tables3
    VALUES (11), (12);
    EXEC AddInstantReservation @CustomerID = 1, @EndDate='2022-01-21 05:25', @Tables = @tables3, @ReservationID = @ResID OUTPUT;

    SELECT * FROM Reservations
    SELECt * FROM TableDetails

ROLLBACK;
END


-- CURRENT RESERVATIONS
BEGIN
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);

    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (1), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    SELECT * FROM CurrentTables

    SELECT * FROM ReservationsDetails

    SELECT * FROM dbo.SingleReservationDetails(@ResID)

    SELECT * FROM dbo.GetCustomersReservations(1)

ROLLBACK;
END

-- FINISH RESERVATION
BEGIN
BEGIN TRY
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);

    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (1), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    EXEC FinishCurrentReservation @ReservationID = @ResID;

    SELECT * FROM ReservationsDetails

ROLLBACK;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
    ROLLBACK
;THROW
END CATCH
END

-- EXTEND RESERVATION - exptected ok
BEGIN
BEGIN TRY
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);

    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 01:00', @EndDate='2022-01-21 04:00', @Tables = @tables1, @ReservationID = @ResID OUTPUT;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (1), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 05:25', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    EXEC ExtendCurrentReservation @ReservationID = @ResID, @NewEndDate = '2022-01-21 09:00';

    SELECT * FROM ReservationsDetails

    SELECT * FROM TodayReservations

ROLLBACK;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
    ROLLBACK
;THROW
END CATCH
END

-- EXTEND RESERVATION - exptected error
BEGIN
BEGIN TRY
BEGIN TRANSACTION;
    DECLARE @ResID int;
    
    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21 15:00', @EndDate='2022-01-21 16:00', @Tables = @tables1;

    DECLARE @tables2 ReservationTablesListT;
    INSERT INTO @tables2
    VALUES (2), (3), (5);
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 14:00', @Tables = @tables2, @ReservationID = @ResID OUTPUT;

    EXEC ExtendCurrentReservation @ReservationID = @ResID, @NewEndDate = '2022-01-21 14:30';

    SELECT * FROM ReservationsDetails

    SELECT * FROM dbo.TablesAvailableToReserve('2022-01-21 14:00', '2022-01-21 15:00')

ROLLBACK;
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
    ROLLBACK;
THROW;
END CATCH
END

-- PRIVATE ONLINE RESERVATION
BEGIN
BEGIN TRY
BEGIN TRANSACTION;

    DBCC CHECKIDENT (Reservations, RESEED, 0)

    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);
    
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items VALUES (1, 1), (3, 20), (4, 1);

    -- DECLARE @items OrderedItemsListT;
    -- INSERT INTO @items VALUES (1, 1), (3, 20), (6, 1);

    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-18 16:32', @OrderedItems = @items;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-18 17:32', @OrderedItems = @items;
    EXEC CreateInstantOrder @CustomerID = 1, @CompletionDate = '2022-01-18 18:32', @OrderedItems = @items;

    PRINT dbo.CanReserveOnline(1, '2022-01-22 15:39:50', @items)
    EXEC PrivateOnlineReservation @StartDate='2022-01-22 14:00', @EndDate='2022-01-22 14:30', @CustomerID=1, @Tables=@tables1, @OrderedItems=@items;

    -- EXEC AcceptReservation @ReservationID =1;
    EXEC CancelReservation @ReservationID = 1;

    SELECT * FROM ReservationsDetails
    SELECT * FROM CalculatedOrders

IF @@TRANCOUNT > 0
    ROLLBACK;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK;
THROW;
END CATCH
END


-- COMPANY ONLINE RESERVATION
BEGIN
BEGIN TRY
BEGIN TRANSACTION;

    DBCC CHECKIDENT (Reservations, RESEED, 0)

    DECLARE @tables1 ReservationTablesListT;
    INSERT INTO @tables1
    VALUES (2), (4), (6);
    
    DECLARE @items OrderedItemsListT;
    INSERT INTO @items VALUES (1, 1), (3, 20), (4, 1);

    -- DECLARE @items OrderedItemsListT;
    -- INSERT INTO @items VALUES (1, 1), (3, 20), (6, 1);

    EXEC CreateInstantOrder @CustomerID = 5, @CompletionDate = '2022-01-18 16:32', @OrderedItems = @items;
    EXEC CreateInstantOrder @CustomerID = 5, @CompletionDate = '2022-01-18 17:32', @OrderedItems = @items;

    PRINT dbo.CanReserveOnline(1, '2022-01-22 15:39:50', @items)
    EXEC CompanyOnlineReservation @StartDate='2022-01-22 14:00', @EndDate='2022-01-22 14:30', @CustomerID=6, @Tables=@tables1, @OrderedItems=@items;

    EXEC AcceptReservation @ReservationID =1;
    -- EXEC CancelReservation @ReservationID = 1;

    SELECT * FROM ReservationsDetails
    SELECT * FROM CalculatedOrders

IF @@TRANCOUNT > 0
    ROLLBACK;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK;
THROW;
END CATCH
END


SELECT * FROM Tables

SELECT * FROM TableDetails
-- DELETE FROM Orders
-- DELETE FROM OrderDetails
-- DELETE FROM TableDetails
-- DELETE FROM Reservations