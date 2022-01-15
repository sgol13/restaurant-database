--> Widoki
--# CurrentTables
--- Podgląd aktualnego stanu stolików.
CREATE OR ALTER VIEW CurrentTables
AS ((SELECT T.TableID, Seats, 'Available' as Availability, null as ReservationID, null as EndOfReservation
FROM Tables T
WHERE dbo.TableAvailableAtTime(T.TableID, GETDATE(), GETDATE()) = 1)
UNION
(SELECT T.TableID, Seats, 'Occupied', CurrentTableReservation(T.TableID), dbo.EndOfTableOccupationTime(T.TableID)
FROM Tables T
WHERE dbo.TableAvailableAtTime(T.TableID, GETDATE(), GETDATE()) = 0))
GO
--<
