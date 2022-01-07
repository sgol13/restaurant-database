DROP PROCEDURE AddCompanyCustomer
GO

--> Procedury
--# AddCompanyCustomer(...)
--- Dodaje firmę jako klienta.
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
    BEGIN TRANSACTION;
        INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
        VALUES (@Email, @Phone, @Address, @City, @PostalCode, @Country)
        INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
        VALUES (@@IDENTITY, @CompanyName, @NIP)
    COMMIT;
END
GO
--<

DROP PROCEDURE AddPrivateCustomer
GO

--> Procedury
--# AddPrivateCustomer(...)
--- Dodaje osobę prywatną jako klienta.
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
    BEGIN TRANSACTION;
        INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
        VALUES (@Email, @Phone, @Address, @City, @PostalCode, @Country)
        INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
        VALUES (@@IDENTITY, @FirstName, @LastName)
    COMMIT;
END
GO
--<