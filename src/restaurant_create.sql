--> Tabele
--# CompanyCustomers
--- Przechowuje informacje o firmach: numer firmy, nazwa firmy, (opcjonalny) NIP.
CREATE TABLE CompanyCustomers (
    CustomerID int  NOT NULL,
    CompanyName nvarchar(64) NULL,
    NIP varchar(16)  NULL,
    CONSTRAINT CompanyCustomers_pk PRIMARY KEY (CustomerID)
);
--<

--> Tabele
--# Constants
--- Zawiera informacje o wartościach stałych potrzebnych do wyznaczenia rabatów w danym okresie: 
--- Z1 - minimalna liczba zamówień dla rabatu 1,  
--- K1 - minimalna wydana kwota dla rabatu 1, 
--- R1 - procent zniżki na wszystkie zamówienia po udzieleniu rabatu 1, 
--- K2 - minimalna wydana kwota dla rabatu 2, 
--- R2 - procent zniżki na zamówienie po udzieleniu rabatu 2, 
--- D1 - maksymalna liczba dni na wykorzystanie rabatu 2 począwszy od dnia przyznania zniżki, 
--- WZ - minimalna wartość zamówienia w przypadku wypełniania formularza do rezerwacji, 
--- WK - minimalna ilość wykonanych zamówień w przypadku wypełniania formularza do rezerwacji.
CREATE TABLE Constants (
    Date datetime  NOT NULL,
    Z1 int  NOT NULL,
    K1 int  NOT NULL,
    R1 int  NOT NULL,
    K2 int  NOT NULL,
    R2 int  NOT NULL,
    D1 int  NOT NULL,
    WZ int  NOT NULL,
    WK int  NOT NULL,
    CONSTRAINT ConstantChecks CHECK (Z1 >= 0 AND  K1 >= 0 AND  R1 >= 0 AND R1 <= 100 AND K2 >= 0 AND R2 >= 0 AND R2 <= 100 AND D1 >= 0 AND WZ >= 0 AND WK >= 0 ),
    CONSTRAINT Constants_pk PRIMARY KEY  (Date)
);
--<

--> Tabele
--# Customers
--- Przechowuje informacje wspólne o klientach indywidualnych i firmach. Informacje adresowe są opcjonalne (w przypadku kiedy są potrzebne, można je uzupełnić później).
CREATE TABLE Customers (
    CustomerID int  NOT NULL IDENTITY(1, 1),
    Email nvarchar(64)  NULL,
    Phone varchar(16)  NULL,
    Address nvarchar(64)  NULL,
    City nvarchar(64)  NULL,
    PostalCode varchar(16)  NULL,
    Country nvarchar(64)  NULL,
    CONSTRAINT Customers_pk PRIMARY KEY  (CustomerID)
);
--<

--> Tabele
--# Invoices
--- Zawiera informacje o fakturach: numer faktury, data wystawienia faktury, łączna kwota oraz dane klienta.
CREATE TABLE Invoices (
    InvoiceID varchar(16)  NOT NULL,
    CustomerID int NOT NULL,
    Date datetime  NOT NULL,
    TotalAmount money  NOT NULL,
    FirstName nvarchar(64)  NULL,
    LastName nvarchar(64)  NULL,
    CompanyName nvarchar(64)  NULL,
    Email nvarchar(64)  NULL,
    Phone varchar(16)  NULL,
    Address nvarchar(64) NOT NULL,
    City nvarchar(64) NOT NULL,
    PostalCode varchar(16) NOT NULL,
    Country nvarchar(64) NOT NULL,
    CONSTRAINT PositiveTotalAmount CHECK (TotalAmount > 0),
    CONSTRAINT Invoices_pk PRIMARY KEY  (InvoiceID)
);
--<

