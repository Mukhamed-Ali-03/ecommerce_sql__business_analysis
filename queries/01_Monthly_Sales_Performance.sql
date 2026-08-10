USE EcommerceBusinesAnalysis;

SELECT YEAR(o.OrderDate) AS OrderYears, 
    MONTHNAME(o.OrderDate) AS OrderMonths, 
    SUM(d.Sales) AS TotalRevenue, 
    COUNT(DISTINCT o.OrderKey) AS NumOrders, 
    SUM(d.Sales) / COUNT(DISTINCT o.OrderKey) AS AverageOrdVal
FROM Orders AS o
JOIN OrderDetails AS d ON o.OrderKey = d.OrderKey
GROUP BY 
    YEAR(o.OrderDate), MONTH(o.OrderDate), MONTHNAME(o.OrderDate) 
ORDER BY 
    OrderYears, MONTH(o.OrderDate);