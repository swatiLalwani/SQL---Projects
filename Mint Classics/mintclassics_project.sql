## Data Profiling
#SELECT * FROM mintclassics.customers
#SELECT * FROM mintclassics.employees
#SELECT * FROM mintclassics.offices
#SELECT * FROM mintclassics.orders
#SELECT * FROM mintclassics.orderdetails
#SELECT * FROM mintclassics.payments
#SELECT * FROM mintclassics.productlines
#SELECT * FROM mintclassics.products
#SELECT * FROM mintclassics.warehouses

#Checking Duplicates of customers
#Select Distinct * From mintclassics.customers  
#Select COUNT(DISTINCT(customerName))From mintclassics.customers   
#SELECT COUNT(customerName) FROM mintclassics.customers
#SELECT customerName, COUNT(*) FROM mintclassics.customers GROUP BY customerName

#Checking Duplicates of employees
#Select Distinct * From mintclassics.employees  
#Select COUNT(DISTINCT(firstName))From mintclassics.employees  
#SELECT COUNT(firstName) FROM mintclassics.employees
#SELECT firstName,lastName, COUNT(*) FROM mintclassics.employees GROUP BY firstName,lastName

#Checking Duplicates of offices
#Select Distinct * From mintclassics.offices 
#Select COUNT(DISTINCT(addresses))From mintclassics.offices  
#SELECT COUNT(addresses) FROM mintclassics.offices
#SELECT addresses, COUNT(*) FROM mintclassics.offices GROUP BY addresses

#Checking Duplicates of orders
#Select Distinct * From mintclassics.orders  
#Select COUNT(DISTINCT(orderNumber))From mintclassics.orders  
#SELECT COUNT(orderNumber) FROM mintclassics.orders
#SELECT orderNumber, COUNT(*) FROM mintclassics.orders GROUP BY orderNumber

#Checking Duplicates of orderdetails
#Select Distinct * From mintclassics.orderdetails  
#Select COUNT(DISTINCT(orderNumber))From mintclassics.orderdetails 
#SELECT COUNT(orderNumber) FROM mintclassics.orderdetails
#SELECT orderNumber, COUNT(*) FROM mintclassics.orderdetails GROUP BY productCode

#Checking Duplicates of payments
#Select Distinct * From mintclassics.payments  
#Select COUNT(DISTINCT(checkNumber))From mintclassics.payments  
#SELECT COUNT(checkNumber) FROM mintclassics.payments
#SELECT checkNumber, COUNT(*) FROM mintclassics.payments GROUP BY checkNumber

#Checking Duplicates of productlines
#Select Distinct * From mintclassics.productlines
#Select COUNT(DISTINCT(productLine))From mintclassics.productlines  
#SELECT COUNT(productLine) FROM mintclassics.productlines
#SELECT productLine, COUNT(*) FROM mintclassics.productlines GROUP BY productLine 

#Checking Duplicates of products
#Select Distinct * From mintclassics.products  
#Select COUNT(DISTINCT(productCode))From mintclassics.products 
#SELECT COUNT(productCode) FROM mintclassics.products
#SELECT productCode, COUNT(*) FROM mintclassics.products GROUP BY productCode

#Checking Duplicates of warehouses
#Select Distinct * From mintclassics.warehouses  
#Select COUNT(DISTINCT(warehouseCode))From mintclassics.warehouses  
#SELECT COUNT(warehouseCode) FROM mintclassics.warehouses
#SELECT warehouseCode, COUNT(*) FROM mintclassics.warehouses GROUP BY warehouseCode

## Cleaning Data
#ALTER TABLE mintclassics.customers ADD addresses Varchar(255)
#UPDATE mintclassics.customers SET addresses = CONCAT(COALESCE (addressLine1,''),',',(COALESCE(addressLine2,''))) #Joining address1 and address2
#ALTER TABLE mintclassics.offices ADD addresses Varchar(255)
#UPDATE mintclassics.offices SET addresses = CONCAT(COALESCE (addressLine1,''),',',(COALESCE(addressLine2,''))) #Joining address1 and address2
#ALTER  TABLE mintclassics.warehouses ADD warehousePctCap1 BIGINT
#UPDATE mintclassics.warehouses SET warehousePctCap1 = warehousePctCap # Changed data type of the column
#ALTER TABLE mintclassics.warehouses DROP warehousePctCap 

