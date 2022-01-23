DROP ROLE manager;
--> Uprawnienia
--# Manager
--- Aplikacja managera restauracji może wykonywać dowolne operacje SELECT w celu pobierania danych.
--- Posiada również dostęp do procedur, funkcji i widoków, które związane są z zarządziem
--- restauracją. Umożliwiają one bezpieczne i niepowodujące błędów tworzenie menu oraz zmianę zasad rabatów
--- przyznawanych w restauracji. Pozwalają także na generowanie raportów związanych z działaniem restauracji
--- oraz na wystawianie faktur.
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
--- Aplikacja przeznaczona dla obsługi może wykonywać dowolne operacje SELECT w celu pobierania potrzebnych danych.
--- Ponadto ma dostęp do odpowiednio przygotowanych procedur, które w bezpieczny sposób przeprowadzają operacje
--- związane z bieżącą obsługą restauracji, czyli składaniem i wydawaniem zamówień i rezerwacjami stolików.
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
--- Aplikacja klienta ma dostęp do wybranych procedur umożliwiających składanie zamówień i rezerwacji online,
--- generowanie faktur oraz raportów na temat własnych zamówień. Nie ma natomiast możliwości wykonywania
--- własnych operacji SELECT. Wszystkie dane odczytywane z bazy muszą zostać wyciągnięte poprzez odpowiednio
--- przygotowane funkcje i widoki.
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