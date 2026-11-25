-- Retail Sales SQL Assessment
-- Database engine: MySQL 8.0
-- Platform: DB Fiddle (Online SQL Playground)
-- Run this first, then import/insert the supplied assessment dataset.
-- NOTE: The source dataset was not included in the files uploaded for packaging.
-- Orders.CustomerID is intentionally not constrained as an FK because the assessment
-- explicitly includes an unmatched customer ID (Order 1006 -> CustomerID 99).

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    SignupDate DATE
);

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    RegionRaw VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INT,
    StoreID INT NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_store FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

-- Raw staging table intentionally permits duplicate OrderItemID rows.
CREATE TABLE OrderItems (
    OrderItemID INT NOT NULL,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(12,2) NOT NULL,
    LoadedAt DATETIME NOT NULL
);

CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    OrderItemID INT NOT NULL,
    ReturnDate DATE NOT NULL,
    ReturnQuantity INT NOT NULL
);