--> Tabele
--# Meals
--- Lista dań możliwych do użycia podczas tworzenia menu. Zawiera informację o domyślnej cenie oraz oznaczenie dań z owocami morza.
CREATE TABLE Meals (
    MealID int  NOT NULL IDENTITY(1, 1),
    Name nvarchar(64)  NOT NULL,
    SeaFood bit  NOT NULL,
    DefaultPrice money  NOT NULL,
    Active bit  NOT NULL,
    CONSTRAINT PositiveDefaultPrice CHECK (DefaultPrice > 0),
    CONSTRAINT Meals_pk PRIMARY KEY  (MealID)
);
--<

--> Tabele
--# Menu
--- Przechowuje informacje o menu dostępnych w różnych okresach.
CREATE TABLE Menu (
    MenuID int  NOT NULL IDENTITY(1, 1),
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Active bit  NOT NULL,
    CONSTRAINT MenuStartBeforeEnd CHECK (StartDate < EndDate),
    CONSTRAINT Menu_pk PRIMARY KEY  (MenuID)
);
--<

--> Tabele
--# MenuItems
--- Zawiera wszystkie posiłki dostępne w co najmniej jednym z menu wraz z ich cenami.
CREATE TABLE MenuItems (
    MenuID int  NOT NULL,
    MealID int  NOT NULL,
    Price money  NOT NULL,
    CONSTRAINT PositivePrice CHECK (Price > 0),
    CONSTRAINT MenuItems_pk PRIMARY KEY  (MenuID,MealID)
);
--<

--> Tabele
--# OrderDetails
--- Zawiera wszystkie pozycje ze wszystkich złożonych zamówień. Każda pozycja jest przypisana do dokładnie jednego zamówienia i może obejmować kilka sztuk tego samego produktu.
CREATE TABLE OrderDetails (
    OrderID int  NOT NULL,
    Quantity int  NOT NULL,
    MealID int  NOT NULL,
    MenuID int  NOT NULL,
    CONSTRAINT PositiveQuantity CHECK (Quantity > 0),
    CONSTRAINT OrderDetails_pk PRIMARY KEY  (OrderID, MealID)
);
--<

--> Tabele
--# OrderDiscounts
--- Zawiera listę udzielonych rabatów. Każdy rabat jest przypisany do dokładnie jednego zamówienia.
CREATE TABLE OrderDiscounts (
    OrderID int  NOT NULL,
    Discount decimal(5,2)  NOT NULL,
    DiscountType int  NOT NULL CHECK (DiscountType IN (1, 2)),
    CONSTRAINT DiscountRange CHECK (Discount >= 0 AND Discount <= 1),
    CONSTRAINT OrderDiscounts_pk PRIMARY KEY  (OrderID,DiscountType)
);
--<

--> Tabele
--# Orders
--- Lista złożonych zamówień wraz z informacją o ich statusie.
CREATE TABLE Orders (
    OrderID int  NOT NULL IDENTITY(1, 1),
    CustomerID int  NOT NULL,
    ReservationID int  NULL,
    OrderDate datetime  NOT NULL,
    CompletionDate datetime  NULL,
    Paid bit  NOT NULL,
    Canceled bit NOT NULL,
    Completed bit NOT NULL,
    InvoiceID varchar(16)  NULL,
    CONSTRAINT OrderedBeforeCompleted CHECK (CompletionDate >= OrderDate),
    CONSTRAINT Orders_pk PRIMARY KEY  (OrderID)
);
--<


--> Tabele
--# PrivateCustomers
--- Przechowuje informacje o klientach indywidualnych: imię i nazwisko
CREATE TABLE PrivateCustomers (
    CustomerID int  NOT NULL,
    FirstName nvarchar(64)  NULL,
    LastName nvarchar(64)  NULL,
    CONSTRAINT PrivateCustomers_pk PRIMARY KEY  (CustomerID)
);
--<

