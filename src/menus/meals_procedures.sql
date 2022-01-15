--> Procedury
--# NewMeal(Name, IsSeaFood, DefaultPrice, Active = 1, MealID OUTPUT)
--- Tworzy nowy posiłek.
CREATE OR ALTER PROCEDURE NewMeal(@Name nvarchar(64), @IsSeaFood bit, @DefaultPrice money, @Active bit = 1, @MealID int OUTPUT)
AS BEGIN
    INSERT INTO Meals([Name], SeaFood, DefaultPrice, Active)
    VALUES(@Name, @IsSeaFood, @DefaultPrice, @Active)
    
    SET @MealID = @@IDENTITY
END
GO

GRANT EXECUTE ON OBJECT::dbo.NewMeal TO manager
GO
--<

--> Procedury
--# SetMealActive(MealID, Active)
--- Aktywuje lub dezaktywuje posiłek.
CREATE OR ALTER PROCEDURE SetMealActive(@MealID int, @Active bit)
AS BEGIN
    UPDATE Meals
    SET Active = @Active
    WHERE MealID = @MealID
END
GO

GRANT EXECUTE ON OBJECT::dbo.SetMealActive TO manager
GO
--<

--> Procedury
--# UpdateMealDefaultPrice(MealID, DefaultPrice)
--- Zmienia podstawową cenę posiłku.
CREATE OR ALTER PROCEDURE UpdateMealDefaultPrice(@MealID int, @DefaultPrice money)
AS BEGIN
    UPDATE Meals
    SET DefaultPrice = @DefaultPrice
    WHERE MealID = @MealID
END
GO

GRANT EXECUTE ON OBJECT::dbo.UpdateMealDefaultPrice TO manager
GO
--<
