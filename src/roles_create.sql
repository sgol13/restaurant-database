DROP ROLE manager;
--> Uprawnienia
--# Manager
--- Rola Kierownictwa zapewnia największe możliwości działania w bazie danych, zmiany menu,
--- generowanie raportów, możliwość zmiany paramatrów, a także wszystko co może reszta obsługi.
CREATE ROLE manager;
GRANT SELECT ON SCHEMA::dbo TO manager;
--<

DROP ROLE staff;
--> Uprawnienia
--# Staff
--- Posiada uprawnienia do wykonywania dowolnych operacji które nie modyfikują bazy danych, a także do
--- do procedur obsługujących rezerwacje i zamówienia.
CREATE ROLE staff;
GRANT SELECT ON SCHEMA::dbo TO staff;
--<

DROP ROLE customer;
--> Uprawnienia
--# Customer
--- Posiada uprawnienia tylko do składania rezerwacji i zamówień, generowaniu niektórych raportów i faktur.
CREATE ROLE customer;
--<