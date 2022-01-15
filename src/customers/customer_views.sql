--> Widoki
--# CustomerNames
--- Zwraca CustomerID razem z nazwą firmy lub imieniem i nazwiskiem, zależnie od klienta.
CREATE OR ALTER VIEW CustomerNames
AS SELECT Customers.CustomerID, ISNULL(CompanyName, FirstName + ' ' + LastName) AS [Name]
FROM Customers
LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Customers.CustomerID
LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Customers.CustomerID
GO
--<