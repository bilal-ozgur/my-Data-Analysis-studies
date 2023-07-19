-- SQL Assignment 2  - Q2319 Bilal Talha Ozgur


-- 1. Product Sales
--You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

--1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

--To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.


--First, let's find customers with their ids, names and surnames who bought product: '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT DISTINCT
	d.customer_id,
	d.first_name,
	d.last_name
FROM 
	product.product AS a, 
	sale.order_item AS b, 
	sale.orders AS c,
	sale.customer AS d
WHERE 
	a.product_id = b.product_id AND
	b.order_id = c.order_id AND
	c.customer_id = d.customer_id AND
	product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

--Second, let's find customers with their ids, names and surnames who bought product: 'Polk Audio - 50 W Woofer - Black'
SELECT DISTINCT
	d.customer_id,
	d.first_name,
	d.last_name
FROM 
	product.product AS a, 
	sale.order_item AS b, 
	sale.orders AS c,
	sale.customer AS d
WHERE 
	a.product_id = b.product_id AND
	b.order_id = c.order_id AND
	c.customer_id = d.customer_id AND
	product_name = 'Polk Audio - 50 W Woofer - Black'

--Third, let's join these 2 tables with CTEs and
--let's add 'Yes' new column as 'Other_Product' for customers who bought 'Polk Audio - 50 W Woofer - Black'
--and at last, let's show 'No' in new column 'Other_Product' by using ISNULL() function if this customer didnt buy 'Polk Audio - 50 W Woofer - Black'

WITH t1 AS
(
	SELECT DISTINCT
		d.customer_id,
		d.first_name,
		d.last_name
	FROM 
		product.product AS a, 
		sale.order_item AS b, 
		sale.orders AS c,
		sale.customer AS d
	WHERE 
		a.product_id = b.product_id AND
		b.order_id = c.order_id AND
		c.customer_id = d.customer_id AND
		product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
), 
t2 AS
(
	SELECT DISTINCT
		d.customer_id,
		d.first_name,
		d.last_name,
		'Yes' AS Other_Product
	FROM 
		product.product AS a, 
		sale.order_item AS b, 
		sale.orders AS c,
		sale.customer AS d
	WHERE 
		a.product_id = b.product_id AND
		b.order_id = c.order_id AND
		c.customer_id = d.customer_id AND
		product_name = 'Polk Audio - 50 W Woofer - Black'
)
SELECT
	t1.*,
	ISNULL(t2.Other_Product, 'No') AS Other_Product
FROM 
	t1 
	LEFT JOIN t2 
	ON t1.customer_id = t2.customer_id
ORDER BY
	1



--2. Conversion Rate
--Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.


--a.    Create above table (Actions) and insert values,

CREATE TABLE actions (
	Visitor_ID int,
	Adv_Type varchar(5),
	[Action] varchar(10)
	)

INSERT INTO actions (Visitor_ID, Adv_Type, [Action])
VALUES 
(1, 'A', 'Left'),
(2, 'A', 'Order'),
(3, 'B', 'Left'),
(4, 'A', 'Order'),
(5, 'A', 'Review'),
(6, 'A', 'Left'),
(7, 'B', 'Left'),
(8, 'B', 'Order'),
(9, 'B', 'Review'),
(10, 'A', 'Review')

SELECT *
FROM actions

--b.    Retrieve count of total Actions and Orders for each Advertisement Type,

SELECT Adv_Type, COUNT(Action) AS total_actions
FROM actions
GROUP BY Adv_Type

SELECT Adv_Type, COUNT(Action) AS total_orders
FROM actions
WHERE Action = 'Order'
GROUP BY Adv_Type

--c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.

WITH t1 AS (
	SELECT Adv_Type, COUNT(Action) AS total_actions
	FROM actions
	GROUP BY Adv_Type
	),

t2 AS
(
	SELECT Adv_Type, COUNT(Action) AS total_orders
	FROM actions
	WHERE Action = 'Order'
	GROUP BY Adv_Type
)
SELECT t1.Adv_Type, CAST((t2.total_orders *1.0 / t1.total_actions) AS DECIMAL(10,2)) AS Conversion_Rate
FROM t1, t2 
WHERE t1.Adv_Type = t2.Adv_Type