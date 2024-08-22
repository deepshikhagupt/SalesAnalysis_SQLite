SELECT 'Customers' AS table_name, 
       13 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Customers
  
UNION ALL

SELECT 'Products' AS table_name, 
       9 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Products

UNION ALL

SELECT 'ProductLines' AS table_name, 
       4 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM ProductLines

UNION ALL

SELECT 'Orders' AS table_name, 
       7 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Orders

UNION ALL

SELECT 'OrderDetails' AS table_name, 
       5 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM OrderDetails

UNION ALL

SELECT 'Payments' AS table_name, 
       4 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Payments

UNION ALL

SELECT 'Employees' AS table_name, 
       8 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Employees

UNION ALL

SELECT 'Offices' AS table_name, 
       9 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Offices;
  
-- Question : Which products should we order more of or less of?
-- low stock and product performance --optimize the supply and the user experience 
-- by preventing the best-selling products from going out-of-stock

-- find lowest ten stocked products 
SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0 / (SELECT quantityInStock
                                             FROM products p
                                            WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock
 LIMIT 10;
 
-- PRODUCT PERFOMANCE - TOP 10 BESTSELLERS
SELECT productCode , ROUND(SUM(quantityOrdered*priceEach),2) as product_perfomance
FROM orderdetails 
GROUP BY productCode
ORDER BY product_perfomance DESC
LIMIT 10;

--SELECT productCode , productine

-- Display priority products (low stock and best selling )
WITH 

low_stock_table AS (
SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0/(SELECT quantityInStock
                                           FROM products p
                                          WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock
 LIMIT 10
)

SELECT productCode, 
       SUM(quantityOrdered * priceEach) AS prod_perf
  FROM orderdetails od
 WHERE productCode IN (SELECT productCode
                         FROM low_stock_table)
 GROUP BY productCode 
 ORDER BY prod_perf DESC
 LIMIT 10;
 
 
 -- QUESTION : How Should We Match Marketing and Communication Strategies to Customer Behavior?
 -- TOP 5 VIP customers
 WITH profitcust as
 (SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
 )
 
 SELECT c.contactLastName , c.contactFirstName , c.city , c.country , pc.profit
 FROM customers c
 JOIN profitcust pc
 ON c.customerNumber = pc.customerNumber
 ORDER BY pc.profit DESC
 LIMIT 5; 
 
 -- TOP 5 LEAST ENGAGING
  WITH profitcust as
 (SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
 )
 SELECT c.contactLastName , c.contactFirstName , c.city , c.country , pc.profit
 FROM customers c
 JOIN profitcust pc
 ON c.customerNumber = pc.customerNumber
 ORDER BY pc.profit 
 LIMIT 5;

 
 