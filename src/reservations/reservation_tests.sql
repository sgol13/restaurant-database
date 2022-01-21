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

-- ADD NEW RESERCATION
BEGIN
BEGIN TRANSACTION;
    DECLARE @tables ReservationTablesListT;
    INSERT INTO @tables
    VALUES (2), (4), (6);

    DECLARE @ResID int;
    EXEC AddReservation @CustomerID = 1, @StartDate='2022-01-21', @EndDate='2022-01-21 02:00', @Tables = @tables, @ReservationID = @ResID OUTPUT;

    SELECT * FROM Reservations

ROLLBACK;
END


SELECT * FROM Tables



