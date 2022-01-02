INSERT INTO Meals (Name, SeaFood, DefaultPrice, Active)
VALUES 
('Tiramisu', 0, 9.0, 1),
('Szarlotka', 0, 8.0, 1),
('Kawa', 0, 7.50, 1),
('Herbata', 0, 5.0, 1),
('Frytki', 0, 6.0, 1),
('Krewetki', 1, 25.50, 1),
('Ośmiornica', 1, 27.30, 1),
('Małże', 1, 23.70, 1),
('Kalmary', 1, 22.0, 1),
('Pizza Salami', 0, 28.0, 1),
('Pizza Napoletana', 0, 30.0, 1),
('Pizza Margherita', 0, 25.0, 1),
('Pizza Vegetariana', 0, 28.0, 1),
('Woda mineralna niegazowana', 0, 3.0, 1),
('Woda mineralna gazowana', 0, 3.50, 1);

INSERT INTO Menu (StartDate, EndDate)
VALUES ('2021-12-17','2021-12-31', 1),
('2022-01-01','2022-01-08', 1),
('2022-01-09','2022-01-15', 1);

INSERT INTO MenuItems (MenuID, MealID, Price)
VALUES 
(1, 2, 9),
(1, 3, 8.50),
(1, 4, 5.50),
(1, 5, 6.50),
(1, 6, 26.90),
(1, 10, 30.0),
(1, 12, 24.0),
(1, 14, 2.50),
(2, 1, 10),
(2, 8, 24.0),
(2, 9, 21.70),
(2, 11, 32.20),
(2, 13, 25.40),
(2, 14, 3.0),
(2, 15, 3.0),
(3, 1, 9.50),
(3, 3, 8.0),
(3, 4, 5.0),
(3, 6, 26.80),
(3, 7, 28.30),
(3, 12, 23.0);

INSERT INTO Tables (Seats, Active)
VALUES
(4, 1),
(3, 1),
(8, 1),
(10, 1),
(6, 1),
(5, 1),
(4, 1),
(4, 1),
(4, 1),
(6, 1),
(3, 1),
(9, 1),
(2, 1),
(2, 1),
(2, 1),
(3, 1),
(6, 1),
(8, 1),
(8, 1);
