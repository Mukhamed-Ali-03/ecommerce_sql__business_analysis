SELECT 
    o.ShipMode AS ShippingMethood,
    COUNT(DISTINCT d.OrderKey) AS NumberOfOrders,
    SUM(d.Sales) AS TotalRevenue,
    SUM(d.Profit) AS TotalProfit,
    (SUM(d.Profit) / SUM(d.Sales)) * 100 AS ProfitMargin,
    SUM(d.ShippingCost) AS TotalShippingCost,
    SUM(d.ShippingCost) / COUNT(DISTINCT d.OrderKey) AS AverageShippingCostPerOrder,
    CONCAT(FORMAT((SUM(d.ShippingCost) / SUM(d.Sales)) * 100, 2), '%') AS ShippingCostToRevenuePercent
FROM Orders AS o
JOIN OrderDetails AS d ON d.OrderKey = o.OrderKey
GROUP BY ShippingMethood
ORDER BY ShippingMethood;
