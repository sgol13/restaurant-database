--> Procedury
--# AddTable(Seats)
--- Dodaje nowy stolik
CREATE OR ALTER PROCEDURE AddTable (@Seats int)
AS BEGIN
    INSERT INTO Tables(Seats, Active)
    VALUES (@Seats, 1)
END
GO
--<


--> Procedury
--# DisableTable(TableID)
--- Oznacza stolik jako nieaktywny
CREATE OR ALTER PROCEDURE DisableTable (@TableID int)
AS BEGIN

    IF(SELECT Active FROM Tables WHERE TableID = @TableID) = 0
    BEGIN
        ;THROW 52000, 'Table already inactive', 1
        RETURN
    END

    UPDATE Tables SET Active = 0
    WHERE TableID = @TableID
END
GO
--<


--> Procedury
--# EnableTable(TableID)
--- Oznacza stolik jako aktywny
CREATE OR ALTER PROCEDURE EnableTable (@TableID int)
AS BEGIN

    IF(SELECT Active FROM Tables WHERE TableID = @TableID) = 1
    BEGIN
        ;THROW 52000, 'Table already active', 1
        RETURN
    END

    UPDATE Tables SET Active = 1
    WHERE TableID = @TableID
END
GO
--<
