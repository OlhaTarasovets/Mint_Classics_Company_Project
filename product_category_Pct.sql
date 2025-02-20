WITH category_totals AS (
    SELECT
        warehouseCode,
        warehouseName,
        product_category,
        SUM(total_sold) AS category_total_sold
	FROM (
			SELECT warehouseCode, warehouseName, productCode, productName, 
					SUM(quantityOrdered) AS total_sold,
			CASE 
			WHEN SUM(quantityOrdered) >= (
               SELECT total_sold FROM (
                   SELECT total_sold, NTILE(4) OVER (ORDER BY total_sold DESC) AS quartile
                   FROM (
                       SELECT productCode, SUM(quantityOrdered) AS total_sold
                       FROM products_sales
                       GROUP BY productCode
                   ) AS sales_data
               ) AS quartile_data WHERE quartile = 3 LIMIT 1
           ) THEN 'Fast-Moving'
           WHEN SUM(quantityOrdered) <= (
               SELECT total_sold FROM (
                   SELECT total_sold, NTILE(4) OVER (ORDER BY total_sold DESC) AS quartile
                   FROM (
                        SELECT productCode, SUM(quantityOrdered) AS total_sold
                       FROM products_sales
                       GROUP BY productCode
                   ) AS sales_data
               ) AS quartile_data WHERE quartile = 1 LIMIT 1
           ) THEN 'Slow-Moving'
           ELSE 'Moderate'
		END AS product_category
	FROM products_sales
	WHERE shippedDate IS NOT NULL
	GROUP BY productCode) AS product_category
GROUP BY warehouseCode, product_category
),
warehouse_totals AS (
	SELECT warehouseCode, SUM(quantityOrdered) AS warehouse_total_sold
    FROM products_sales
    WHERE shippedDate IS NOT NULL
    GROUP BY warehouseCode
)
SELECT
    ct.warehouseCode,
    ct.warehouseName,
    ct.product_category,
    ct.category_total_sold,
    ROUND((ct.category_total_sold / wt.warehouse_total_sold * 100),0) AS categoryPct
FROM category_totals ct
JOIN warehouse_totals wt ON ct.warehouseCode = wt.warehouseCode
ORDER BY ct.warehouseCode, ct.product_category;
	