-- 1 How many customers are in each city? Your solution should include the city name and the number of customers sorted from highest to lowest.

SELECT city, COUNT(customer_id) AS number_of_customers
FROM sale.customer
GROUP BY city
ORDER BY Number_of_Customers DESC;

-- 2. Find the total product quantity of the orders. Your solution should include order ids and quantity of products.

SELECT order_id, SUM(quantity) AS total_amount_quantity
FROM sale.order_item
GROUP BY order_id;

-- 3. Find the first order date for each customer_id

SELECT customer_id, MIN(order_date) AS first_order_date
FROM sale.orders
GROUP BY customer_id;

-- 4 Find the total amount of each order. Your solution should include order id and total amount sorted from highest to lowest.

SELECT order_id, SUM(quantity * list_price * (1-discount)) AS total_amount
FROM sale.order_item
GROUP BY order_id
ORDER BY total_amount DESC;

-- EXTRA: Find the customer who spent most total amount

SELECT TOP 10 a.order_id, b.customer_id, SUM(a.quantity * a.list_price * (1-a.discount)) AS total_amount
FROM sale.order_item a 
	JOIN sale.orders b ON a.order_id = b.order_id
GROUP BY a.order_id, b.customer_id
ORDER BY total_amount DESC;

-- 5. Find the order id that has the maximum average product price. Your solution should include only one row with the order id and average product price.

SELECT TOP (1) order_id, AVG(list_price) AS average_price
FROM sale.order_item
GROUP BY order_id
ORDER BY average_price DESC;

-- EXTRA: Find the top 10 product sold within the cities which have at least 50 customers

CREATE VIEW v_numof_customers_by_city AS
SELECT	city, COUNT(customer_id) cnt_customer
FROM	sale.customer
GROUP BY city

SELECT	TOP 10 E.product_id, product_name, SUM(quantity) total_quantity
FROM	v_numof_customers_by_city A
		INNER JOIN
		sale.customer B
		ON	A.city = B.city
		INNER JOIN
		sale.orders C
		ON B.customer_id = C.customer_id
		INNER JOIN
		sale.order_item D
		ON	C.order_id = D.order_id
		INNER JOIN
		product.product E
		ON D.product_id = E.product_id
WHERE	cnt_customer >49
GROUP BY
		E.product_id, product_name
ORDER BY	
		total_quantity DESC


-- 6 Write a query that displays brand_id, product_id and list_price sorted first by brand_id (in ascending order), and then by list_price  (in descending order).

SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY brand_id ASC, list_price DESC;

-- 7 Write a query that displays brand_id, product_id and list_price, but this time sorted first by list_price (in descending order), and then by brand_id (in ascending order).

SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY list_price DESC, brand_id ASC;

-- 8. Compare the results of these two queries above. How are the results different when you switch the column you sort on first? (Explain it in your own words.)

-- At 6th query; we can compare our products according to their brands with their prices
-- At 7th query; we can examine our products and their brands according to price order

-- 9. Write a query to pull the first 10 rows and all columns from the product table that have a list_price greater than or equal to 3000.

SELECT TOP (10) *
FROM product.product
WHERE list_price >= 3000;

-- 10. Write a query to pull the first 5 rows and all columns from the product table that have a list_price less than 3000.

SELECT TOP (5) *
FROM product.product
WHERE list_price <= 3000;

-- 11. Find all customer last names that start with 'B' and end with 's'.

SELECT *
FROM sale.customer
WHERE last_name LIKE 'B%%s'

-- 12. Use the customer table to find all information regarding customers whose address is Allen or Buffalo or Boston or Berkeley.

SELECT *
FROM sale.customer
WHERE city IN ('Allen','Buffalo','Boston','Berkeley');

