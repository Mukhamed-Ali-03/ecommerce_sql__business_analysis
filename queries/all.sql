CREATE DATABASE EcommerceBusinesAnalysis;

USE EcommerceBusinesAnalysis;

CREATE TABLE RawSales (
	SourceIndex INT,
    RowID INT,
    OrderID VARCHAR(50),
    OrderDate VARCHAR(30),      
    ShipDate VARCHAR(30),      
    ShipMode VARCHAR(50),
    CustomerID VARCHAR(50),
    CustomerName VARCHAR(150),
    Segment VARCHAR(50),        
    PostalCode VARCHAR(30),      
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Region VARCHAR(50),
    Market VARCHAR(50),
    ProductID VARCHAR(50),      
    Category VARCHAR(50),
    SubCategory VARCHAR(50),     
    ProductName VARCHAR(255),    
    Sales DECIMAL(10,2),         
    Quantity INT,                
    Discount DECIMAL(5,2),      
    Profit DECIMAL(10,2),        
    ShippingCost DECIMAL(10,2),  
    OrderPriority VARCHAR(50)    
);

SELECT *
FROM RawSales 
LIMIT 10;

ALTER TABLE RawSales
MODIFY COLUMN OrderDate DATE;
ALTER TABLE RawSales
MODIFY COLUMN ShipDate DATE;

-- Check for duplicate Row IDs
SELECT
    RowID,
    COUNT(*) AS Occurrences
FROM RawSales
GROUP BY RowID
HAVING COUNT(*) > 1;

-- Creating tables
CREATE TABLE Customers (
    CustomerID VARCHAR(30) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Segment VARCHAR(30)
);

CREATE TABLE Products (
    ProductID VARCHAR(50) PRIMARY KEY,
    ProductName VARCHAR(255),
    Category VARCHAR(50),
    SubCategory VARCHAR(50)
);

