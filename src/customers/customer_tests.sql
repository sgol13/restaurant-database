BEGIN
BEGIN TRANSACTION

    DELETE FROM PrivateCustomers
    DELETE FROM CompanyCustomers
    DELETE FROM Customers

    EXEC AddCompanyCustomer 
        @CompanyName = 'XYZ',
        @NIP = '13894343',
        @Email = 'aenean.sed@yahoo.ca',
        @Phone = '1-793-127-3195', 
        @Address = '203-143 Vitae, Av.',
        @City = 'Biała Podlaska',
        @PostalCode = '35-831', 
        @Country = 'Poland';

    EXEC AddPrivateCustomer
        @FirstName = 'Jan',
        @LastName = 'Kowalski',
        @Email = 'quis.urna@icloud.net',
        @Phone = '1-622-514-2488', 
        @Address = '976-1406 Quis St.',
        @City = 'Kraków',
        @PostalCode = '86-678', 
        @Country = 'Poland';
    

    SELECT * FROM CustomersFullNames

    DECLARE @customerID1 int = (SELECT CustomerID FROM CompanyCustomers WHERE CompanyName = 'XYZ')
    EXEC UpdateCompanyCustomer @CustomerID = @customerID1, @CompanyName = 'FIRMA', @City = 'MIASTO';

    DECLARE @customerID2 int = (SELECT CustomerID FROM PrivateCustomers WHERE LastName = 'Kowalski')
    EXEC UpdatePrivateCustomer @CustomerID = @customerID2,  @FirstName = 'NOWEIMIE', @City = 'MIASTO222';

    SELECT * FROM CustomersFullNames

    EXEC ForgetCustomer @CustomerID = @customerID1;

    SELECT * FROM CustomersFullNames

    SELECT * FROM Customers

ROLLBACK
END
