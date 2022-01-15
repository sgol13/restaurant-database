SELECT * FROM Customers
SELECT * FROM CompanyCustomers

EXEC AddCompanyCustomer
    @Email = 'abc@gmail.com',
    @CompanyName = 'ABC';

DELETE FROM Customers
DELETE FROM CompanyCustomers