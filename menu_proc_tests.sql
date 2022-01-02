DELETE MenuItems
WHERE MenuID IN (SELECT MenuID FROM Menu WHERE MenuId > 3)

DELETE Menu
WHERE Menu.MenuID > 3

GO

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
    @EndDate = '2022-03-09',
    @MenuID = @ProgressMenu OUTPUT;

EXECUTE SetMenuItem
    @MenuID = @ProgressMenu,
    @MealID = 3; -- Kawa

EXECUTE ActivateMenu
    @MenuId = @ProgressMenu;

GO

DELETE MenuItems
WHERE MenuID IN (SELECT MenuID FROM Menu WHERE Active = 0)

DELETE Menu
WHERE Active = 0

SELECT * FROM Menu