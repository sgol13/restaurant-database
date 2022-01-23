--> Widoki
--# MenusInProgress
--- Pokazuje nieaktywne menu.
CREATE OR ALTER VIEW MenusInProgress AS
    SELECT 
        MenuID 
    FROM 
        Menu 
    WHERE
        Active = 0
GO
--<

--> Widoki
--# CurrentMenu
--- Pokazuje aktualne menu dla zamówień na ten sam dzień
CREATE OR ALTER VIEW CurrentMenu
AS 
    SELECT 
        MealID, 
        Name, 
        Price
    FROM 
        dbo.GetMenuForDay(GETDATE())
GO
--<