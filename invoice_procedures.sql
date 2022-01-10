--> Procedury
--# CreateOrderInvoice(OrderID)
--- Generuje fakturę w tabeli Invoices dla danego zamówienia.
CREATE OR ALTER PROCEDURE CreateOrderInvoice(@OrderID int)
AS BEGIN
    IF (SELECT InvoiceID FROM Orders WHERE OrderID = @OrderID) IS NOT NULL
    BEGIN
        ;THROW 5200, 'Order already has an invoice', 1
        RETURN
    END
    IF (SELECT Paid FROM Orders WHERE OrderID = @OrderID) = 0
    BEGIN
        ;THROW 5200, 'Order has not been paid yet', 1
        RETURN
    END

    BEGIN TRANSACTION;
        INSERT INTO Invoices(
            Date, CustomerID, TotalAmount, FirstName, LastName, CompanyName, Email, Phone, Address, City, PostalCode, Country
        )
        SELECT GETDATE(), Customers.CustomerID, dbo.TotalOrderAmount(@OrderID), FirstName, LastName, CompanyName, 
                    Email, Phone, Address, City, PostalCode, Country 
        FROM Orders
            JOIN Customers ON Customers.CustomerID = Orders.OrderID
            LEFT JOIN CompanyCustomers ON CompanyCustomers.CustomerID = Customers.CustomerID
            LEFT JOIN PrivateCustomers ON PrivateCustomers.CustomerID = Customers.CustomerID
        WHERE Orders.OrderID = @OrderID;

        UPDATE Orders SET InvoiceID = @@IDENTITY
        WHERE OrderID = @OrderID
    COMMIT;
END
GO
--<


--> Procedury
--# CreateMonthlyInvoice(CustomerID, Month, Year)
--- Generuje fakturę dla danego klienta, dla danego miesiąca.
CREATE OR ALTER PROCEDURE CreateMonthlyInvoice(@CustomerID Int, @Month int, @Year int)
AS BEGIN
    IF DATEFROMPARTS(@Year, @Month, DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)))) >= GETDATE()
    BEGIN
        ;THROW 5200, 'The month hasnt passed yet', 1
        RETURN
    END

    BEGIN TRANSACTION;
        INSERT INTO Invoices(
            Date, CustomerID, TotalAmount, FirstName, LastName, CompanyName, Email, Phone, Address, City, PostalCode, Country
        )
        SELECT GETDATE(), Customers.CustomerID SUM(dbo.TotalOrderAmount(Orders.OrderID)), MAX(FirstName), MAX(LastName), 
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
    COMMIT;
END
GO
--<