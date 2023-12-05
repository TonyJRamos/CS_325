-- 325show-contents.sql
-- Sam, Daegan, Tommy, Abigail, Tony, Cheyanne, John
-- CS 325 - Fall 2023
-- 12/4/2023

spool 325result-contents.txt

SELECT * FROM User;
SELECT *  FROM Customer;
SELECT *  FROM Address;
SELECT *  FROM Catalog;
SELECT *  FROM Orders;
SELECT *  FROM OrderDetails;
SELECT *  FROM LineItems;
SELECT *  FROM Shipping;
SELECT *  FROM SubscriptionTemplate;
SELECT *  FROM SubscriptionOrders;

spool off