## Analyzing Data

#Q1 Exploring products in Inventory
SELECT productCode,productName,productLine,quantityInStock, warehouses.warehouseCode 
FROM mintclassics.warehouses warehouses 
RIGHT JOIN mintclassics.products products 
ON warehouses.warehouseCode = products.warehouseCode
ORDER BY quantityInStock DESC;

#Observation - motorcycles(productName 2002 Suzuki XREO) are highest in stock whereas Motorcycles(1960 BSA GOLD STAR DBD34) are lowest in stock both are in Warehouse code a.


#Q2 exploring which produtline is in which Warehouse area
SELECT productLine,warehouses.warehouseCode,warehouseName
FROM mintclassics.warehouses warehouses 
RIGHT JOIN mintclassics.products products 
ON warehouses.warehouseCode = products.warehouseCode
GROUP BY productLine, warehouses.warehouseName, warehouses.warehouseCode

#Observation - Motorcycles and planes are in the North, Classic Cars are in the East, Vintage Cars are in the West, Ships and Trains are in the South.

#Q3 Exploring Which Warehouse has the highest and lowest Inventory in Stock
SELECT sum(quantityInStock) TotalQuantityInStock,warehouseName
FROM mintclassics.warehouses warehouses 
RIGHT JOIN mintclassics.products products 
ON warehouses.warehouseCode = products.warehouseCode
GROUP BY warehouses.warehouseName

#Observation - North region has the highest inventory in stock and West has the lowest Inventory in Stock.

#Q4 Which products are highest and lowest in the Inventory? 
SELECT productLine,sum(quantityInStock)TotalQuantityInStock
FROM mintclassics.warehouses warehouses 
RIGHT JOIN mintclassics.products products 
ON warehouses.warehouseCode = products.warehouseCode
GROUP BY productLine
ORDER BY TotalQuantityInStock Desc;

#Observation - Clasic cars have highest stock in inventory and trains have the lowest

#Q5 Which Products are Ordered in How much Quantity?
SELECT productLine,orderdetails.productCode,sum(quantityOrdered) totalOrdered
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY productLine,orderdetails.productCode

#Q6 Which are the TOP 10 highest ordered products?
SELECT productLine,orderdetails.productCode,sum(quantityOrdered) TotalOrderedProducts
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY productLine,orderdetails.productCode
ORDER BY sum(quantityOrdered) DESC Limit 10


#Q7 Which 10 are the lowest ordered products?
SELECT productLine,orderdetails.productCode,sum(quantityOrdered) TotalOrderedProducts
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY productLine,orderdetails.productCode
ORDER BY sum(quantityOrdered) Limit 10

#Q8 Which products have high stock but low sales?
SELECT productLine,productName,orderdetails.productCode,quantityInStock,sum(quantityOrdered) totalOrdered,(quantityInStock - sum(quantityOrdered) ) AS lowInventory
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY  productLine,orderdetails.productCode,quantityInStock
ORDER BY  lowInventory DESC;

#Q9 Calculating Inventory Turnover rate
SELECT products.productName,products.productCode,sum(orderdetails.quantityOrdered)/(products.quantityInStock) AS inventoryTurnOverRate
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY  products.productCode,products.productName
ORDER BY  inventoryTurnOverRate DESC;

#Q10 Which products are ordered from which warehouse?
SELECT productLine,orderdetails.productCode,sum(quantityOrdered) totalOrdered, warehouseCode
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY productLine,orderdetails.productCode,warehouseCode

#Q11 Identifying which warehouses are underutilized or overutilized?
SELECT warehouses.warehouseCode, warehouses.warehouseName, warehouses.warehousePctCap1,SUM(products.quantityInStock) AS totalInventory
FROM warehouses 
JOIN products  ON warehouses.warehouseCode = products.warehouseCode
GROUP BY warehouses.warehouseCode, warehouses.warehouseName, warehouses.warehousePctCap1
ORDER BY totalInventory DESC;

