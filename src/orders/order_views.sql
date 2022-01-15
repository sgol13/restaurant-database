--> Widoki
--# CurrentOrders
--- Pokazuje zamówienia w trakcie realizacji.
CREATE OR ALTER VIEW CurrentOrders
AS SELECT OrderID, CustomerID, ReservationID, Paid, InvoiceID FROM Orders
WHERE OrderDate <= GETDATE() AND GETDATE() < CompletionDate
GO
--<

--> Widoki
--# OrderHist
--- Pokazuje historię zamówień.
CREATE OR ALTER VIEW OrderHist
AS SELECT OrderID, CustomerID, ReservationID, Paid, InvoiceID FROM Orders WHERE CompletionDate <= GETDATE()
GO
--<


--> Widoki
--# SeafoodOrders
--- Pokazuje zamówienia, które zawierają dania z owocami morza.
CREATE OR ALTER VIEW SeafoodOrders
AS SELECT O.OrderID, M.MealID, MI.MenuID, OD.Quantity, O.CustomerID, O.ReservationID, O.OrderDate, O.CompletionDate, O.Paid, O.InvoiceID
    FROM Orders O
    INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
    INNER JOIN MenuItems MI ON OD.MenuID = MI.MenuID AND OD.MealID = MI.MealID
    INNER JOIN Meals M ON M.MealID = MI.MealID
WHERE SeaFood = 1
GO
--<