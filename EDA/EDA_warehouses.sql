-- Check Inventory Levels Per Warehouse
SELECT warehouseName, SUM(quantityInStock) AS totalInventory
FROM products_sales
GROUP BY warehouseName
ORDER BY totalInventory ASC;
-- Warehouse South has lowest inventory level
-- Sales Volume Per Warehouse
SELECT 
	warehouseName,
    COUNT(orderNumber) AS total_orders,
    SUM(quantityOrdered*priceEach) AS total_revenue
FROM products_sales
WHERE shippedDate IS NOT NULL
GROUP BY warehouseName
ORDER BY total_revenue ASC;
-- Slow-Moving Products Per Warehouse
SELECT FLOOR(COUNT(DISTINCT productCode) * 0.1) AS offset_value
FROM products_sales; -- to find OFFSET. OFFSET is 11

SELECT SUM(quantityOrdered) AS total_sold
FROM products_sales
GROUP BY productCode
ORDER BY total_sold
LIMIT 1 OFFSET 11; -- bottom 10% of sales is under 883
-- Use this number(883) in HAVING clause to definy the worst-selling products
SELECT
	warehouseName,
    productCode,
    productName,
    SUM(quantityOrdered) AS total_sold,
    quantityInStock
FROM products_sales
WHERE shippedDate IS NOT NULL
GROUP BY warehouseName, productCode, productName, quantityInStock
HAVING total_sold <= 883
ORDER BY total_sold ASC;
-- Warehouse Profitability
SELECT
	warehouseName,
    SUM(ps.quantityOrdered*ps.priceEach) AS revenue,
    SUM(ps.quantityOrdered*p.buyPrice) AS COGS,
    SUM(ps.quantityOrdered*ps.priceEach)-SUM(ps.quantityOrdered*p.buyPrice) AS profit
FROM products_sales ps
RIGHT JOIN products p ON p.productCode = ps.productCode
WHERE shippedDate IS NOT NULL
GROUP BY warehouseName
ORDER BY profit ASC;
-- Warehouse South has the least profit
-- Order Distribution by Warehouse
SELECT ps.warehouseName, 
       COUNT(DISTINCT o.customerNumber) AS customers, 
       COUNT(ps.orderNumber) AS total_orders, 
       SUM(ps.quantityOrdered) AS total_items_sold,
       w.warehousePctCap
FROM products_sales ps
RIGHT JOIN warehouses w ON ps.warehouseName = w.warehouseName
RIGHT JOIN orders o ON ps.orderNumber = o.orderNumber
WHERE ps.shippedDate IS NOT NULL
GROUP BY ps.warehouseName, w.warehousePctCap
ORDER BY customers ASC;
