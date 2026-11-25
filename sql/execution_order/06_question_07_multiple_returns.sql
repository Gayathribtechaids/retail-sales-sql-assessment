-- QUESTION 7: Order lines with multiple returns
SELECT
    OrderItemID,
    COUNT(*) AS ReturnTransactionCount,
    SUM(ReturnQuantity) AS TotalReturnedUnits
FROM Returns
GROUP BY OrderItemID
HAVING COUNT(*) > 1
ORDER BY OrderItemID;
