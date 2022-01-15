--> Widoki
--# MenusInProgress
--- Pokazuje nieaktywne menu.
CREATE OR ALTER VIEW MenusInProgress AS
SELECT MenuID FROM Menu WHERE Active = 0
GO
--<

--> Widoki
--# CurrentMenu
--- Zwraca aktualne menu dla zamówień na ten sam dzień
CREATE OR ALTER VIEW CurrentMenu
AS SELECT MI.MenuID, MI.MealID, MI.Price
FROM MenuItems MI INNER JOIN Menu M ON M.MenuID = MI.MenuID
WHERE StartDate <= GETDATE() AND GETDATE() <= EndDate
GO
--<