--> Procedury
--# AddCompanyCustomer(...)
--- Dodaje firmę jako klienta. Konieczne jest podanie e-maila oraz nazwy firmy.
--- Pozostałe dane mogą zostać uzupełnione później.
CREATE OR ALTER PROCEDURE AddCompanyCustomer(
    @Email nvarchar(64),
    @Phone nvarchar(16) = NULL,
    @Address nvarchar(64) = NULL,
    @City nvarchar(64) = NULL,
    @PostalCode varchar(16) = NULL,
    @Country nvarchar(64) = NULL,
    @CompanyName nvarchar(64),
    @NIP varchar(16) = NULL
)
AS BEGIN
    BEGIN TRY;
    BEGIN TRANSACTION;

        INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
        VALUES (@Email, @Phone, @Address, @City, @PostalCode, @Country)
        INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
        VALUES (@@IDENTITY, @CompanyName, @NIP)

        COMMIT;
    END TRY
    BEGIN CATCH;
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# AddPrivateCustomer(...)
--- Dodaje osobę prywatną jako klienta. Konieczne jest podanie imienia i nazwiska oraz e-maila.
--- Pozostałe dane mogą zostać uzupełnione później.
CREATE OR ALTER PROCEDURE AddPrivateCustomer(
    @Email nvarchar(64),
    @Phone nvarchar(16) = NULL,
    @Address nvarchar(64) = NULL,
    @City nvarchar(64) = NULL,
    @PostalCode varchar(16) = NULL,
    @Country nvarchar(64) = NULL,
    @FirstName nvarchar(64),
    @LastName nvarchar(64)
)
AS BEGIN
    BEGIN TRY;
    BEGIN TRANSACTION;
        INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
        VALUES (@Email, @Phone, @Address, @City, @PostalCode, @Country)
        INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
        VALUES (@@IDENTITY, @FirstName, @LastName)
        
        COMMIT;
    END TRY
    BEGIN CATCH;
        ROLLBACK;
        THROW;
    END CATCH
END
GO
--<