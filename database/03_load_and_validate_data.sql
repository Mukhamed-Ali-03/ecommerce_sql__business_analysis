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