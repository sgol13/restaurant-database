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
FROM MenuItems MI 
    INNER JOIN Menu M ON M.MenuID = MI.MenuID
    INNER JOIN Meals ON Meals.MealID = MI.MealID
WHERE StartDate <= GETDATE() AND GETDATE() <= EndDate AND Meals.SeaFood = 0
GO
--<