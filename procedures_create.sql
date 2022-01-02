CREATE PROCEDURE UpdateConstants(
    @Z1 INT = NULL,
    @K1 INT = NULL,
    @R1 INT = NULL,
    @K2 INT = NULL,
    @R2 INT = NULL,
    @D1 INT = NULL,
    @WZ INT = NULL,
    @WK INT = NULL
) AS BEGIN
    DECLARE @PREV_Z1 INT
    DECLARE @PREV_K1 INT
    DECLARE @PREV_R1 INT
    DECLARE @PREV_K2 INT
    DECLARE @PREV_R2 INT
    DECLARE @PREV_D1 INT
    DECLARE @PREV_WZ INT
    DECLARE @PREV_WK INT

    SELECT 
        @PREV_Z1 = Z1,
        @PREV_K1 = K1,
        @PREV_R1 = R1,
        @PREV_K2 = K2,
        @PREV_R2 = R2,
        @PREV_D1 = D1,
        @PREV_WZ = WZ,
        @PREV_WK = WK
    FROM Constants

    INSERT INTO Constants(Date, Z1, K1, R1, K2, R2, D1, WZ, WK)
    VALUES (
        GETDATE(),
        ISNULL(@Z1, @PREV_Z1),
        ISNULL(@K1, @PREV_K1),
        ISNULL(@R1, @PREV_R1),
        ISNULL(@K2, @PREV_K2),
        ISNULL(@R2, @PREV_R2),
        ISNULL(@D1, @PREV_D1),
        ISNULL(@WZ, @PREV_WZ),
        ISNULL(@WK, @PREV_WK)
    )
END
GO

-- EXECUTE UpdateConstants
--    @Z1 = 123,
--    @K1 = 40;
-- GO

CREATE PROCEDURE CreateOrderInvoice(@OrderID int)
AS BEGIN
    IF (SELECT InvoiceID FROM Orders WHERE OrderID = @OrderID) IS NOT NULL
    BEGIN
        RAISERROR('Order already has an invoice', -1, -1)
    END
    IF (SELECT Paid FROM Orders WHERE OrderID = @OrderID) = 0
    BEGIN
        RAISERROR('Order hasnt been paid', -1, -1)
    END

    INSERT INTO Invoices(
        Date, TotalAmount, FirstName, LastName, CompanyName, Email, Phone, Address, City, PostalCode, Country
    )
    SELECT GETDATE(), dbo.TotalOrderAmount(@OrderID), FirstName, LastName, CompanyName, 
                Email, Phone, Address, City, PostalCode, Country 
    FROM Orders
        JOIN Customers ON Customers.CustomerID = Orders.OrderID
        LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Customers.CustomerID
        LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Customers.CustomerID
    WHERE Orders.OrderID = @OrderID;

    UPDATE Orders SET InvoiceID = @@IDENTITY
    WHERE OrderID = @OrderID
END
GO

CREATE PROCEDURE CreateMonthlyInvoice(@CustomerID Int, @Month int, @Year int)
AS BEGIN
    -- Last day of the month is in the past
    IF DATEFROMPARTS(@Year, @Month, DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)))) >= GETDATE()
    BEGIN
        RAISERROR('The month hasnt passed yet', -1, -1)
    END

    INSERT INTO Invoices(
        Date, TotalAmount, FirstName, LastName, CompanyName, Email, Phone, Address, City, PostalCode, Country
    )
    SELECT GETDATE(), SUM(dbo.TotalOrderAmount(Orders.OrderID)), MAX(FirstName), MAX(LastName), 
            MAX(CompanyName), MAX(Email), MAX(Phone), MAX(Address), MAX(City), MAX(PostalCode), MAX(Country) 
    FROM Customers
        LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID AND Orders.InvoiceID IS NULL
                            AND MONTH(Orders.CompletionDate) = @Month AND YEAR(Orders.CompletionDate) = @Year
        LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Customers.CustomerID
        LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Customers.CustomerID
    WHERE Customers.CustomerID = @CustomerID
    GROUP BY Customers.CustomerID

    UPDATE Orders SET InvoiceID = @@IDENTITY
    WHERE Orders.CustomerID = @CustomerID AND Orders.InvoiceID IS NULL
            AND MONTH(Orders.CompletionDate) = @Month AND YEAR(Orders.CompletionDate) = @Year
END
GO