-- Inspection of data --
USE mintclassics;
-- Checking for missing rows and dublicates --
SELECT 
    COUNT(*) AS total_rec,
    COUNT(DISTINCT customerName) AS num_customers
   FROM
    customers;
-- There are no dublicates of total 122 customers 
SELECT *
FROM orderdetails
WHERE orderNumber IS NULL
	  OR productCode IS NULL;
-- There are no missing values 
SELECT *
FROM orders
WHERE orderNumber IS NULL
	OR customerNumber IS NULL;
-- There are no missing records in table "orders"
SELECT
	COUNT(DISTINCT orderNumber) AS total_orders
FROM orderdetails;
-- 326 orders were placed 
SELECT
	status,
	COUNT(orderNumber) AS num_of_orders,
    ROUND((COUNT(orderNumber)/326)*100,2) AS pct_of_orders
FROM orders
GROUP BY status
ORDER BY num_of_orders DESC;
-- 303 orders were shipped. This is 92.94% of all orders 
-- Checking what client made more payments --
SELECT
	c.customerName,
	COUNT(checkNumber) AS num_payments,
    SUM(amount) AS amount_by_customer
FROM payments p
LEFT JOIN customers c ON p.customerNumber = c.customerNumber
GROUP BY customerName
ORDER BY amount_by_customer DESC;
-- How many distinct products the Mint Classics carries
SELECT
	COUNT(productCode) AS num_products
FROM products;
-- There are 110 products 
SELECT
	productLine,
    COUNT(productCode) AS num_products,
    ROUND((COUNT(productCode)/110)*100,2) AS pct_of_products
FROM products
GROUP BY productLine
ORDER BY 2 DESC;
-- Classic and vintage cars account for more than 50% of all lines
-- Count number of total products in stock --
SELECT
	SUM(quantityInStock) AS total_stock
FROM products;
-- There are a total of 555,131 items in stock
-- Percentage of products are in stock at each warehouse --
SELECT 
    warehouseName,
    productLine,
    COUNT(productCode) AS num_products,
    ROUND((COUNT(productCode)/110)*100,2) AS pct_of_products
FROM
    products p
INNER JOIN warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY warehouseName, productLine
ORDER BY 4 DESC
-- Warehouse B holds 34.55% of products, which is the highest figure among all warehouses
