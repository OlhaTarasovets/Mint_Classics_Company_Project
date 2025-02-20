USE mintclassics;
CREATE VIEW products_sales AS
SELECT p.productCode,
	   p.productName,
       p.productLine,
       p.quantityInStock,
       od.priceEach,
       od.orderNumber,
       o.orderDate,
       o.shippedDate,
       o.status,
       w.warehouseCode, 
       w.warehouseName
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
LEFT JOIN orders o ON od.orderNumber = o.orderNumber
LEFT JOIN warehouses w ON p.warehouseCode = w.warehouseCode;