#Q12 Which Warehouse has the highest ordered products?
SELECT productLine,orderdetails.productCode,sum(quantityOrdered) TotalOrderedProducts,warehouseCode
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY productLine,orderdetails.productCode,warehouseCode
ORDER BY sum(quantityOrdered) DESC Limit 25

#Q13 Which Warehouse has the lowest ordered products?
SELECT productLine,orderdetails.productCode,sum(quantityOrdered) TotalOrderedProducts,warehouseCode
FROM mintclassics.orderdetails
LEFT JOIN mintclassics.products
ON orderdetails.productCode = products.productCode
GROUP BY productLine,orderdetails.productCode,warehouseCode
ORDER BY sum(quantityOrdered) Limit 30

#Q14 Which Warehouse has low activity and see if we can remove any?
SELECT warehouses.warehouseCode,warehouseName,sum(quantityInStock) totalStock
FROM mintclassics.products
LEFT JOIN mintclassics.warehouses
ON products.warehouseCode = warehouses.warehouseCode
GROUP BY warehouseCode,warehouseName
ORDER BY sum(quantityInStock) DESC;


#Looking at product sales
#Q15 Which products are not moving in the Inventory?

USE mintclassics

WITH t1
AS

(SELECT orderNumber,payments.customerNumber,amount,status
FROM mintclassics.orders
RIGHT JOIN mintclassics.payments
ON orders.customerNumber = payments.customerNumber
GROUP BY payments.customerNumber,orderNumber,amount,status)


/*These products have lowest order rate and are not moving from the inventory*/
USE mintclassics;

SELECT t5.productLine, t5.productCode, t5.RateOfOrder
FROM

(SELECT DISTINCT t3.productLine, t3.productCode, (t2.quantityOrdered/t3.quantityInStock)*100 AS RateOfOrder
FROM orderdetails t2
LEFT JOIN 
	(SELECT orderNumber,payments.customerNumber,amount,status
	FROM mintclassics.orders
	RIGHT JOIN mintclassics.payments
	ON orders.customerNumber = payments.customerNumber
	GROUP BY payments.customerNumber,orderNumber,amount,status) t1
ON t2.orderNumber = t1.orderNumber

LEFT JOIN products t3
ON t2.productCode = t3.productCode 

LEFT JOIN warehouses t4
ON t4.warehouseCode = t3.warehouseCode) T5

WHERE t5.RateOfOrder < 10
ORDER BY RateOfOrder DESC;

#Q16 Identifying customers and products they ordered
USE mintclassics

WITH t1
AS

(SELECT customers.customerNumber,customerName,status,COUNT(orderNumber) TotalOrders,orderNumber
FROM mintclassics.customers LEFT JOIN mintclassics.orders
ON customers.customerNumber = orders.customerNumber
GROUP BY customers.customerNumber,customerName,status,orderNumber)

#These products were ordered by customers
USE mintclassics;

SELECT t1.customerNumber, t1.customerName, t2.orderNumber, t2.productCode

FROM orderdetails t2
LEFT JOIN 
	(SELECT customers.customerNumber,customerName,status,COUNT(orderNumber) TotalOrders,orderNumber
FROM mintclassics.customers LEFT JOIN mintclassics.orders
ON customers.customerNumber = orders.customerNumber
GROUP BY customers.customerNumber,customerName,status,orderNumber) t1
ON t2.orderNumber = t1.orderNumber

LEFT JOIN products t3
ON t2.productCode = t3.productCode 

#Q17 Identifying Customers with Highest orders
SELECT customers.customerNumber, customers.customerName,COUNT(*) AS totalOrders,SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered
FROM customers 
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY customers.customerNumber, customers.customerName
ORDER BY totalOrders DESC;
 
#Q18 Identifying if there is any relationship between price of the product and sales?
SELECT orderNumber,priceEach,sum(quantityOrdered) as TotalSales
FROM orderdetails
GROUP BY OrderNumber,priceEach
ORDER BY TotalSales DESC;

