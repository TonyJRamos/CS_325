-- teamrocket_populate.sql
-- Sam, Daegan, Tommy, Abigail, Tony, Cheyanne, John
-- CS 325 - Fall 2023
-- 12/4/2023

-- DELETING

DELETE FROM User;
DELETE FROM Customer;
DELETE FROM Address;
DELETE FROM Catalog;
DELETE FROM Orders;
DELETE FROM OrderDetails;
DELETE FROM LineItems;
DELETE FROM Shipping;
DELETE FROM SubscriptionTemplate;
DELETE FROM SubscriptionOrders;

-- Populating User table
INSERT INTO User (userID, username, password, role) VALUES
(1, 'user1', 'pass123', 'admin'),
(2, 'user2', 'pass234', 'standard'),
(3, 'user3', 'pass345', 'standard'),
(4, 'user4', 'pass456', 'standard'),
(5, 'user5', 'pass567', 'standard'),
(6, 'user6', 'pass678', 'standard'),
(7, 'user7', 'pass789', 'standard'),
(8, 'user8', 'pass890', 'standard'),
(9, 'user9', 'pass901', 'standard'),
(10, 'user10', 'pass012', 'standard');

-- Populating Customer table
INSERT INTO Customer (customerID, userID, name, creditCard, city, state, address, zipCode, email) VALUES
(1, 1, 'John Doe', '1234567812345678', 'New York', 'NY', '123 1st Street', '10001', 'johndoe@email.com'),
(2, 2, 'Jane Smith', '2345678923456789', 'Los Angeles', 'CA', '456 2nd Avenue', '90001', 'janesmith@email.com'),
(3, 3, 'Sam Hodgdon', '3456789183049582', 'Arcata', 'CA', '777 Street Street', '92506', 'sqh3@humboldt.edu'),
(4, 4, 'Peter Griffen', '1231231231231231', 'Boston', 'MA', '123 Road Road', '01605', 'petegriff@gmail.com'),
(5, 5, 'Lightning McQueen', '9999999999999999', 'Radiator Springs', 'CA', '1 Car Avenue', '12345', 'kachow@hotmail.com'),
(6, 6, 'Bob Johnson', '8888888888888888', 'New Orleans', 'LA', '3 House Way', '20002', 'johnsonBob@gmail.com'),
(7, 7, 'Katie Brown', '7777777777777777', 'San Diego', 'CA', '14 Cow Court', '92577', 'katie@yahoo.com'),
(8, 8, 'Margret Blue', '1414141414141414', 'Eureka', 'CA', '123 Main Street', '11122', 'blue@gmail.com'),
(9, 9, 'Brian Griffen', '9876598743293049', 'Miami', 'FL', '1212 Broadway', '92333', 'bgriffen@verizon.net'),
(10, 10, 'Professor Oak', '1111111111111111', 'Tampa', 'FL', '7 Pokemon Way', '15342', 'catchthemall@gmail.com');

-- Populating Address table
INSERT INTO Address (addressID, customerID, addressType, addressLine1, addressLine2, city, state, zipCode, country) VALUES
(1, 1, 'Shipping', '123 1st Street', NULL, 'New York', 'NY', '10001', 'USA'),
(2, 2, 'Shipping', '456 2nd Avenue', NULL, 'Los Angeles', 'CA', '90001', 'USA'),
(3, 3, 'Shipping', '777 Street Street', NULL, 'Arcata', 'CA', '92506', 'USA'),
(4, 4, 'Shipping', '123 Road Road', NULL, 'Boston', 'MA', '01605', 'USA'),
(5, 5, 'Shipping', '1 Car Avenue', NULL, 'Radiator Springs', 'CA', '12345', 'USA'),
(6, 6, 'Shipping', '3 House Way', NULL, 'New Orleans', 'LA', '20002', 'USA'),
(7, 7, 'Shipping', '14 Cow Court', NULL, 'San Diego', 'CA', '92577', 'USA'),
(8, 8, 'Shipping', '123 Main Street', NULL, 'Eureka', 'CA', '11122', 'USA'),
(9, 9, 'Shipping', '1212 Broadway', NULL, 'Miami', 'FL', '92333', 'USA'),
(10, 10, 'Shipping', '7 Pokemon Way', NULL, 'Tampa', 'FL', '15342', 'USA');

-- Populating Catalog table
INSERT INTO Catalog (SKU, itemName, itemDescription, price, availableQuantity, imageUrl) VALUES
(1001, 'Item 1', 'Description for Item 1', 19.99, 50, 'http://example.com/item1.jpg'),
(1002, 'Item 2', 'Description for Item 2', 59.97, 11, 'http://example.com/item2.jpg'),
(1003, 'Item 3', 'Description for Item 3', 69.69, 22, 'http://example.com/item3.jpg'),
(1004, 'Item 4', 'Description for Item 4', 79.99, 45, 'http://example.com/item4.jpg'),
(1005, 'Item 5', 'Description for Item 5', 89.99, 99, 'http://example.com/item5.jpg'),
(1006, 'Item 6', 'Description for Item 6', 84.99, 83, 'http://example.com/item6.jpg'),
(1007, 'Item 7', 'Description for Item 7', 15.99, 25, 'http://example.com/item7.jpg'),
(1008, 'Item 8', 'Description for Item 8', 78.99, 64, 'http://example.com/item8.jpg'),
(1009, 'Item 9', 'Description for Item 9', 49.99, 99, 'http://example.com/item9.jpg'),
(1010, 'Item 10', 'Description for Item 10', 11.99, 35, 'http://example.com/item10.jpg');


