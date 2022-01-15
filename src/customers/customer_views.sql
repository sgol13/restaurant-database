--> Widoki
--# CustomersFullNames
--- Zwraca CustomerID razem z nazwą firmy lub imieniem i nazwiskiem, zależnie od typu klienta. Podaje także dane adresowe.
CREATE OR ALTER VIEW CustomersFullNames
AS SELECT 
    Customers.CustomerID, ISNULL(CompanyName, FirstName + ' ' + LastName) AS [Name],
    Email, Phone, Address, City, PostalCode, Country
FROM Customers
    LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Customers.CustomerID
    LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Customers.CustomerID
WHERE
    Email IS NOT NULL
GO
--<