#Q19 Calculating Total Sales Revenuefor Each product
SELECT products.productCode, products.productName,SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalRevenue
FROM products 
JOIN orderdetails  ON products.productCode = orderdetails.productCode
GROUP BY products.productCode, products.productName
ORDER BY totalRevenue DESC;

#Q20 Identifying products with low sales Volume
SELECT products.productCode, products.productName,SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered
FROM products 
LEFT JOIN orderdetails  ON products.productCode = orderdetails.productCode
GROUP BY products.productCode, products.productName
HAVING totalQuantityOrdered IS NULL OR totalQuantityOrdered = 0
ORDER BY products.productCode;

#Q21 Analyzing Sales by productline
SELECT productlines.productLine,SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered,SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalRevenue
FROM products 
JOIN orderdetails ON products.productCode = orderdetails.productCode
JOIN productlines ON products.productLine = productlines.productLine
GROUP BY productlines.productLine;

#Q22 Identifying Seasonal Variations in Sales
SELECT YEAR(orders.orderDate) AS orderYear, MONTH(orders.orderDate) AS orderMonth,COUNT(*) AS totalOrders, SUM(orderdetails.quantityOrdered) AS TotalQuantityOrdered
FROM orders 
JOIN orderdetails
ON orders.orderNumber = orderdetails.orderNumber
GROUP BY orderYear,orderMonth
ORDER BY orderYear,orderMonth

#Q23. Are there products with high inventory but low sales? How can we optimize the inventory of these products?

WITH inventory_custom_table
AS
(
		SELECT 
            p.productCode, 
            p.productName, 
            p.quantityInStock, 
            SUM(od.quantityOrdered) AS totalOrdered
        FROM 
            mintclassics.products AS p
        LEFT JOIN 
            mintclassics.orderdetails AS od ON p.productCode = od.productCode
        GROUP BY 
            p.productCode, 
            p.productName, 
            p.quantityInStock
)
SELECT 
    productCode, 
    productName, 
    quantityInStock, 
    totalOrdered, 
    (quantityInStock - totalOrdered) AS vehicles_left_in_inventory
FROM inventory_custom_table

WHERE 
    (quantityInStock - totalOrdered) > 0
ORDER BY 
    vehicles_left_in_inventory DESC;

#Observation
## S12_2823 |'2002 Suzuki XREO' has the highest inventory with 8969 vehices left while; 
## S50_1392 |'Diamond T620 Semi-Skirted Tanker' has the lowest inventory with 37 vehicles left..

#Q24 Are all the warehouses currently in use still necessary? How can we review warehouses with low or inactive inventory?
WITH Products_with_high_inventory_in_warehouses
AS
(
		SELECT
			p.productCode,
			p.productName,
			w.warehouseName,
			SUM(p.quantityInStock) AS totalInventory,
			RANK () OVER (PARTITION BY w.warehouseName ORDER BY SUM(p.quantityInStock) DESC) Rank_in_warehouse_for_high_inventory
            
		FROM
			mintclassics.products AS p
		JOIN
			mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode
		GROUP BY
			p.productCode, p.productName, w.warehouseName
		HAVING totalInventory >=1000
		ORDER BY
			totalInventory asc
),

totalRevenue

AS
(
SELECT products.productCode, products.productName,SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalRevenue

FROM products 

JOIN orderdetails  ON products.productCode = orderdetails.productCode

GROUP BY products.productCode, products.productName

ORDER BY totalRevenue DESC
);

SELECT *

FROM Products_with_high_inventory_in_warehouses

WHERE Rank_in_warehouse_for_high_inventory <= 10

ORDER BY Rank_in_warehouse_for_high_inventory asc

#Observation
## S24_2000 |'1960 BSA Gold Star DBD34' in the 'North Warehouse' has lowest inventory of 15 vehicels while;
## S12_2823 |'2002 Suzuki XREO' in the 'North Warehouse' has highest inventory of 9997 vehicles..
## These are the top 12 vehicles having lowest inventory ranked by their total inventory in each warehouse 
## We can remove these vehicles from the inventory 

