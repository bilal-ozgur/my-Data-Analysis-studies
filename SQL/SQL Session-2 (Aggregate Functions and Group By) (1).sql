
-- SQL SESSION-2, 08.07.2023, AGGREGATE FUNCTIONS AND GROUP BY CLAUSE
------------------------------------------------------

/* Order of operations:
	1. FROM
	2. JOIN
	3. WHERE
	4. GROUP BY
	5. HAVING
	6. SELECT
	7. DISTINCT
	8. ORDER BY
	9. TOP N  */

------------------------------------------------------
-- COUNT

-- how many products in the product table?

SELECT COUNT(product_id) num_of_products
FROM product.product

SELECT COUNT(*) num_of_products
FROM product.product

----------------------

SELECT COUNT(phone), COUNT(*)
FROM sale.customer

----------------------
--bad practise

SELECT COUNT(1)
FROM sale.customer

SELECT 1
FROM sale.customer


-- How many records have a null value in the phone column?

SELECT COUNT(*)
FROM sale.customer
WHERE phone IS NULL;


SELECT COUNT(phone)
FROM sale.customer
WHERE phone IS NULL;


-- How many customers are located in NY state?

SELECT COUNT(customer_id) AS num_of_customers
FROM sale.customer
WHERE state='NY';


------------------------------------------------------
-- COUNT DISTINCT

--How many -different- city in the customer table?

SELECT COUNT(DISTINCT city)
FROM sale.customer;


------------------------------------------------------
-- MIN / MAX

--What are the minimum and maximum model years of products?

SELECT MIN(model_year), MAX(model_year)
FROM product.product;


--What are the min and max list prices for category id 5?

SELECT MIN(list_price) min_list_price, MAX(list_price) max_list_price
FROM product.product
WHERE category_id=5;

SELECT TOP 1 list_price AS max_price
FROM product.product
WHERE category_id=5
ORDER BY max_price DESC;


------------------------------------------------------
-- SUM

--What is the total list price of the products that belong to category 6?

SELECT SUM(list_price) total_price
FROM product.product
WHERE category_id=6;


--How many product sold in order_id 45? (quantity)

SELECT SUM(quantity) cnt_product
FROM sale.order_item
WHERE order_id=45;


------------------------------------------------------
--AVG

--What is the avg list price of the 2020 model products?
--float

SELECT AVG(list_price) avg_price
FROM product.product
WHERE model_year=2020;


--Find the average order quantity for product 130.
--integer

SELECT AVG(quantity*1.0)
FROM sale.order_item
WHERE product_id=130;


---------------------------------------------------------------
-- GROUP BY
---------------------------------------------------------------

SELECT DISTINCT model_year
FROM product.product


SELECT model_year
FROM product.product
GROUP BY model_year;


------------------------------------------------------
--COUNT

--How many products are in each model year?

SELECT model_year, COUNT(product_id) AS num_of_products
FROM product.product
GROUP BY model_year;


--Write a query that returns the number of products priced over $1000 by brands.

SELECT brand_id, COUNT(product_id) expensive_products
FROM product.product
WHERE list_price > 1000
GROUP BY brand_id
ORDER BY expensive_products DESC; --COUNT(product_id) DESC;


SELECT brand_id, category_id, COUNT(product_id) expensive_products
FROM product.product
WHERE list_price > 1000
GROUP BY brand_id, category_id;


------------------------------------------------------
--COUNT DISTINCT WITH GROUP BY

SELECT *
FROM product.product

SELECT brand_id, COUNT(DISTINCT category_id) num_of_categories
FROM product.product
GROUP BY brand_id;


SELECT brand_id, category_id
FROM product.product
GROUP BY brand_id, category_id;


SELECT brand_id, category_id
FROM product.product
ORDER BY brand_id, category_id;


------------------------------------------------------
-- MIN/MAX

--Find the first and last purchase dates for each customer.

SELECT 
	customer_id,
	MIN(order_date) first_order,
	MAX(order_date) last_order
FROM 
	sale.orders
GROUP BY 
	customer_id;


-- Find min and max product prices of each brand.

SELECT
	brand_id,
	MIN(list_price) min_price,
	MAX(list_price) max_price
FROM
	product.product
GROUP BY
	brand_id;


------------------------------------------------------
--SUM / AVG

---find the total discount amount of each order

SELECT order_id,
	   SUM(quantity*list_price*discount) disc_amount
FROM sale.order_item
GROUP BY order_id;


SELECT 
	   quantity*list_price as price,
	   SUM(quantity*list_price*discount) disc_amount,
	   SUM(quantity*list_price*(1-discount)) final_amount
FROM sale.order_item
WHERE order_id=1 and item_id=2
GROUP BY quantity*list_price;

SELECT *
FROM sale.order_item


---What is the average list price for each model year?

SELECT model_year, AVG(list_price)
FROM product.product
GROUP BY model_year;


-------------------------------------------------------------------

--INTERVIEW QUESTION: 
--Write a query that returns the most repeated name in the customer table.

SELECT TOP 1 first_name  --, COUNT(first_name) most_repeated_name
FROM sale.customer
GROUP BY first_name
ORDER BY COUNT(first_name) DESC;


--Find the state where "yandex" is used the most? (with number of users)

SELECT
	TOP 1 [state], COUNT(email) cnt_yandex
FROM
	sale.customer
WHERE
	email LIKE '%yandex%'
GROUP BY
	state
ORDER BY
	cnt_yandex DESC;
