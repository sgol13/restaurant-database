--> Funkcje
--# GetMenuForDay(Day)
--- Zwraca ID menu obowiązującego w podanym czasie.
CREATE OR ALTER FUNCTION GetMenuForDay(@Day datetime) RETURNS int
BEGIN
    RETURN (SELECT MenuID FROM Menu WHERE Active = 1 AND @Day BETWEEN StartDate AND EndDate)
END
GO
--<