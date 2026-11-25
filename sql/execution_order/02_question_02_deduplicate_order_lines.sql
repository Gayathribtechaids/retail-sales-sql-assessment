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
