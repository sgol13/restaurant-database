DROP TYPE IF EXISTS OrderedItemsListT

CREATE TYPE OrderedItemsListT AS TABLE (
    MealID int NOT NULL UNIQUE,
    Quantity int DEFAULT 1
)

CREATE TYPE ReservationTablesList AS TABLE(
    TableID int NOT NULL UNIQUE
)

