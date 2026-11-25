-- SQL QUERY COLLECTION | QUESTIONS 1 TO 11
-- MySQL 8.0 | DB Fiddle
-- This file contains SQL statements only (plus question labels/comments).
-- Prerequisite: starter tables and assessment data must already exist.

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

-- QUESTION 2: Remove duplicate order lines
-- Keeps the latest LoadedAt row for each OrderItemID.
-- Run once after Question 1. If rerunning from scratch, drop OrderItems_Clean first.

CREATE TABLE OrderItems_Clean AS
SELECT *
FROM OrderItems;

DELETE oi1
FROM OrderItems_Clean oi1
JOIN OrderItems_Clean oi2
    ON oi1.OrderItemID = oi2.OrderItemID
    AND oi1.LoadedAt < oi2.LoadedAt;

-- Verify duplicate removal (expected: no rows)
SELECT
    OrderItemID,
    COUNT(*) AS RowCount
FROM OrderItems_Clean
GROUP BY OrderItemID
HAVING COUNT(*) > 1;

-- Verify cleaned row count (provided output: 489)
SELECT COUNT(*) AS CleanedOrderItemsCount
FROM OrderItems_Clean;

-- Display cleaned data
SELECT *
FROM OrderItems_Clean
ORDER BY OrderItemID;

-- QUESTION 3: ER diagram only; no SQL query.

-- QUESTION 4: Orders with matching customers
SELECT
    o.OrderID,
    o.CustomerID,
    c.CustomerName
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;

-- QUESTION 5: Orders with unmatched customer IDs
SELECT
    o.OrderID,
    o.CustomerID
FROM Orders o
LEFT JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL
ORDER BY o.OrderID;

-- QUESTION 6: Customers with no orders
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
ORDER BY c.CustomerID;

-- QUESTION 7: Order lines with multiple returns
SELECT
    OrderItemID,
    COUNT(*) AS ReturnTransactionCount,
    SUM(ReturnQuantity) AS TotalReturnedUnits
FROM Returns
GROUP BY OrderItemID
HAVING COUNT(*) > 1
ORDER BY OrderItemID;

-- QUESTION 8A: Completed order count and gross sales by region
SELECT
    r.RegionName,
    COUNT(DISTINCT o.OrderID) AS CompletedOrderCount,
    SUM(oi.Quantity * oi.UnitPrice) AS GrossSales
FROM Orders o
INNER JOIN Stores s
    ON o.StoreID = s.StoreID
INNER JOIN Regions r
    ON s.RegionID = r.RegionID
INNER JOIN OrderItems_Clean oi
    ON o.OrderID = oi.OrderID
WHERE o.OrderStatus = 'Completed'
  AND o.OrderDate >= '2026-10-01'
  AND o.OrderDate < '2026-11-01'
GROUP BY r.RegionID, r.RegionName
ORDER BY r.RegionID;

-- QUESTION 8B: Return value by region for returns processed in October 2026
SELECT
    r.RegionName,
    SUM(ret.ReturnQuantity * oi.UnitPrice) AS ReturnValue
FROM Returns ret
INNER JOIN OrderItems_Clean oi
    ON ret.OrderItemID = oi.OrderItemID
INNER JOIN Orders o
    ON oi.OrderID = o.OrderID
INNER JOIN Stores s
    ON o.StoreID = s.StoreID
INNER JOIN Regions r
    ON s.RegionID = r.RegionID
WHERE ret.ReturnDate >= '2026-10-01'
  AND ret.ReturnDate < '2026-11-01'
GROUP BY r.RegionID, r.RegionName
ORDER BY r.RegionID;

-- QUESTION 9: Written comparison based on Q8; no separate query requested.
-- Highest gross: North, 14,389.25. Highest net: South, 13,037.00.
-- Net-sales difference between South and North: 210.00.

-- QUESTION 10A: October gross sales by store
SELECT
    r.RegionName,
    s.StoreID,
    s.StoreName,
    COUNT(DISTINCT o.OrderID) AS CompletedOrderCount,
    COALESCE(SUM(oi.Quantity * oi.UnitPrice), 0) AS GrossSales
FROM Stores s
INNER JOIN Regions r
    ON s.RegionID = r.RegionID
LEFT JOIN Orders o
    ON s.StoreID = o.StoreID
    AND o.OrderStatus = 'Completed'
    AND o.OrderDate >= '2026-10-01'
    AND o.OrderDate < '2026-11-01'
LEFT JOIN OrderItems_Clean oi
    ON o.OrderID = oi.OrderID
GROUP BY r.RegionID, r.RegionName, s.StoreID, s.StoreName
ORDER BY r.RegionID, s.StoreID;

-- QUESTION 10B: October return value by store
SELECT
    r.RegionName,
    s.StoreID,
    s.StoreName,
    COALESCE(
        SUM(ret.ReturnQuantity * oi.UnitPrice), 0
    ) AS ReturnValue
FROM Stores s
INNER JOIN Regions r
    ON s.RegionID = r.RegionID
LEFT JOIN Orders o
    ON s.StoreID = o.StoreID
LEFT JOIN OrderItems_Clean oi
    ON o.OrderID = oi.OrderID
LEFT JOIN Returns ret
    ON oi.OrderItemID = ret.OrderItemID
    AND ret.ReturnDate >= '2026-10-01'
    AND ret.ReturnDate < '2026-11-01'
GROUP BY r.RegionID, r.RegionName, s.StoreID, s.StoreName
ORDER BY r.RegionID, s.StoreID;

-- QUESTION 11: Return value by product category in the North region
SELECT
    p.Category,
    SUM(ret.ReturnQuantity * oi.UnitPrice) AS ReturnValue,
    ROUND(
        SUM(ret.ReturnQuantity * oi.UnitPrice) * 100 /
        SUM(SUM(ret.ReturnQuantity * oi.UnitPrice)) OVER (),
        2
    ) AS ReturnValueShare
FROM Returns ret
INNER JOIN OrderItems_Clean oi
    ON ret.OrderItemID = oi.OrderItemID
INNER JOIN Products p
    ON oi.ProductID = p.ProductID
INNER JOIN Orders o
    ON oi.OrderID = o.OrderID
INNER JOIN Stores s
    ON o.StoreID = s.StoreID
INNER JOIN Regions r
    ON s.RegionID = r.RegionID
WHERE r.RegionName = 'North'
  AND ret.ReturnDate >= '2026-10-01'
  AND ret.ReturnDate < '2026-11-01'
GROUP BY p.Category
ORDER BY ReturnValue DESC;
