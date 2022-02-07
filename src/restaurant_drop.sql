-- foreign keys
ALTER TABLE CompanyCustomers DROP CONSTRAINT Customers_CompanyCustomers;

ALTER TABLE PrivateCustomers DROP CONSTRAINT Customers_PrivateCustomers;

ALTER TABLE Invoices DROP CONSTRAINT Invoices_Customers;

ALTER TABLE Orders DROP CONSTRAINT Invoices_Orders;

ALTER TABLE MenuItems DROP CONSTRAINT MenuItems_Meals;

ALTER TABLE OrderDetails DROP CONSTRAINT MenuItems_OrderDetails;

ALTER TABLE MenuItems DROP CONSTRAINT Menu_MenuItems;

ALTER TABLE Orders DROP CONSTRAINT Order_Reservations;

ALTER TABLE OrderDiscounts DROP CONSTRAINT OrdersDiscounts_Orders;

ALTER TABLE Orders DROP CONSTRAINT Orders_Customers;

ALTER TABLE OrderDetails DROP CONSTRAINT Orders_OrderDetails;

ALTER TABLE Reservations DROP CONSTRAINT Reservations_Customers;

ALTER TABLE TableDetails DROP CONSTRAINT Reservations_TableDetails;

ALTER TABLE TableDetails DROP CONSTRAINT TableDetails_Tables;

-- tables
DROP TABLE CompanyCustomers;

DROP TABLE Constants;

DROP TABLE Customers;

DROP TABLE Invoices;

DROP TABLE Meals;

DROP TABLE Menu;

DROP TABLE MenuItems;

DROP TABLE OrderDetails;

DROP TABLE OrderDiscounts;

DROP TABLE Orders;

DROP TABLE PrivateCustomers;

DROP TABLE Reservations;

DROP TABLE TableDetails;

DROP TABLE Tables;

-- End of file.

