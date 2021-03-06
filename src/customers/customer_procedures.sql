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
        IF @@TRANCOUNT > 0
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
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# UpdateCustomer(...)
--- Umożliwia zmianę danych klienta. Obsługuje dane wspólne dla klienta firmowego i indywidualnego.
CREATE OR ALTER PROCEDURE UpdateCustomer(
    @CustomerID int,

    @Email nvarchar(64) = NULL,
    @Phone nvarchar(16) = NULL,
    @Address nvarchar(64) = NULL,
    @City nvarchar(64) = NULL,
    @PostalCode varchar(16) = NULL,
    @Country nvarchar(64) = NULL
)
AS BEGIN
    BEGIN TRY;
    BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT * FROM Customers WHERE CustomerID = @CustomerID) BEGIN
            ;THROW 52000, 'The customer does not exist', 1
            RETURN 
        END

        DECLARE @PREV_Email nvarchar(64);
        DECLARE @PREV_Phone nvarchar(16);
        DECLARE @PREV_Address nvarchar(64);
        DECLARE @PREV_City nvarchar(64);
        DECLARE @PREV_PostalCode varchar(16);
        DECLARE @PREV_Country nvarchar(64);

        -- get previous values from Customers
        SELECT
            @PREV_Email = Email,
            @PREV_Phone = Phone,
            @PREV_Address = Address,
            @PREV_City = City,
            @PREV_PostalCode = PostalCode,
            @PREV_Country = Country
        FROM Customers
        WHERE CustomerID = @CustomerID

        -- set new values in Customers
        UPDATE Customers
        SET Email = ISNULL(@Email, @PREV_Email),
            Phone = ISNULL(@Phone, @PREV_Phone), 
            Address = ISNULL(@Address, @PREV_Address), 
            City = ISNULL(@City, @PREV_City), 
            PostalCode = ISNULL(@PostalCode, @PREV_PostalCode), 
            Country = ISNULL(@Country, @PREV_Country)
        WHERE CustomerID = @CustomerID

        COMMIT;
    END TRY
    BEGIN CATCH;
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
--<

--> Procedury
--# UpdateCompanyCustomer(...)
--- Umożliwia zmianę danych klienta firmowego. Pozostałe dane pozostają bez zmian.
CREATE OR ALTER PROCEDURE UpdateCompanyCustomer(
    @CustomerID int,

    @Email nvarchar(64) = NULL,
    @Phone nvarchar(16) = NULL,
    @Address nvarchar(64) = NULL,
    @City nvarchar(64) = NULL,
    @PostalCode varchar(16) = NULL,
    @Country nvarchar(64) = NULL,
    @CompanyName nvarchar(64) = NULL,
    @NIP varchar(16) = NULL
)
AS BEGIN
    BEGIN TRY;
    BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT * FROM Customers WHERE CustomerID = @CustomerID) BEGIN
            ;THROW 52000, 'The customer does not exist', 1
            RETURN 
        END

        -- update values in Customers (common part)
        EXEC UpdateCustomer 
            @CustomerID = @CustomerID,
            @Email = @Email,
            @Phone = @Phone,
            @Address = @Address,
            @City = @City,
            @PostalCode = @PostalCode,
            @Country = @Country;

        -- update values in CompanyCustomers
        DECLARE @PREV_CompanyName nvarchar(64);
        DECLARE @PREV_NIP varchar(16);

        SELECT 
            @PREV_CompanyName = CompanyName,
            @PREV_NIP = NIP
        FROM CompanyCustomers
        WHERE CustomerID = @CustomerID

        UPDATE CompanyCustomers
        SET CompanyName = ISNULL(@CompanyName, @PREV_CompanyName),
            NIP = ISNULL(@NIP, @PREV_NIP)
        WHERE CustomerID = @CustomerID

    COMMIT;
    END TRY
    BEGIN CATCH;
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# UpdatePrivateCustomer(...)
--- Umożliwia zmianę danych klienta indywidualnego. Pozostałe dane pozostają bez zmian.
CREATE OR ALTER PROCEDURE UpdatePrivateCustomer(
    @CustomerID int,

    @Email nvarchar(64) = NULL,
    @Phone nvarchar(16) = NULL,
    @Address nvarchar(64) = NULL,
    @City nvarchar(64) = NULL,
    @PostalCode varchar(16) = NULL,
    @Country nvarchar(64) = NULL,
    @FirstName nvarchar(64) = NULL,
    @LastName nvarchar(64) = NULL
)
AS BEGIN
    BEGIN TRY;
    BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT * FROM Customers WHERE CustomerID = @CustomerID) BEGIN
            ;THROW 52000, 'The customer does not exist', 1
            RETURN 
        END

        -- update values in Customers (common part)
        EXEC UpdateCustomer 
            @CustomerID = @CustomerID,
            @Email = @Email,
            @Phone = @Phone,
            @Address = @Address,
            @City = @City,
            @PostalCode = @PostalCode,
            @Country = @Country;

        -- update values in PrivateCustomers
        DECLARE @PREV_FirstName nvarchar(64);
        DECLARE @PREV_LastName nvarchar(64);

        SELECT 
            @PREV_FirstName = FirstName,
            @PREV_LastName = LastName
        FROM PrivateCustomers
        WHERE CustomerID = @CustomerID

        UPDATE PrivateCustomers
        SET FirstName = ISNULL(@FirstName, @PREV_FirstName),
            LastName = ISNULL(@LastName, @PREV_LastName)
        WHERE CustomerID = @CustomerID

    COMMIT;
    END TRY
    BEGIN CATCH;
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
--<


--> Procedury
--# ForgetCustomer(...)
--- Umożliwia usunięcie danych klienta bez utraty spójności bazy danych (pozostaje tylko CustomerID)
CREATE OR ALTER PROCEDURE ForgetCustomer(@CustomerID INT)
AS BEGIN
    BEGIN TRY;
    BEGIN TRANSACTION;

    IF NOT EXISTS (SELECT * FROM Customers WHERE CustomerID = @CustomerID) BEGIN
        ;THROW 52000, 'The customer does not exist', 1
        RETURN 
    END

    UPDATE Customers
    SET 
        Email = NULL,
        Phone = NULL,
        Address = NULL,
        City = NULL,
        PostalCode = NULL,
        Country = NULL
    WHERE CustomerID = @CustomerID

    UPDATE PrivateCustomers
    SET
        FirstName = NULL,
        LastName = NULL
    WHERE CustomerID = @CustomerID

    UPDATE CompanyCustomers
    SET
        CompanyName = NULL,
        NIP = NULL
    WHERE CustomerID = @CustomerID

    COMMIT;
    END TRY
    BEGIN CATCH;
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END
GO
--<