BEGIN TRANSACTION

DELETE FROM Constants
EXEC UpdateConstants @Date = '2021-12-11', @Z1 = 2, @K1 = 20, @R1 = 10, @K2 = 100, @R2 = 20, @D1 = 7, @WZ = 30, @WK = 3; 
EXEC UpdateConstants @K1 = 18, @R1 = 8, @R2 = 15; 

SELECT * FROM Constants
SELECT * FROM CurrentConstants

ROLLBACK
