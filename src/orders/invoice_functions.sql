--> Funkcje
--# CanCreateInvoice
--- Sprawdza czy dany klient ma uzupełnione wszystkie dane konieczne do wygenerowania faktury.
CREATE OR ALTER FUNCTION CanCreateInvoice(@CustomerID int) RETURNS bit
BEGIN
    RETURN CASE WHEN EXISTS (
        SELECT * 
        FROM Customers c 
            LEFT JOIN CompanyCustomers cc ON cc.CustomerID = c.CustomerID
            LEFT JOIN PrivateCustomers pc ON pc.CustomerID = c.CustomerID
        WHERE
            -- ((pc.FirstName IS NOT NULL AND pc.LastName IS NOT NULL) OR cc.CompanyName IS NOT NULL) AND
            -- c.Address IS NOT NULL AND
            -- c.City IS NOT NULL AND
            -- c.PostalCode IS NOT NULL AND
            -- c.Country IS NOT NULL AND
            c.CustomerID = @CustomerID
        ) THEN 1 ELSE 0 END
END
GO
--<

--> Funkcje
--# CountInvoicesForDay
--- Zwraca liczbę faktur wystawionych danego dnia.
CREATE OR ALTER FUNCTION CountInvoicesForDay(@Day datetime) RETURNS int
BEGIN
RETURN (
    SELECT 
        count(1)
    FROM
        Invoices
    WHERE
        DATEDIFF(day, @Day, Date) = 0
    )
END 
GO
--<


--> Funkcje
--# CreateInvoiceID
--- Zwraca proponowany numer faktury na obecny dzień. 
--- Numer faktury jest połączeniem daty wystawienia i numeru kolejnej faktury z tego dnia.
CREATE OR ALTER FUNCTION CreateInvoiceID() RETURNS varchar(16)
BEGIN
RETURN CONCAT_WS('/', 
                DATEPART(year, GETDATE()), 
                DATEPART(month, GETDATE()), 
                DATEPART(day, GETDATE()), 
                dbo.CountInvoicesForDay(GETDATE())
                )
END
GO
--<
