SELECT
	SUM(quantityOrdered) AS total_ordered
 FROM products_sales;
 -- Totally 105516 items were ordered
-- Identify Top-Ordered Products
SELECT
	productCode,
    productName,
    productLine,
    SUM(quantityOrdered) AS total_ordered
FROM products_sales
GROUP BY productCode, productName, productline
ORDER BY 4 DESC;
-- '1992 Ferrari 360 Spider red' is most ordered(1808 items). And '1985 Toyota Supra' wasn't ordered any times at period 2003.01.06 - 2025.05.31
-- Percentage of productlines were ordered
SELECT
	productLine,
    ROUND((SUM(quantityOrdered)/105516)*100) AS pct_sales
FROM products_sales
GROUP BY productLine
ORDER BY 2 DESC;
-- Classic cars (34%) and Vintage cars (22%) are most in demand. And orders of trains account for only 3%
