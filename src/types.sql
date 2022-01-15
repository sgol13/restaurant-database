CREATE TYPE OrderedItemsListT AS TABLE (
    MealID int NOT NULL UNIQUE,
    Quantity int DEFAULT 1
)

CREATE TYPE ReservationTablesListT AS TABLE(
    TableID int NOT NULL UNIQUE
)

