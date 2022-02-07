--> Indeksy
--# CompanyCustomersIndex
--- Indeks wykorzystujący nazwę firmy.
CREATE INDEX CompanyCustomersIndex ON CompanyCustomers(CompanyName);
GO
--<

--> Indeksy
--# PrivateCustomersIndex
--- Indeks wykorzystujący imię i nazwisko klienta.
CREATE INDEX PrivateCustomersIndex ON PrivateCustomers(FirstName, LastName);
GO
--<