#Q25 Recognizing valuable customers need special attention 

SELECT
    c.customerNumber,
    c.customerName,
    count(o.orderNumber) AS totalSales
FROM
    mintclassics.customers AS c
JOIN
    mintclassics.orders AS o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber, c.customerName
order by
	totalSales desc

#Observation
##Euro+ Shopping Channel is the most valuable customer with total sales of 26 vehicles
 
#Q26 Evaluating Sales Team performance to drive efficiency
 
SELECT
    e.employeeNumber,
    e.lastName,
    e.firstName,
    e.jobTitle,
    SUM(od.priceEach * od.quantityOrdered) AS totalSales
FROM
    mintclassics.employees AS e
LEFT JOIN
    mintclassics.customers AS c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN
    mintclassics.orders AS o ON c.customerNumber = o.customerNumber
LEFT JOIN
    mintclassics.orderdetails AS od ON o.orderNumber = od.orderNumber
GROUP BY
    e.employeeNumber, e.lastName, e.firstName, e.jobTitle
HAVING e.jobTitle = 'Sales Rep' AND (SUM(od.priceEach * od.quantityOrdered) <=1000 OR SUM(od.priceEach * od.quantityOrdered) IS NULL)
order by
	totalSales desc

#Observation
##Sales Representative 1370 | Gerard Hernandez has made highest total sale of 1258577.81
##Sales Representative 1619| Tom King and 1625 | Yoshimi Kato have both not made any sales and thus have poor perfomance

#Q27 Analyzing payment trends to improve cash flow management - poor payment trends

WITH payment_trend
AS

(
		SELECT
			c.customerNumber,
			c.customerName,
			p.paymentDate,
			p.amount AS paymentAmount
		FROM
			mintclassics.customers AS c
		LEFT JOIN
			mintclassics.payments AS p ON c.customerNumber = p.customerNumber
		order by	
			paymentAmount desc
)
, payment_by_monthyear
AS 
(
SELECT MONTHNAME(paymentDate) 'Month', YEAR(paymentDate) 'Year', sum(paymentAmount) as totalPayment_in_the_month

FROM payment_trend

GROUP BY MONTHNAME(paymentDate), YEAR(paymentDate)

HAVING totalPayment_in_the_month IS NOT NULL
)

SELECT Month, Year, totalPayment_in_the_month, sum(totalPayment_in_the_month) OVER (PARTITION BY Year) AS totalPayment_in_the_year
FROM payment_by_monthyear
ORDER BY totalPayment_in_the_month DESC

#Observation
##Highest sale is in Nov 2004 with 857K in a single month and 4.3 million in the year 2004
##Lowest sale is in Jan 2003 with 26K in a single month and 3.2 million in the year 2003
    
#Q28 Assessing Product lines aids in portfolio optimization
SELECT
    p.productLine,
    pl.textDescription AS productLineDescription,
    SUM(p.quantityInStock) AS totalInventory,
    SUM(od.quantityOrdered) AS totalSales,
    SUM(od.priceEach * od.quantityOrdered) AS totalRevenue,
    (SUM(od.quantityOrdered) / SUM(p.quantityInStock)) * 100 AS salesToInventoryPercentage
FROM
    mintclassics.products AS p
LEFT JOIN
    mintclassics.productlines AS pl ON p.productLine = pl.productLine
LEFT JOIN
    mintclassics.orderdetails AS od ON p.productCode = od.productCode
GROUP BY
    p.productLine, pl.textDescription
ORDER BY
	salesToInventoryPercentage DESC

#Q29 Are there customers with credit issues that need to be addressed?

SELECT
    c.customerNumber,
    c.customerName,
    c.creditLimit,
    SUM(p.amount) AS totalPayments,
    (SUM(p.amount) - c.creditLimit) AS creditLimitDifference
FROM
    mintclassics.customers AS c
LEFT JOIN
    mintclassics.payments AS p ON c.customerNumber = p.customerNumber
GROUP BY
    c.customerNumber, c.creditLimit
HAVING
    SUM(p.amount) < c.creditLimit
ORDER BY
	totalPayments asc


