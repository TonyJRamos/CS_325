-- 325Report2.sql
-- Authors: Tony, Cheyenne, Abigail, Tommy, Daegan, Sam, Johnathan
-- CS 325 - Report 2 Project Milestone
-- Date: December 8th, 2023

-- Start output to a file
tee 325_Report2-out.txt
 
-- Selection 6: Show all customers who have made an order, sorted by customerID
SELECT 'Selection 6: Customers who have made an order, sorted by customerID.' AS Description;
SELECT DISTINCT Customer.name, Customer.customerID
FROM Customer
JOIN Orders ON Customer.customerID = Orders.customerID
ORDER BY Customer.customerID;

-- End output to file
notee