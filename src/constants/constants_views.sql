--> Widoki
--# CurrentConstants
--- Zwraca aktualne wartości stałych rabatowych w systemie
CREATE OR ALTER VIEW CurrentConstants
AS SELECT TOP 1 
        c.Z1, c.K1, c.R1, c.K2, c.R2, c.D1, c.WZ, c.WK
    FROM 
        Constants c
    ORDER BY 
        c.[Date] DESC
GO
--<