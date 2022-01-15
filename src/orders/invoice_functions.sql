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
            ((pc.FirstName != NULL AND pc.LastName != NULL) OR cc.CompanyName != NULL) AND
            c.Address != NULL AND
            c.City != NULL AND
            c.PostalCode != NULL AND
            c.Country != NULL AND
            c.CustomerID = @CustomerID
        ) THEN 1 ELSE 0 END
END
GO
--<

