--> Widoki
--# CurrentOrders
--- Pokazuje zamówienia w trakcie realizacji.
CREATE VIEW CurrentOrders
AS SELECT * FROM Orders
WHERE OrderDate <= GETDATE() AND GETDATE() < CompletionDate
GO
--<

--> Widoki
--# OrderHist
--- Pokazuje historię zamówień.
CREATE VIEW OrderHist
AS SELECT * FROM Orders WHERE CompletionDate <= GETDATE()
GO
--<

--> Widoki
--# ReservationsToAccept
--- Pokazuje rezerwacje, które nie zostały zaakceptowane.
CREATE VIEW ReservationsToAccept
AS SELECT * FROM Reservations WHERE Accepted = 0
GO
--<

--> Widoki
--# SeafoodOrders
--- Pokazuje zamówienia, które zawierają dania z owocami morza.
CREATE VIEW SeafoodOrders
AS SELECT *
    FROM Orders O
    INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    INNER JOIN MenuItems MI ON OD.MenuID = MI.MenuID AND OD.MealID = MI.MealID
    INNER JOIN Meals M ON M.MealID = MI.MealID
WHERE SeaFood = 1
GO
--<