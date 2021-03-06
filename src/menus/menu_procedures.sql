--> Procedury
--# NewMenuInProgress(StartDate, EndData, MenuID OUTPUT)
--- Tworzy nowe nieaktywne menu.
CREATE OR ALTER PROCEDURE NewMenuInProgress(@StartDate datetime, @EndDate datetime, @MenuID int OUTPUT)
AS BEGIN
    INSERT INTO Menu(StartDate, EndDate, Active)
    VALUES(@StartDate, @EndDate, 0)
    
    SET @MenuID = @@IDENTITY
END
GO
--<


--> Procedury
--# ChangeMenuDates(MenuID, StartDate, EndDate)
--- Zmienia datę obowiązywania nieaktywnego menu
CREATE OR ALTER PROCEDURE ChangeMenuDates(@MenuID int, @StartDate datetime = NULL, @EndDate datetime = NULL)
AS BEGIN
    IF (SELECT Active FROM Menu WHERE MenuID = @MenuID) = 1 BEGIN
        ;THROW 52000, 'Menu is active', 1
        RETURN
    END 

    DECLARE @PrevStartDate datetime
    DECLARE @PrevEndDate datetime

    SELECT @PrevStartDate = StartDate, @PrevEndDate = EndDate 
    FROM Menu WHERE MenuID = @MenuID

    UPDATE Menu
    SET StartDate = ISNULL(@StartDate, @PrevStartDate),
        EndDate = ISNULL(@EndDate, @PrevEndDate)
    WHERE MenuID = @MenuID
END
GO
--<


--> Procedury
--# SetMenuItem(MenuID, MealID, Price)
--- Dodaje posiłek do nieaktywnego menu.
CREATE OR ALTER PROCEDURE SetMenuItem(@MenuID int, @MealID int, @Price money = NULL)
AS BEGIN
    IF (SELECT Active FROM Menu WHERE MenuID = @MenuID) = 1 BEGIN
        ;THROW 52000, 'Menu is active', 1
        RETURN
    END 

    IF (SELECT Active FROM Meals WHERE MealID = @MealID) = 0 BEGIN
        ;THROW 52000, 'Meal is not active', 1
        RETURN
    END 

    DECLARE @DefaultPrice money = (SELECT DefaultPrice FROM Meals WHERE MealID = @MealID)

    INSERT INTO MenuItems(MenuID, MealID, Price)
    VALUES (@MenuID, @MealID, ISNULL(@Price, @DefaultPrice))
END
GO
--<


--> Procedury
--# RemoveMenuItem(MenuID, MealID)
--- Usuwa posiłek z nieaktynego menu.
CREATE OR ALTER PROCEDURE RemoveMenuItem(@MenuID int, @MealID int)
AS BEGIN
    IF (SELECT Active FROM Menu WHERE MenuID = @MenuID) = 1 BEGIN
        ;THROW 52000, 'Menu is active', 1
        RETURN
    END

    DELETE MenuItems
    WHERE MenuID = @MenuID AND MealID = @MealID
END
GO
--<


--> Procedury
--# ActivateMenu(MenuID)
--- Próbuje aktywować menu, biorąc pod uwagę niepowtarzanie się posiłków i nienachodzenie dat.
CREATE OR ALTER PROCEDURE ActivateMenu(@MenuID int)
AS BEGIN
    -- Check if not active
    IF (SELECT Active FROM Menu WHERE MenuID = @MenuID) = 1 BEGIN
        ;THROW 52000, 'Menu is active', 1
        RETURN
    END

    -- Check if dates do not overlap
    DECLARE @StartDate datetime = (SELECT StartDate FROM Menu WHERE MenuID = @MenuID)
    DECLARE @LastMenuDate datetime = (SELECT MAX(EndDate) FROM Menu WHERE Active = 1)
    
    if DATEDIFF(day, @LastMenuDate, @StartDate) <= 0 BEGIN
        ;THROW 52000, 'Overlapping dates', 1
        RETURN
    END

    -- Check if the menu items are legal
    DECLARE @Count int
    DECLARE @NotChangedCount int

    SELECT @Count = Count(MealID)
    FROM Menu
    JOIN MenuItems ON MenuItems.MenuID = Menu.MenuID
    WHERE Menu.MenuID = @MenuID

    SELECT @NotChangedCount = Count(MealID)
    FROM Menu 
    JOIN MenuItems ON MenuItems.MenuID = Menu.MenuID
    WHERE Menu.MenuID = @MenuID AND MenuItems.MealID IN (
        SELECT MI2.MealID
        FROM MenuItems AS MI2
        JOIN Menu AS M2 ON M2.MenuID = MI2.MenuID
        WHERE M2.Active = 1 AND DATEDIFF(day, M2.EndDate, Menu.StartDate) < 14
    )

    IF (@NotChangedCount * 2) > @Count BEGIN
        ;THROW 52000, 'Menu is not legal', 1
        RETURN
    END

    -- Everything is correct
    UPDATE Menu SET Active = 1
    WHERE MenuID = @MenuID

END
GO
--<

--> Procedury
--# DeactivateMenu(MenuID)
--- Dezaktywuje menu.
CREATE OR ALTER PROCEDURE DeactivateMenu(@MenuID int)
AS BEGIN
    UPDATE Menu SET Active = 0
    WHERE MenuID = @MenuID
END
GO
--<