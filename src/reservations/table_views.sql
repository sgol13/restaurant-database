--> Widoki
--# CurrentTables
--- Podgląd aktualnego stanu stolików.
CREATE OR ALTER VIEW CurrentTables
AS 
    SELECT
        TableID,
        Seats,
        (CASE
            WHEN dbo.TableAvailableAtTime(TableID, GETDATE(), GETDATE()) = 1 THEN 'dostepny'
            ELSE 'zajety'
        END
        ) Status,
        dbo.CurrentTableReservation(TableID) ReservationID, 
        dbo.EndOfTableOccupationTime(TableID) EndOfReservation
    FROM Tables
--<
