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
