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