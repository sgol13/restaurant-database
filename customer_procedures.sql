DROP PROCEDURE AddCompanyCustomer
GO

CREATE PROCEDURE AddCompanyCustomer(
    @Email nvarchar(64),
    @Phone nvarchar(16),
    @Address nvarchar(64),
    @City nvarchar(64),
    @PostalCode varchar(16),
    @Country nvarchar(64),
    @CompanyName nvarchar(64),
    @NIP varchar(16)
)
AS BEGIN
    INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
    VALUES (@Email, @Phone, @Address, @City, @PostalCode, @Country)
    INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
    VALUES (@@IDENTITY, @CompanyName, @NIP)
END
GO

DROP PROCEDURE AddPrivateCustomer
GO

CREATE PROCEDURE AddPrivateCustomer(
    @Email nvarchar(64),
    @Phone nvarchar(16),
    @Address nvarchar(64),
    @City nvarchar(64),
    @PostalCode varchar(16),
    @Country nvarchar(64),
    @FirstName nvarchar(64),
    @LastName nvarchar(64)
)
AS BEGIN
    INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
    VALUES (@Email, @Phone, @Address, @City, @PostalCode, @Country)
    INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
    VALUES (@@IDENTITY, @FirstName, @LastName)
END
GO