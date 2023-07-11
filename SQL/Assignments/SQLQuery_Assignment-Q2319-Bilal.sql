-- 1 --
SELECT city, COUNT(customer_id) AS number_of_customers
FROM sale.customer
GROUP BY city
ORDER BY Number_of_Customers DESC;

-- 2 --

SELECT order_id, SUM(quantity) AS total_amount_quantity
FROM sale.order_item
GROUP BY order_id;

-- 3 --
SELECT customer_id, MIN(order_date) AS first_order_date
FROM sale.orders
GROUP BY customer_id;

-- 4 --
SELECT order_id, COUNT(order_id) AS total_amount
FROM sale.order_item
GROUP BY order_id
ORDER BY total_amount DESC;

SELECT *
FROM sale.order_item

-- 5 --
SELECT TOP (1) order_id, AVG(list_price) AS average_price
FROM sale.order_item
GROUP BY order_id
ORDER BY average_price DESC;

-- 6 --

SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY brand_id ASC, list_price DESC;

-- 7 --

SELECT brand_id, product_id, list_price
FROM product.product
ORDER BY list_price DESC, brand_id ASC;

-- 8 --

-- At 6th query; we can compare our products according to their brands with their prices
-- At 7th query; we can examine our products and their brands according to price order

-- 9 --

SELECT TOP (10) *
FROM product.product
WHERE list_price >= 3000;

-- 10 --

SELECT TOP (5) *
FROM product.product
WHERE list_price <= 3000;

-- 11 --

SELECT *
FROM sale.customer
WHERE last_name LIKE 'B%%s'

-- 12 --

SELECT *
FROM sale.customer
WHERE city IN ('Allen','Buffalo','Boston','Berkeley');

