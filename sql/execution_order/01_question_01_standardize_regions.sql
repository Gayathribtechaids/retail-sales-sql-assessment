-- QUESTION 1: Standardize store regions
-- Run after loading the six starter tables.

CREATE TABLE Regions (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Regions (RegionID, RegionName)
VALUES
    (1, 'North'),
    (2, 'South'),
    (3, 'West');

ALTER TABLE Stores
ADD COLUMN RegionID INT;

UPDATE Stores
SET RegionID = CASE
    WHEN UPPER(TRIM(RegionRaw)) IN ('N', 'NORTH') THEN 1
    WHEN UPPER(TRIM(RegionRaw)) IN ('S', 'SOUTH') THEN 2
    WHEN UPPER(TRIM(RegionRaw)) IN ('W', 'WEST') THEN 3
    ELSE NULL
END;

-- Store-to-region mapping
SELECT
    s.StoreID,
    s.StoreName,
    s.RegionRaw,
    r.RegionID,
    r.RegionName
FROM Stores s
LEFT JOIN Regions r
    ON s.RegionID = r.RegionID
ORDER BY s.StoreID;

-- Unmapped stores (expected: no rows for the supplied assessment data)
SELECT
    StoreID,
    StoreName,
    RegionRaw
FROM Stores
WHERE RegionID IS NULL;
