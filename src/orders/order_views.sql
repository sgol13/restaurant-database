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