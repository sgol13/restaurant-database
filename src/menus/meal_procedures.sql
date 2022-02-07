--> Procedury
--# CreateNewMeal(Name, IsSeaFood, DefaultPrice, Active, MealID OUTPUT)
--- Tworzy nowy posiłek.
CREATE OR ALTER PROCEDURE CreateNewMeal(@Name nvarchar(64), @IsSeaFood bit, @DefaultPrice money, @Active bit = 1, @MealID int OUTPUT)
AS BEGIN
    INSERT INTO Meals([Name], SeaFood, DefaultPrice, Active)
    VALUES(@Name, @IsSeaFood, @DefaultPrice, @Active)
    
    SET @MealID = @@IDENTITY
END
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
--<


--> Procedury
--# UpdateMealDefaultPrice(MealID, DefaultPrice)
--- Zmienia domyślną cenę posiłku.
CREATE OR ALTER PROCEDURE UpdateMealDefaultPrice(@MealID int, @DefaultPrice money)
AS BEGIN
    UPDATE Meals
    SET DefaultPrice = @DefaultPrice
    WHERE MealID = @MealID
END
GO
--<
