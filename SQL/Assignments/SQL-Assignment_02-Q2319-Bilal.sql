-- SQL Assignment 2  - Q2319 Bilal Talha Ozgur


-- 1. Product Sales
--You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

--1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)

--To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.



---I return customers who purchased both product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' and 'Polk Audio - 50 W Woofer - Black'

SELECT 
	c.customer_id, 
	first_name, 
	last_name
FROM product.product AS a
	JOIN sale.order_item AS b ON a.product_id = b.product_id
	JOIN sale.orders AS c ON b.order_id = c.order_id
	JOIN sale.customer AS d ON d.customer_id = c.customer_id
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'	
	AND c.customer_id IN 
	(
	SELECT c.customer_id
	FROM product.product AS a
		JOIN sale.order_item AS b ON a.product_id = b.product_id
		JOIN sale.orders AS c ON b.order_id = c.order_id
		JOIN sale.customer AS d ON d.customer_id = c.customer_id
	WHERE product_name = 'Polk Audio - 50 W Woofer - Black'
	GROUP BY c.customer_id
	)
ORDER BY 1



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

--c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.

