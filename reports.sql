--> Funkcje
--# MealsStatistics(Monthly, Date)
--- Raport dotyczący posiłków, pokazujący ile razy został zamówiony i ile na niego wydano. Jeśli Monthly jest ustawione na 1, raport jest miesięczny, a w przeciwnym wypadku jest tygodniowy.
CREATE OR ALTER FUNCTION MealsStatistics(
    @Monthly bit,
    @Date datetime
)RETURNS @Statistics TABLE ([Name] nvarchar(64), Quantity int, [TotalAmount] money)
BEGIN
    DECLARE @EndDate datetime = CASE @Monthly
        WHEN 0 THEN DATEADD(week, -1, @Date)
        ELSE DATEADD(month, -1, @Date)
    END

    INSERT @Statistics
        SELECT [Name], ISNULL(Sum(OD.Quantity), 0), ISNULL(Sum(OD.Quantity * MI.Price), 0)
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
--# CustomerStatistics(CustomerID)
--- Raport dotyczący danego klienta, wyświetla dla każdego zamówienia końcowa cenę, czas w którym zamówienie spłyneło i datę na które jest to zamówienie.
CREATE OR ALTER FUNCTION CustomerStatistics(
    @CustomerID int
)RETURNS @Statistics TABLE(Amount money, OrderDate datetime, CompletionDate datetime)
BEGIN
    INSERT @Statistics
    SELECT dbo.TotalOrderAmount(OrderID), OrderDate, CompletionDate
    FROM Orders
    WHERE CustomerID = @CustomerID
    RETURN
END
GO
--<


--> Funkcje
--# OrderStatistics(CustomerID)
--- Raport dotyczący zamówień, wyświetla dla każdego zamówienia końcowa cenę, czas w którym zamówienie spłyneło i datę na które jest to zamówienie, a także nazwę klienta (imię i nazwisko w przypadku klienta indywidualnego). 
CREATE OR ALTER FUNCTION OrderStatistics()
RETURNS @Statistics TABLE(Amount money, OrderDate datetime, CompletionDate datetime, Who nvarchar(64))
BEGIN
    INSERT @Statistics
    SELECT dbo.TotalOrderAmount(OrderID), OrderDate, CompletionDate, ISNULL(CompanyCustomers.CompanyName, PrivateCustomers.FirstName + ' ' + PrivateCustomers.LastName)
    FROM Orders
    LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Orders.CustomerID
    LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Orders.CustomerID
    RETURN
END
GO
--<

