DECLARE @ProgressMenu int
EXECUTE NewMenuInProgress
    @StartDate = '2022-03-01',
    @EndDate = '2022-03-09',
    @MenuID = @ProgressMenu OUTPUT;

EXECUTE SetMenuItem
    @MenuID = @ProgressMenu,
    @MealID = 3; -- Kawa

EXECUTE ActivateMenu
    @MenuId = @ProgressMenu;

GO

DECLARE @ProgressMenu int
EXECUTE NewMenuInProgress
    @StartDate = '2022-03-01',
    @EndDate = '2022-03-19',
    @MenuID = @ProgressMenu OUTPUT;

EXECUTE SetMenuItem
    @MenuID = @ProgressMenu,
    @MealID = 3; -- Kawa

---- BEZ TYCH NIE POWINNO DZIAŁAĆ
EXECUTE ChangeMenuDates
    @MenuID = @ProgressMenu,
    @StartDate = '2022-03-10';

EXECUTE SetMenuItem
    @MenuID = @ProgressMenu,
    @MealID = 4, -- Herbata
    @Price = 100;
----

EXECUTE ActivateMenu
    @MenuId = @ProgressMenu;

GO

-- Error: Menu is active
-- EXECUTE RemoveMenuItem
--     @MenuID = 1,
--     @MealID = 2;

GO

SELECT * FROM Menu
SELECT * FROM MenuItems
WHERE MenuID = (SELECT MAX(MenuID) FROM Menu)
UNION
SELECT * FROM MenuItems
WHERE MenuID = (SELECT MAX(MenuID) FROM Menu) - 1

GO

DELETE MenuItems
WHERE MenuID IN (SELECT MenuID FROM Menu WHERE Active = 0)

DELETE Menu
WHERE Active = 0

DELETE MenuItems
WHERE MenuID IN (SELECT MenuID FROM Menu WHERE MenuId > 3)

DELETE Menu
WHERE Menu.MenuID > 3