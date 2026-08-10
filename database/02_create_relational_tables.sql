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