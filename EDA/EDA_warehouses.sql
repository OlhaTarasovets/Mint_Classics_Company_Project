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
