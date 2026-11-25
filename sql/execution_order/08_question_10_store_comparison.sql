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