-- Populating Orders table
INSERT INTO Orders (orderID, customerID, total, tax, orderStatus) VALUES
(1, 1, 59.97, 5.99, 'PENDING'),
(2, 2, 69.69, 6.69, 'SHIPPED'),
(3, 3, 79.99, 7.99, 'INVOICED'),
(4, 4, 89.99, 8.99, 'RETURNED'),
(5, 5, 99.99, 9.99, 'SUBSCRIBED'),
(6, 6, 109.99, 10.99, 'PENDING'),
(7, 7, 119.99, 11.99, 'SHIPPED'),
(8, 8, 129.99, 12.99, 'INVOICED'),
(9, 9, 139.99, 13.99, 'RETURNED'),
(10, 10, 149.99, 14.99, 'SUBSCRIBED');


-- Populating OrderDetails table
INSERT INTO OrderDetails (orderDetailID, orderID, SKU, itemName, itemDescription, quantity, priceAtTimeOfOrder) VALUES
(1, 1, 1001, 'Item 1', 'Description for Item 1', 1, 19.99),
(2, 2, 1002, 'Item 2', 'Description for Item 2', 2, 59.97),
(3, 3, 1003, 'Item 3', 'Description for Item 3', 1, 69.69),
(4, 4, 1004, 'Item 4', 'Description for Item 4', 1, 79.99),
(5, 5, 1002, 'Item 2', 'Description for Item 2', 2, 59.97),
(6, 6, 1003, 'Item 3', 'Description for Item 3', 1, 69.69),
(7, 7, 1004, 'Item 4', 'Description for Item 4', 1, 79.99),
(8, 8, 1005, 'Item 5', 'Description for Item 5', 2, 89.99),
(9, 9, 1006, 'Item 6', 'Description for Item 6', 1, 84.99),
(10, 10, 1007, 'Item 7', 'Description for Item 7', 1, 15.99);


-- Populating LineItems table
INSERT INTO LineItems (lineItemID, orderID, SKU, quantity) VALUES
(1, 1, 1001, 3),
(2, 2, 1002, 2),
(3, 3, 1003, 1),
(4, 4, 1004, 7),
(5, 5, 1002, 5),
(6, 6, 1003, 3),
(7, 7, 1004, 8),
(8, 8, 1005, 2),
(9, 9, 1006, 4),
(10, 10, 1007, 3);


-- Populating Shipment table
INSERT INTO Shipment (shipmentID, lineItemID, status) VALUES
(1, 1, 'PICK'),
(2, 2, 'PACK'),
(3, 3, 'SHIP'),
(4, 4, 'SHIP'),
(5, 5, 'PICK'),
(6, 6, 'PACK'),
(7, 7, 'PACK'),
(8, 8, 'PICK'),
(9, 9, 'SHIP'),
(10, 10, 'PICK');


-- Populating SubscriptionTemplate table
INSERT INTO SubscriptionTemplate (templateID, planName, SKU, frequencyInMonths, price, duration) VALUES
(1, 'Basic Plan', 1001, 1, 9.99, 12),
(2, 'Premium Plan', 1002, 1, 19.99, 6),
(3, 'Basic Plan', 1003, 1, 29.99, 12),
(4, 'Premium', 1002, 1, 69.69, 3),
(5, 'Basic Plan', 1003, 1, 4.99, 24),
(6, 'Basic Plan', 1002, 1, 9.99, 12),
(7, 'Premium Plan', 1003, 1, 10.99, 12),
(8, 'Basic Plan', 1002, 1, 79.99, 6),
(9, 'Basic Plan', 1004, 1, 89.99, 12),
(10, 'Premium Plan', 1005, 1, 25.99, 24);


-- Populating SubscriptionOrders table
INSERT INTO SubscriptionOrders (subscriptionOrderID, templateID, orderID, status, start_time, end_time, planName) VALUES
(1, 1, 1, 'Active', CURRENT_TIMESTAMP, NULL, 'Basic Plan'),
(2, 2, 2, 'Active', CURRENT_TIMESTAMP, NULL, 'Premium Plan'),
(3, 3, 3, 'Active', CURRENT_TIMESTAMP, NULL, 'Basic Plan'),
(4, 4, 4, 'Active', CURRENT_TIMESTAMP, NULL, 'Premium Plan'),
(5, 5, 5, 'Active', CURRENT_TIMESTAMP, NULL, 'Basic Plan'),
(6, 6, 6, 'Active', CURRENT_TIMESTAMP, NULL, 'Basic Plan'),
(7, 7, 7, 'Active', CURRENT_TIMESTAMP, NULL, 'Premium Plan'),
(8, 8, 8, 'Active', CURRENT_TIMESTAMP, NULL, 'Basic Plan'),
(9, 9, 9, 'Active', CURRENT_TIMESTAMP, NULL, 'Basic Plan'),
(10, 10, 10, 'Active', CURRENT_TIMESTAMP, NULL, 'Premium Plan');

