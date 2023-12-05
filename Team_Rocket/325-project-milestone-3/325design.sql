/*---
   Team Rocket

   Abigail Penland, Cheyenne Ty, Tony White-Ramos, Tommy Le, 
   Samuel Hodgdon, Daegan Hammond, and Jonathan Thang

   CS 325 - Fall 2023

   Last modified: 11/17/2023
---*/

CREATE TABLE User (
    userID INT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(10) DEFAULT 'standard'
);

CREATE TABLE Customer (
    customerID INT PRIMARY KEY,
    userID INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    creditCard VARCHAR(19),
    city VARCHAR(255),
    state VARCHAR(255),
    address VARCHAR(255),
    zipCode VARCHAR(10),
    email VARCHAR(255) UNIQUE,
    FOREIGN KEY (userID) REFERENCES User(userID)
);

CREATE TABLE Address (
    addressID INT PRIMARY KEY,
    customerID INT NOT NULL,
    addressType ENUM('Shipping', 'Billing') NOT NULL,
    addressLine1 VARCHAR(255) NOT NULL,
    addressLine2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zipCode VARCHAR(10),
    country VARCHAR(100),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Catalog (
    SKU INT PRIMARY KEY,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    price DECIMAL(10,2) NOT NULL,
    availableQuantity INT NOT NULL,
    imageUrl VARCHAR(512)
);

CREATE TABLE Orders (
    orderID INT PRIMARY KEY,
    customerID INT NOT NULL,
    total DECIMAL(10,2),
    tax DECIMAL(10,2),
    orderStatus ENUM('PENDING', 'SHIPPED', 'INVOICED', 'RETURNED', 'SUBSCRIBED'),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE OrderDetails (
    orderDetailID INT PRIMARY KEY,
    orderID INT NOT NULL,
    SKU INT NOT NULL,
    itemName VARCHAR(255) NOT NULL,
    itemDescription TEXT,
    quantity INT NOT NULL,
    priceAtTimeOfOrder DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (SKU) REFERENCES Catalog(SKU)
);

CREATE TABLE Shipment (
    shipmentID INT PRIMARY KEY,
    lineItemID INT NOT NULL,
    status ENUM('PICK', 'PACK', 'SHIP'),
    FOREIGN KEY (lineItemID) REFERENCES LineItems(lineItemID)
);

CREATE TABLE SubscriptionTemplate (
    templateID INT PRIMARY KEY,
    planName VARCHAR(255) NOT NULL,
    SKU INT NOT NULL,
    frequencyInMonths INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    duration INT NOT NULL,
    FOREIGN KEY (SKU) REFERENCES Catalog(SKU)
);

CREATE TABLE SubscriptionOrders (
    subscriptionOrderID INT PRIMARY KEY,
    templateID INT,
    orderID INT,
    status VARCHAR(100) DEFAULT 'Active',
    start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    end_time DATETIME,
    planName VARCHAR(255),
    FOREIGN KEY (templateID) REFERENCES SubscriptionTemplate(templateID),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);