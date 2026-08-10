SELECT o.Country, 
    CONCAT(FORMAT((SUM(d.Sales) / total.GrandSales) * 100, 2), '%') AS RevenueSharePercent,
    SUM(d.Sales) AS TotalRevenue,
    CONCAT(FORMAT((SUM(d.Profit) / total.GrandProfit) * 100, 2), '%') AS ProfitSharePercent,
    SUM(d.Profit) AS TotalProfit,
    COUNT(DISTINCT d.OrderKey) AS NumberOfOrders
FROM Orders AS o
JOIN OrderDetails AS d ON d.OrderKey = o.OrderKey
CROSS JOIN (
    SELECT SUM(Sales) AS GrandSales, SUM(Profit) AS GrandProfit FROM OrderDetails
) AS total
GROUP BY o.Country, total.GrandSales, total.GrandProfit
ORDER BY TotalRevenue DESC;