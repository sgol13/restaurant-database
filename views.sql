create view CurrentOrders
as select * from Orders
where OrderDate <= getdate() and  getdate() < CompletionDate

create view OrderHist
as select * from Orders where CompletionDate <= getdate()

create view ReservationsToAccept
as select * from Reservations where Accepted = 0

create view SeafoodOrders
as select *
    from Orders O
    inner join OrderDetails OD on O.OrderID = OD.OrderID
    inner join MenuItems MI on OD.MenuID = MI.MenuID and OD.MealID = MI.MealID
    inner join Meals M on M.MealID = MI.MealID
where SeaFood = 1