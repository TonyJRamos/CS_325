-- 325queries.sql
-- Authors: Tony, Cheyenne, Abigail, Tommy, Daegan, Sam, Johnathan
-- CS 325 - select-queries Project Milestone
-- Date: December 8th, 2023

-- Start output to a file
tee 325query-results.txt

-- Print header message
SELECT 'Lab 16 Selections' AS Header;
SELECT 'Authors: Tony, Cheyenne, Abigail, Tommy, Daegan, Sam, Johnathan' AS Authors;

-- Selection 1: List all customers with their orders using JOIN
SELECT 'Selection 1: List of all customers with their orders.' AS Description;
SELECT Customer.name, Orders.orderID
FROM Customer
JOIN Orders ON Customer.customerID = Orders.customerID;

-- Selection 2: Find total number of items ordered for each order using a sub-select
SELECT 'Selection 2: Total number of items for each order.' AS Description;
SELECT Orders.orderID, (SELECT SUM(quantity) FROM OrderDetails WHERE OrderDetails.orderID = Orders.orderID) AS TotalItems
FROM Orders;

-- Selection 3: Display SKU, item name and total quantity sold, ordered by quantity descending
SELECT 'Selection 3: SKU, item name, and total quantity sold.' AS Description;
SELECT Catalog.SKU, Catalog.itemName, SUM(OrderDetails.quantity) AS TotalSold
FROM Catalog
JOIN OrderDetails ON Catalog.SKU = OrderDetails.SKU
GROUP BY Catalog.SKU
ORDER BY TotalSold DESC;

-- Selection 4: List users who have made orders totaling over $100 using JOIN and HAVING
SELECT 'Selection 4: Users with orders totaling over $100.' AS Description;
SELECT User.username
FROM User
JOIN Customer ON User.userID = Customer.userID
JOIN Orders ON Customer.customerID = Orders.customerID
GROUP BY User.username
HAVING SUM(Orders.total) > 100;

-- Selection 5: Find items not ordered by any customer using LEFT JOIN and WHERE IS NULL
SELECT 'Selection 5: Items not ordered by any customer.' AS Description;
SELECT Catalog.SKU, Catalog.itemName
FROM Catalog
LEFT JOIN OrderDetails ON Catalog.SKU = OrderDetails.SKU
WHERE OrderDetails.SKU IS NULL;

-- Selection 6: Show all customers who have made an order, sorted by customerID
SELECT 'Selection 6: Customers who have made an order, sorted by customerID.' AS Description;
SELECT DISTINCT Customer.name, Customer.customerID
FROM Customer
JOIN Orders ON Customer.customerID = Orders.customerID
ORDER BY Customer.customerID;

-- Selection 7: Show all customers who have 'Shipping' type addresses using JOIN and WHERE
SELECT 'Selection 7: Customers with Shipping addresses.' AS Description;
SELECT Customer.name, Address.addressLine1
FROM Customer
JOIN Address ON Customer.customerID = Address.customerID
WHERE Address.addressType = 'Shipping';

-- Selection 8: List all orders with item names, concatenating item names for the same order
SELECT 'Selection 8: Orders with concatenated item names.' AS Description;
SELECT Orders.orderID, GROUP_CONCAT(OrderDetails.itemName SEPARATOR ', ') AS Items
FROM Orders
JOIN OrderDetails ON Orders.orderID = OrderDetails.orderID
GROUP BY Orders.orderID;

-- Selection 9: Find customers who have only 'standard' role using a subquery
SELECT 'Selection 9: Customers with only standard role.' AS Description;
SELECT Customer.name
FROM Customer
WHERE NOT EXISTS (
    SELECT * FROM User
    WHERE User.userID = Customer.userID AND User.role <> 'standard'
);

-- Selection 10: Modify view for frequently ordered items
SELECT 'Selection 10: Modify view for frequently ordered items.' AS Description;
CREATE OR REPLACE VIEW FrequentlyOrderedItems AS
SELECT SKU, COUNT(*) AS TimesOrdered
FROM OrderDetails
GROUP BY SKU
HAVING TimesOrdered >= 1;  -- Adjust this threshold based on your data

-- Selection 11: List details of frequently ordered items from the view
SELECT 'Selection 11: Details of frequently ordered items.' AS Description;
SELECT Catalog.SKU, Catalog.itemName, Catalog.itemDescription, Catalog.price, FrequentlyOrderedItems.TimesOrdered
FROM Catalog
JOIN FrequentlyOrderedItems ON Catalog.SKU = FrequentlyOrderedItems.SKU
ORDER BY FrequentlyOrderedItems.TimesOrdered DESC;

-- End output to file
notee