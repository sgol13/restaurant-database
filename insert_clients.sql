-- SELECT * FROM Customers
-- SELECT * FROM PrivateCustomers
-- SELECT * FROM CompanyCustomers

INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('urna.nunc@yahoo.couk','1-313-551-7732','432-8058 Tempor Avenue','Poznań','46-747','Poland')
INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
VALUES (@@IDENTITY, 'Michal', 'Gniadek')


INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('vestibulum.nec@icloud.net','(731) 701-3055','2728 Sociosqu Ave','Kraków','72-516','Poland')
INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
VALUES (@@IDENTITY, 'Dominika', 'Bochenczyk')


INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('gravida.aliquam@outlook.edu','1-667-622-1693','P.O. Box 529, 8864 Facilisis Avenue','Ełk','42-588','Poland')
INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
VALUES (@@IDENTITY, 'Szymon', 'Golebiowski')


INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('quis.urna@icloud.net','1-622-514-2488','976-1406 Quis St.','Kraków','86-678','Poland')
INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
VALUES (@@IDENTITY, 'Jan', 'Kowalski')


INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('magna.suspendisse.tristique@outlook.com','1-810-481-0504','P.O. Box 414, 5072 Nisi Rd.','Pabianice','47-317','Poland')
INSERT INTO PrivateCustomers (CustomerID, FirstName, LastName) 
VALUES (@@IDENTITY, 'Anna', 'Kowalska')


INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('aenean.sed@yahoo.ca','1-793-127-3195','203-143 Vitae, Av.','Biała Podlaska','35-831','Poland')
INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
VALUES (@@IDENTITY, 'ABC', 4966179219)


INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('lobortis@outlook.com','(847) 440-3582','557-7664 Urna St.','Kraków','58-481','Poland')
INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
VALUES (@@IDENTITY, 'DEF', 1115221687)

INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES  ('fringilla.ornare@google.com','1-852-730-5387','669-611 Sem. St.','Mielec','40-363','Poland')
INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
VALUES (@@IDENTITY, 'GHI', 3375177688)

INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('erat@hotmail.net','(323) 831-6476','P.O. Box 398, 9736 Mauris Street','Gdańsk','22-646','Poland')
INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
VALUES (@@IDENTITY, 'JKL', 1211906809)

INSERT INTO Customers (Email, Phone, Address, City, PostalCode, Country)
VALUES ('per@google.net','(722) 283-6152','874-3136 Sed St.','Gdynia','49-530','Poland')
INSERT INTO CompanyCustomers (CustomerID, CompanyName, NIP)
VALUES (@@IDENTITY, 'MNO', 3773625620)
