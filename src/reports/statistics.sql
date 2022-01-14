--> Funkcje
--# MealsStatistics(Monthly, Date)
--- Raport dotyczący posiłków, pokazujący ile razy został zamówiony i ile na niego wydano. Jeśli Monthly jest ustawione na 1, raport jest miesięczny, a w przeciwnym wypadku jest tygodniowy.
CREATE OR ALTER FUNCTION MealsStatistics(
    @Monthly bit,
    @Date datetime
)RETURNS @Statistics TABLE ([Name] nvarchar(64), [Number] int, [TotalAmount] money)
BEGIN
    DECLARE @EndDate datetime = CASE @Monthly
        WHEN 0 THEN DATEADD(week, -1, @Date)
        ELSE DATEADD(month, -1, @Date)
    END

    INSERT @Statistics
        SELECT [Name], ISNULL(Sum(OD.Number), 0), ISNULL(Sum(OD.Number * MI.Price), 0)
        FROM Meals
        LEFT JOIN OrderDetails OD ON OD.MealID = Meals.MealID
        LEFT JOIN MenuItems MI ON MI.MealID = OD.MealID AND MI.MenuID = OD.MenuID
        LEFT JOIN Orders ON Orders.OrderID = OD.OrderID
        WHERE Orders.CompletionDate IS NULL OR Orders.CompletionDate BETWEEN @Date AND @EndDate
        GROUP BY Meals.MealID, Meals.Name
    
    RETURN
END
GO
--<

--> Funkcje
--# CustomerStatistics(CustomerID, Monthly, Date)
--- Raport dotyczący danego klienta, wyświetla dla każdego zamówienia końcowa cenę, czas w którym zamówienie spłyneło i datę na które jest to zamówienie. 
--- Jeśli Monthly jest ustawione na 1, raport jest miesięczny, a w przeciwnym wypadku jest tygodniowy.
CREATE OR ALTER FUNCTION CustomerStatistics(
    @CustomerID int,
    @Monthly bit,
    @Date datetime
)RETURNS @Statistics TABLE(Amount money, OrderDate datetime, CompletionDate datetime)
BEGIN
    DECLARE @EndDate datetime = CASE @Monthly
        WHEN 0 THEN DATEADD(week, -1, @Date)
        ELSE DATEADD(month, -1, @Date)
    END

    INSERT @Statistics
    SELECT dbo.TotalOrderAmount(OrderID), OrderDate, CompletionDate
    FROM Orders
    WHERE CustomerID = @CustomerID AND CompletionDate BETWEEN @Date AND @EndDate
    
    RETURN
END
GO
--<

--> Funkcje
--# OrderStatistics(Monthly, Date)
--- Raport dotyczący zamówień, wyświetla dla każdego zamówienia końcowa cenę, czas w którym zamówienie spłyneło i datę na które jest to zamówienie, 
--- a także nazwę klienta (imię i nazwisko w przypadku klienta indywidualnego). Jeśli Monthly jest ustawione na 1, raport jest miesięczny, a w przeciwnym wypadku jest tygodniowy.
CREATE OR ALTER FUNCTION OrderStatistics(
    @Monthly bit,
    @Date datetime
)RETURNS @Statistics TABLE(Amount money, OrderDate datetime, CompletionDate datetime, Who nvarchar(64))
BEGIN
    DECLARE @EndDate datetime = CASE @Monthly
        WHEN 0 THEN DATEADD(week, -1, @Date)
        ELSE DATEADD(month, -1, @Date)
    END

    INSERT @Statistics
    SELECT dbo.TotalOrderAmount(OrderID), OrderDate, CompletionDate, ISNULL(CompanyCustomers.CompanyName, PrivateCustomers.FirstName + ' ' + PrivateCustomers.LastName)
    FROM Orders
    LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Orders.CustomerID
    LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Orders.CustomerID
    WHERE CompletionDate BETWEEN @Date AND @EndDate
    
    RETURN
END
GO
--<

--> Funkcje
--# TableStatistics(Monthly, Date)
--- Raport dotyczący stolików, dla każdego pokazuje ilość miejsc, to czy jest aktywny a także ile razy został zarezerowany w danym okresie. 
--- Jeśli Monthly jest ustawione na 1, raport jest miesięczny, a w przeciwnym wypadku jest tygodniowy.
CREATE OR ALTER FUNCTION TableStatistics (
    @Monthly bit,
    @Date datetime
) RETURNS @Statistics TABLE(TableID int, Seats int, Active bit, TimesUsed int)
BEGIN
    DECLARE @EndDate datetime = CASE @Monthly
        WHEN 0 THEN DATEADD(week, -1, @Date)
        ELSE DATEADD(month, -1, @Date)
    END

    INSERT @Statistics
    SELECT Tables.TableID, Seats, Active, COUNT(Reservations.ReservationID)
    FROM Tables
    LEFT JOIN TableDetails ON Tables.TableID = TableDetails.TableID
    LEFT JOIN Reservations ON TableDetails.ReservationID = Reservations.ReservationID
    WHERE StartDate BETWEEN @Date AND @EndDate
    GROUP BY Tables.TableID, Seats, Active

    RETURN
END
GO
--<

--> Funkcje
--# DiscountsStatistics(Monthly, Date)
--- Raport dotyczący rabatów, zawiera typ rabatu, ilość w procentach, a także ile razy został wykorzystany w danym okresie. Jeśli Monthly jest ustawione na 1, raport jest miesięczny, a w przeciwnym wypadku jest tygodniowy.
CREATE OR ALTER FUNCTION DiscountsStatistics(
    @Monthly bit,
    @Date datetime
) RETURNS @Statistics TABLE(DiscountType int, Amount decimal(5,2), TimesUsed int)
BEGIN
    DECLARE @EndDate datetime = CASE @Monthly
        WHEN 0 THEN DATEADD(week, -1, @Date)
        ELSE DATEADD(month, -1, @Date)
    END

    INSERT @Statistics
    SELECT DiscountType, Discount, Count(*)
    FROM OrderDiscounts
    JOIN Orders ON OrderDiscounts.OrderID = Orders.OrderID
    WHERE Orders.CompletionDate BETWEEN @Date AND @EndDate
    GROUP BY DiscountType, Discount

    RETURN
END
GO
--<