--> Tabele
--# Reservations
--- Przechowuje listę rezerwacji stolików.
CREATE TABLE Reservations (
    ReservationID int  NOT NULL IDENTITY(1, 1),
    StartDate datetime  NOT NULL,
    EndDate datetime  NOT NULL,
    Accepted bit  NOT NULL,
    CustomerID int  NOT NULL,
    Guests nvarchar(max)  NULL,
    Canceled bit  NOT NULL,
    CONSTRAINT ReservationStartBeforeEnd CHECK (StartDate < EndDate),
    CONSTRAINT Reservations_pk PRIMARY KEY  (ReservationID)
);
--<

--> Tabele
--# TableDetails
--- Zawiera szczegóły rezerwacji poszczególnych stolików (przypisanie stolika do rezerwacji)
CREATE TABLE TableDetails (
    TableID int  NOT NULL,
    ReservationID int  NOT NULL,
    CONSTRAINT TableDetails_pk PRIMARY KEY  (TableID,ReservationID)
);
--<

--> Tabele
--# Tables
--- Lista stolików dostępnych w restauracji.
CREATE TABLE Tables (
    TableID int  NOT NULL IDENTITY(1, 1),
    Seats int  NOT NULL,
    Active bit  NOT NULL,
    CONSTRAINT PositiveSeats CHECK (Seats > 0),
    CONSTRAINT Tables_pk PRIMARY KEY  (TableID)
);
--<

--> Tabele
--# Tables
---
ALTER TABLE CompanyCustomers ADD CONSTRAINT Customers_CompanyCustomers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
--<

--> Tabele
--# Tables
---
ALTER TABLE PrivateCustomers ADD CONSTRAINT Customers_PrivateCustomers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
--<

--> Tabele
--# Tables
---
ALTER TABLE Orders ADD CONSTRAINT Invoices_Orders
    FOREIGN KEY (InvoiceID)
    REFERENCES Invoices (InvoiceID);
--<

--> Tabele
--# MenuItems
---
ALTER TABLE MenuItems ADD CONSTRAINT MenuItems_Meals
    FOREIGN KEY (MealID)
    REFERENCES Meals (MealID);
--<

--> Tabele
--# OrderDetails
---
ALTER TABLE OrderDetails ADD CONSTRAINT MenuItems_OrderDetails
    FOREIGN KEY (MenuID,MealID)
    REFERENCES MenuItems (MenuID,MealID);
--<

--> Tabele
--# MenuItems
---
ALTER TABLE MenuItems ADD CONSTRAINT Menu_MenuItems
    FOREIGN KEY (MenuID)
    REFERENCES Menu (MenuID);
--<

--> Tabele
--# Orders
---
ALTER TABLE Orders ADD CONSTRAINT Order_Reservations
    FOREIGN KEY (ReservationID)
    REFERENCES Reservations (ReservationID);
--<

--> Tabele
--# OrderDiscounts
---
ALTER TABLE OrderDiscounts ADD CONSTRAINT OrdersDiscounts_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);
--<

--> Tabele
--# Orders
---
ALTER TABLE Orders ADD CONSTRAINT Orders_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
--<

--> Tabele
--# OrderDetails
---
ALTER TABLE OrderDetails ADD CONSTRAINT Orders_OrderDetails
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);
--<

--> Tabele
--# Reservations
---
ALTER TABLE Reservations ADD CONSTRAINT Reservations_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
--<

--> Tabele
--# Invoices
---
ALTER TABLE Invoices ADD CONSTRAINT Invoices_Customers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID);
--<

--> Tabele
--# TableDetails
---
ALTER TABLE TableDetails ADD CONSTRAINT Reservations_TableDetails
    FOREIGN KEY (ReservationID)
    REFERENCES Reservations (ReservationID);
--<

--> Tabele
--# TableDetails
---
ALTER TABLE TableDetails ADD CONSTRAINT TableDetails_Tables
    FOREIGN KEY (TableID)
    REFERENCES Tables (TableID);
--<
