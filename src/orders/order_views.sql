--> Widoki
--# CurrentOrders
--- Pokazuje zamówienia w trakcie realizacji.
CREATE OR ALTER VIEW CurrentOrders
AS SELECT 
        OrderID, 
        CustomerID, 
        ReservationID, 
        Paid, InvoiceID 
    FROM 
        Orders
    WHERE 
        OrderDate <= GETDATE()
        AND GETDATE() < CompletionDate
GO
--<

--> Widoki
--# OrderHist
--- Pokazuje historię zamówień.
CREATE OR ALTER VIEW OrderHist
AS SELECT 
        OrderID, 
        CustomerID, 
        ReservationID, 
        Paid, InvoiceID 
    FROM 
        Orders 
    WHERE 
        CompletionDate <= GETDATE()
GO
--<


--> Widoki
--# SeafoodOrders
--- Pokazuje zamówienia, które zawierają dania z owocami morza.
CREATE OR ALTER VIEW SeafoodOrders
AS SELECT 
        O.OrderID,
        M.MealID,
        MI.MenuID,
        OD.Quantity,
        O.CustomerID,
        O.ReservationID,
        O.OrderDate,
        O.CompletionDate,
        O.Paid,
        O.InvoiceID
    FROM 
        Orders O
        INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
        INNER JOIN MenuItems MI ON OD.MenuID = MI.MenuID AND OD.MealID = MI.MealID
        INNER JOIN Meals M ON M.MealID = MI.MealID
    WHERE 
        SeaFood = 1
GO
--<


--> Widoki
--# CalculatedOrders
--- Pokazuje wszystkie zamówienia wraz z kwotami.
CREATE OR ALTER VIEW CalculatedOrders
AS SELECT
        OrderID,
        CustomerID,
        ReservationID,
        InvoiceID,
        OrderDate,
        CompletionDate,
        (CASE
            WHEN Canceled = 1 THEN 'anulowane'
            WHEN (Paid = 1 AND Completed = 0) THEN 'oplacone przed realizacja'
            WHEN (Paid = 0 AND Completed = 1) THEN 'zrealizowane, do zaplaty'
            WHEN (Paid = 1 AND Completed = 1) THEN 'zrealizowane i oplacone'
            ELSE 'przyjete'
        END
        ) Status,
        dbo.TotalOrderAmount(OrderID) TotalAmount
    FROM 
        Orders
GO
--<

--> Widoki
--# OrdersToCompleteToday
--- Pokazuje wszystkie zamówienia na dzisiaj, które jeszcze nie zostały zrealizowane.
CREATE OR ALTER VIEW OrdersToCompleteToday
AS SELECT
        CustomerID,
        OrderID,
        CompletionDate,
        dbo.TotalOrderAmount(OrderID) TotalAmount
    FROM 
        Orders
    WHERE
        DATEDIFF(day, CompletionDate, GETDATE()) = 0
        AND Completed = 0 
        AND Canceled = 0
GO
--<


--> Widoki
--# CurrentWeekSeaFoodOrders
--- Pokazuje zamówienia z owocami morza do realizacji w aktualnym tygodniu
CREATE OR ALTER VIEW CurrentWeekSeaFoodOrders
AS SELECT 
        o.CustomerID,
        o.OrderID,
        o.CompletionDate,
        dbo.TotalOrderAmount(o.OrderID) TotalAmount
    FROM
        Orders o
        INNER JOIN OrderDetails od ON od.OrderID = o.OrderID
        INNER JOIN Meals m ON m.MealID = od.MealID
    WHERE
        m.SeaFood = 1 
        AND o.CompletionDate > GETDATE()
        AND DATEDIFF(day, o.CompletionDate, GETDATE()) < 7
        AND Canceled = 0
GO
--<