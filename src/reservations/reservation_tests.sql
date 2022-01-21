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

-- ADD NEW RESERCATION - ok
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

-- ADD NEW RESERCATION -error expected
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

-- ADD NEW RESERCATION -ok expected
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

-- ADD NEW RESERCATION NOW
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



SELECT * FROM Tables



