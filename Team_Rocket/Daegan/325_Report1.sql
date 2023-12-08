-- 325Report.sql
-- Authors: Tony, Cheyenne, Abigail, Tommy, Daegan, Sam, Johnathan
-- CS 325 - Report 1 Project Milestone
-- Date: December 8th, 2023

-- Start output to a file
tee 325_Report1-out.txt

-- Selection 3: Display SKU, item name and total quantity sold, ordered by quantity descending
SELECT 'Selection 3: SKU, item name, and total quantity sold.' AS Description;
SELECT Catalog.SKU, Catalog.itemName, SUM(OrderDetails.quantity) AS TotalSold
FROM Catalog
JOIN OrderDetails ON Catalog.SKU = OrderDetails.SKU
GROUP BY Catalog.SKU
ORDER BY TotalSold DESC;

-- End output to file
notee