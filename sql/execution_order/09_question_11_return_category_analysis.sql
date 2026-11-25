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
