DROP ROLE manager;
--> Uprawnienia
--# Manager
--- Może wykonywać dowolne operacje SELECT oraz korzystać z przygotowanych procedur, funkcji i widoków.
CREATE ROLE manager;

GRANT SELECT ON SCHEMA::dbo TO manager;

-- procedures
GRANT EXEC ON dbo.CreateNewMeal TO manager;
GRANT EXEC ON dbo.SetMealActive TO manager;
GRANT EXEC ON dbo.UpdateMealDefaultPrice TO manager;
GRANT EXEC ON dbo.NewMenuInProgress TO manager;
GRANT EXEC ON dbo.ChangeMenuDates TO manager;
GRANT EXEC ON dbo.SetMenuItem TO manager;
GRANT EXEC ON dbo.RemoveMenuItem TO manager;
GRANT EXEC ON dbo.ActivateMenu TO manager;
GRANT EXEC ON dbo.DeactivateMenu TO manager;
GRANT EXEC ON dbo.CreateNewMeal TO manager;
GRANT EXEC ON dbo.CreateOrderInvoice TO manager;
GRANT EXEC ON dbo.CreateMonthlyInvoice TO manager;
GRANT EXEC ON dbo.AddTable TO manager;
GRANT EXEC ON dbo.EnableTable TO manager;
GRANT EXEC ON dbo.DisableTable TO manager;
GRANT EXEC ON dbo.UpdateConstants TO manager;

-- functions
GRANT SELECT ON dbo.GetMenuForDay TO manager;
GRANT SELECT ON dbo.MealsStatistics TO manager;
GRANT SELECT ON dbo.CustomerStatistics TO manager;
GRANT SELECT ON dbo.OrdersStatistics TO manager;
GRANT SELECT ON dbo.TablesStatistics TO manager;
GRANT SELECT ON dbo.DiscountsStatistics TO manager;

-- views
GRANT SELECT ON dbo.CurrentMenu TO manager;
GRANT SELECT ON dbo.GetMenuOrders TO manager;
GRANT SELECT ON dbo.CurrentConstants TO manager;
GRANT SELECT ON dbo.CustomersFullNames TO manager;
--<

DROP ROLE staff;
--> Uprawnienia
--# Staff
--- Może wykonywać dowolne operacje SELECT oraz korzystać z przygotowanych procedur, funkcji i widoków.
CREATE ROLE staff;

GRANT SELECT ON SCHEMA::dbo TO staff;

-- procedures
GRANT EXEC ON dbo.CreateOrder TO staff;
GRANT EXEC ON dbo.CreateInstantOrder TO staff;
GRANT EXEC ON dbo.CancelOrder TO staff;
GRANT EXEC ON dbo.PayForOrder TO staff;
GRANT EXEC ON dbo.CompleteOrder TO staff;
GRANT EXEC ON dbo.CreateOrderInvoice TO staff;
GRANT EXEC ON dbo.CreateMonthlyInvoice TO staff;
GRANT EXEC ON dbo.AddReservation TO staff;
GRANT EXEC ON dbo.AddInstantReservation TO staff;
GRANT EXEC ON dbo.FinishCurrentReservation TO staff;
GRANT EXEC ON dbo.ExtendCurrentReservation TO staff;
GRANT EXEC ON dbo.CancelReservation TO staff;
GRANT EXEC ON dbo.AcceptReservation TO staff;
GRANT EXEC ON dbo.AddPrivateCustomer TO staff;
GRANT EXEC ON dbo.AddCompanyCustomer TO staff;
GRANT EXEC ON dbo.UpdatePrivateCustomer TO staff;
GRANT EXEC ON dbo.UpdateCompanyCustomer TO staff;
GRANT EXEC ON dbo.ForgetCustomer TO staff;

-- functions
GRANT SELECT ON dbo.GetMenuForDay TO staff;
GRANT SELECT ON dbo.CustomerOrders TO staff;
GRANT SELECT ON dbo.GetOrderDetails TO staff;
GRANT SELECT ON dbo.GetCustomersReservations TO staff;
GRANT SELECT ON dbo.SingleReservationDetails TO staff;
GRANT SELECT ON dbo.TablesAvailableToReserve TO staff;

-- views
GRANT SELECT ON dbo.CurrentMenu TO staff;
GRANT SELECT ON dbo.OrdersToCompleteToday TO staff;
GRANT SELECT ON dbo.CurrentWeekSeaFoodOrders TO staff;
GRANT SELECT ON dbo.CalculatedOrders TO staff;
GRANT SELECT ON dbo.CurrentTables TO staff;
GRANT SELECT ON dbo.TodayReservations TO staff;
GRANT SELECT ON dbo.ReservationsToAccept TO staff;
GRANT SELECT ON dbo.ReservationsDetails TO staff;
GRANT SELECT ON dbo.CustomersFullNames TO staff;
GRANT SELECT ON dbo.CurrentConstants TO staff;
--<

DROP ROLE customer;
--> Uprawnienia
--# Customer
--- Może korzystać wyłącznie z przygotowanych procedur, funkcji i widoków.
CREATE ROLE customer;

-- procedures
GRANT EXEC ON dbo.CreateOrder TO customer;
GRANT EXEC ON dbo.CancelOrder TO customer;
GRANT EXEC ON dbo.PayForOrder TO customer;
GRANT EXEC ON dbo.CreateOrderInvoice TO customer;
GRANT EXEC ON dbo.CreateMonthlyInvoice TO customer;
GRANT EXEC ON dbo.PrivateOnlineReservation TO customer;
GRANT EXEC ON dbo.CompanyOnlineReservation TO customer;
GRANT EXEC ON dbo.CancelReservation TO customer;
GRANT EXEC ON dbo.AddPrivateCustomer TO customer;
GRANT EXEC ON dbo.AddCompanyCustomer TO customer;
GRANT EXEC ON dbo.UpdatePrivateCustomer TO customer;
GRANT EXEC ON dbo.UpdateCompanyCustomer TO customer;

-- functions
GRANT SELECT ON dbo.GetMenuForDay TO customer;
GRANT SELECT ON dbo.CustomerOrders TO customer;
GRANT SELECT ON dbo.GetOrderDetails TO customer;
GRANT SELECT ON dbo.GetCustomersReservations TO customer;
GRANT SELECT ON dbo.SingleReservationDetails TO customer;
GRANT SELECT ON dbo.TablesAvailableToReserve TO customer;
GRANT SELECT ON dbo.CustomerStatistics TO customer;

-- views
GRANT SELECT ON dbo.CurrentMenu TO customer;
GRANT SELECT ON dbo.CurrentConstants TO customer;
--<