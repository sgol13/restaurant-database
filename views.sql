DROP VIEW CurrentOrders
GO

--> Widoki
--# CurrentOrders
--- Pokazuje zamówienia w trakcie realizacji.
CREATE VIEW CurrentOrders
AS SELECT OrderID, CustomerID, ReservationID, Paid, InvoiceID FROM Orders
WHERE OrderDate <= GETDATE() AND GETDATE() < CompletionDate
GO
--<

DROP VIEW OrderHist
GO

--> Widoki
--# OrderHist
--- Pokazuje historię zamówień.
CREATE VIEW OrderHist
AS SELECT OrderID, CustomerID, ReservationID, Paid, InvoiceID FROM Orders WHERE CompletionDate <= GETDATE()
GO
--<

DROP VIEW ReservationsToAccept
GO

--> Widoki
--# ReservationsToAccept
--- Pokazuje rezerwacje, które nie zostały zaakceptowane.
CREATE VIEW ReservationsToAccept
AS SELECT ReservationID, CustomerID, Guests, Canceled FROM Reservations WHERE Accepted = 0
GO
--<

DROP VIEW SeafoodOrders
GO

--> Widoki
--# SeafoodOrders
--- Pokazuje zamówienia, które zawierają dania z owocami morza.
CREATE VIEW SeafoodOrders
AS SELECT O.OrderID, M.MealID, MI.MenuID, OD.Number, O.CustomerID, O.ReservationID, O.OrderDate, O.CompletionDate, O.Paid, O.InvoiceID
    FROM Orders O
    INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    INNER JOIN MenuItems MI ON OD.MenuID = MI.MenuID AND OD.MealID = MI.MealID
    INNER JOIN Meals M ON M.MealID = MI.MealID
WHERE SeaFood = 1
GO
--<

DROP VIEW CurrentConstants
GO

--> Widoki
--# CurrentConstants
--- Zwraca aktualne wartości stałych w systemie
CREATE VIEW CurrentConstants
AS SELECT TOP 1 c.Z1, c.K1, c.R1, c.K2, c.R2, c.D1, c.WZ, c.WK
    FROM Constants c
    ORDER BY c.[Date] DESC
GO
--<

DROP VIEW CurrentMenu
GO

--> Widoki
--# CurrentMenu
--- Zwraca aktualne menu dla zamówień na ten sam dzień
CREATE VIEW CurrentMenu
AS SELECT MI.MenuID, MI.MealID, MI.Price
FROM MenuItems MI INNER JOIN Menu M ON M.MenuID = MI.MenuID
WHERE StartDate <= GETDATE() AND GETDATE() <= EndDate
GO
--<

DROP VIEW TablesAvailableNow
GO

--> Widoki
--# TablesAvailableNow
--- Zwraca aktualnie dostępne stoliki
CREATE VIEW TablesAvailableNow
AS SELECT T.TableID, Seats
FROM Tables T INNER JOIN TableDetails TD ON T.TableID = TD.TableID
INNER JOIN Reservations R ON TD.ReservationID = R.ReservationID
WHERE Active = 1 AND
(T.TableID NOT IN (SELECT TableID FROM TableDetails)
OR T.TableID NOT IN (SELECT TableID FROM TableDetails TD1
    INNER JOIN Reservations R1 ON TD1.ReservationID = R1.ReservationID
    WHERE R1.StartDate <= GETDATE() AND GETDATE() <= EndDate))
GO
--<
