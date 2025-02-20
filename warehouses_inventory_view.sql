CREATE OR REPLACE VIEW north AS
SELECT 
    p.productName,
    p.productLine,
    p.quantityInStock,
    SUM(quantityOrdered) AS total_ordered,
    p.warehouseCode
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE p.warehouseCode = 'a'
GROUP BY p.productName, p.productLine, p.quantityInStock, p.warehouseCode;

CREATE OR REPLACE VIEW east AS
SELECT 
    p.productName,
    p.productLine,
    p.quantityInStock,
    SUM(quantityOrdered) AS total_ordered,
    p.warehouseCode
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE p.warehouseCode = 'b'
GROUP BY p.productName, p.productLine, p.quantityInStock, p.warehouseCode;

CREATE OR REPLACE VIEW west AS
SELECT 
    p.productName,
    p.productLine,
    p.quantityInStock,
    SUM(quantityOrdered) AS total_ordered,
    p.warehouseCode
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE p.warehouseCode = 'c'
GROUP BY p.productName, p.productLine, p.quantityInStock, p.warehouseCode;

CREATE OR REPLACE VIEW south AS
SELECT 
    p.productName,
    p.productLine,
    p.quantityInStock,
    SUM(quantityOrdered) AS total_ordered,
    p.warehouseCode
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE p.warehouseCode = 'd'
GROUP BY p.productName, p.productLine, p.quantityInStock, p.warehouseCode;