CREATE TABLE Orders (
    OrderKey INT AUTO_INCREMENT PRIMARY KEY,
    OrderID VARCHAR(30) NOT NULL,
    CustomerID VARCHAR(30) NOT NULL,
    OrderDate DATE,
    ShipDate DATE,
    ShipMode VARCHAR(30),
    PostalCode VARCHAR(20),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Region VARCHAR(50),
    Market VARCHAR(50),
    OrderPriority VARCHAR(30),

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    RowID INT PRIMARY KEY,
    OrderKey INT NOT NULL,
    ProductID VARCHAR(50),
    Sales DECIMAL(18,4),
    Quantity INT,
    Discount DECIMAL(10,4),
    Profit DECIMAL(18,4),
    ShippingCost DECIMAL(18,4),

    FOREIGN KEY (OrderKey)
        REFERENCES Orders(OrderKey),

    FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

-- Load Customers
INSERT INTO Customers (
    CustomerID,
    CustomerName,
    Segment
)
SELECT DISTINCT
    CustomerID,
    CustomerName,
    Segment
FROM RawSales;

-- Load Products
INSERT INTO Products (
    ProductID,
    ProductName,
    Category,
    SubCategory
)
SELECT DISTINCT
    ProductID,
    ProductName,
    Category,
    SubCategory
FROM RawSales;

-- Load Orders
INSERT INTO Orders (
    OrderID,
    CustomerID,
    OrderDate,
    ShipDate,
    ShipMode,
    PostalCode,
    City,
    State,
    Country,
    Region,
    Market,
    OrderPriority
)
SELECT DISTINCT
    OrderID,
    CustomerID,
    OrderDate,       
    ShipDate,
    ShipMode,
    PostalCode,
    City,
    State,
    Country,
    Region,
    Market,
    OrderPriority
FROM RawSales;

-- Load OrderDetails
INSERT INTO OrderDetails (
    RowID,
    OrderKey,
    ProductID,
    Sales,
    Quantity,
    Discount,
    Profit,
    ShippingCost
)
SELECT
    r.RowID,
    o.OrderKey,
    r.ProductID,
    r.Sales,
    r.Quantity,
    r.Discount,
    r.Profit,
    r.ShippingCost
FROM RawSales AS r
INNER JOIN Orders AS o
    ON r.OrderID = o.OrderID
    AND r.CustomerID = o.CustomerID
    AND r.OrderDate = o.OrderDate
    AND r.ShipDate = o.ShipDate
    AND r.ShipMode = o.ShipMode
    AND COALESCE(r.PostalCode, '') = COALESCE(o.PostalCode, '')
    AND r.City = o.City
    AND r.State = o.State
    AND r.Country = o.Country
    AND r.Region = o.Region
    AND r.Market = o.Market
    AND r.OrderPriority = o.OrderPriority;
    
-- Validation
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

SELECT COUNT(*) AS TotalProducts
FROM Products;

SELECT COUNT(*) AS TotalOrders
FROM Orders;

SELECT COUNT(*) AS TotalOrderDetails
FROM OrderDetails;

-- 1
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
    
-- 2
SELECT c.CustomerID, 
    c.CustomerName, 
    SUM(d.Sales) AS TotalRevenue, 
    SUM(d.Profit) AS TotalProfit, 
    (SUM(d.Profit) / SUM(d.Sales)) * 100 AS ProfitMargin 
FROM Customers AS c 
JOIN Orders AS o ON o.CustomerID = c.CustomerID 
JOIN OrderDetails AS d ON d.OrderKey = o.OrderKey 
GROUP BY c.CustomerID, c.CustomerName 
ORDER BY SUM(d.Sales) DESC 
LIMIT 10;

-- 3
SELECT c.Segment AS CustomerSegment, 
	SUM(d.Sales) AS TotalRevenue, 
	SUM(d.Profit) AS TotalProfit, 
	COUNT(DISTINCT o.OrderKey) AS NumberOfOrders, 
	(SUM(d.Profit)/SUM(d.Sales))*100 AS ProfitMargin
FROM Customers AS c
JOIN Orders AS o
ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS d
ON d.OrderKey = o.OrderKey
GROUP BY c.Segment
ORDER BY TotalRevenue DESC, TotalProfit DESC;

-- 4
SELECT p.Category, 
	p.SubCategory, 
	SUM(d.Sales) AS TotalRevenue, 
    SUM(d.Profit) AS TotalProfit, 
    (SUM(d.Profit)/SUM(d.Sales))*100 AS ProfitMargin
FROM Products AS p
JOIN OrderDetails AS d ON d.ProductID = p.ProductID
GROUP BY p.Category, p.SubCategory
HAVING SUM(d.Profit) < 0 OR ((SUM(d.Profit)/SUM(d.Sales))*100) < 0
ORDER BY TotalRevenue, TotalProfit;

-- 5
SELECT p.ProductID, 
	p.ProductName, 
    p.Category, 
    p.SubCategory, 
    SUM(d.Sales) AS TotalRevenue, 
    SUM(d.Profit) AS TotalProfit, 
    (SUM(d.Profit)/SUM(d.Sales))*100 AS ProfitMargin
FROM Products AS p
JOIN OrderDetails AS d ON d.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.SubCategory
HAVING SUM(d.Sales) > (	
	SELECT SUM(Sales) / COUNT(DISTINCT ProductID)
	FROM OrderDetails ) 
AND SUM(d.Profit) < 0
ORDER BY TotalRevenue DESC;

-- 6
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

-- 7
SELECT
    CASE
        WHEN d.Discount = 0 THEN 'NO DISCOUNT'
        WHEN d.Discount < 0.1 THEN 'LOW DISCOUNT'
        WHEN d.Discount BETWEEN 0.1 AND 0.3 THEN 'MEDIUM DISCOUNT'
        ELSE 'HIGH DISCOUNT'
    END AS DiscountLevel,
    COUNT(DISTINCT d.OrderKey) AS NumberOfOrders,
    SUM(d.Quantity) AS TotalQuantity,
    SUM(d.Sales) AS TotalRevenue, 
    SUM(d.Profit) AS TotalProfit, 
    (SUM(d.Profit) / SUM(d.Sales)) * 100 AS ProfitMargin
FROM OrderDetails AS d
GROUP BY DiscountLevel
ORDER BY DiscountLevel DESC;

-- 8
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

-- 9
SELECT * 
FROM (
    SELECT 
        p.Category,
        p.ProductID,
        p.ProductName,
        SUM(d.Sales) AS TotalRevenue,
        SUM(d.Profit) AS TotalProfit,
        (SUM(d.Profit) / SUM(d.Sales)) * 100 AS ProfitMargin,
        RANK() OVER (PARTITION BY p.Category ORDER BY SUM(d.Profit) DESC) AS RowRank
    FROM Products AS p
    JOIN OrderDetails AS d ON p.ProductID = d.ProductID
    GROUP BY p.Category, p.ProductID, p.ProductName
) AS RankedProducts
WHERE RowRank <= 3
ORDER BY Category, RowRank;

-- 10
SELECT o.OrderID AS OrderID,
	c.CustomerName AS Customer, 
	p.ProductName AS Product, 
	p.Category AS ProductCategory, 
	o.Country AS Country, 
	d.Sales AS Sales, 
	d.Discount AS NummDiscount,
	d.Profit AS Profit, 
	o.ShipMode AS ShippingMethod,
	d.ShippingCost AS ShippingCost
FROM Customers AS c
JOIN Orders AS o ON o.CustomerID = c.CustomerID
JOIN OrderDetails AS d ON d.OrderKey = o.OrderKey
JOIN Products AS p ON p.ProductID = d.ProductID
WHERE Profit < 0
ORDER BY Profit;