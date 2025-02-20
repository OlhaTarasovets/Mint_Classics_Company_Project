-- Inventory Turnover Ratio
WITH total_sales AS (
	SELECT ps.warehouseCode, ps.warehouseName,
		   SUM(ps.quantityOrdered*p.buyPrice) AS total_cogs
	FROM products_sales ps
	RIGHT JOIN products p ON p.productCode = ps.productCode
	WHERE shippedDate IS NOT NULL
	GROUP BY ps.warehouseCode, ps.warehouseName
),
average_inventory AS (
	SELECT ps.warehouseCode, AVG(ps.quantityInStock*p.buyPrice) AS avg_inventory_value
    FROM products_sales ps
    RIGHT JOIN products p ON p.productCode = ps.productCode
    GROUP BY ps.warehouseCode
)
SELECT ts.warehouseCode, ts.warehouseName, ts.total_cogs, ai.avg_inventory_value,
	   (ts.total_cogs/NULLIF(ai.avg_inventory_value,0)) AS turnover_ratio
FROM total_sales ts
LEFT JOIN average_inventory ai ON ts.warehouseCode = ai.warehouseCode
ORDER BY turnover_ratio ASC;
-- Stock-to-Demand Ratio
WITH stock_levels AS (
    SELECT ps.warehouseCode, ps.warehouseName, 
           SUM(ps.quantityInStock) AS total_stock
    FROM products_sales ps
    GROUP BY ps.warehouseCode, ps.warehouseName
),
demand_levels AS (
    SELECT ps.warehouseCode, 
           SUM(ps.quantityOrdered) AS total_demand
    FROM products_sales ps
    GROUP BY ps.warehouseCode
)
SELECT sl.warehouseCode, sl.warehouseName, 
       sl.total_stock, dl.total_demand, 
       COALESCE(sl.total_stock, 0) AS total_stock, 
       COALESCE(dl.total_demand, 0) AS total_demand,
       (COALESCE(sl.total_stock, 0) / NULLIF(dl.total_demand, 0)) AS stock_to_demand_ratio
FROM stock_levels sl
LEFT JOIN demand_levels dl ON sl.warehouseCode = dl.warehouseCode
ORDER BY stock_to_demand_ratio DESC;