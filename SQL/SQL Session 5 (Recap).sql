
-- SQL Session-6, RECAP
--------------------------------------------

--QUESTION-1
--Find the number of orders made by employee number 6 between '2018-01-04' and '2019-01-04'

SELECT COUNT(order_id) AS num_of_orders
FROM sale.orders
WHERE staff_id = 6 AND order_date BETWEEN '2018-01-04' AND '2019-01-04';

--QUESTION-2
--Report the number of orders made by each employee in store number 1 
--between '2018-01-04' and '2019-01-04'

SELECT staff_id, COUNT(order_id) AS num_of_orders
FROM sale.orders
WHERE store_id = 1 AND order_date BETWEEN '2018-01-04' AND '2019-01-04'
GROUP BY staff_id
ORDER BY staff_id;

--QUESTION-3
--Report the daily number of orders made by the employees in store number 1
--between '2018-01-04' and '2018-02-04'

SELECT staff_id, order_date, COUNT(order_id) AS num_of_orders
FROM sale.orders
WHERE store_id = 1 AND order_date BETWEEN '2018-01-04' AND '2018-02-04'
GROUP BY staff_id, order_date
ORDER BY staff_id;

--QUESTION-4
--Find the store with the highest number of unshipped orders.

SELECT store_id, COUNT(order_id) AS num_of_unshipped_orders
FROM sale.orders
WHERE shipped_date IS NULL
GROUP BY store_id
ORDER BY num_of_unshipped_orders DESC;

-----
--use of TOP PERCENT 

SELECT TOP 10 PERCENT *
FROM product.product;

--QUESTION-5
--Find the distribution of the number of customers who placed orders before 2020 by stores.

SELECT store_id, COUNT(customer_id) AS num_of_customers
FROM sale.orders
WHERE YEAR(order_date) < 2020
GROUP BY store_id
ORDER BY store_id;

--QUESTION-6
--Find the employee with the lowest performance in the second quarter of 2020.

SELECT TOP 1 staff_id, COUNT(order_id) AS num_of_orders
FROM sale.orders
WHERE  DATEPART(QQ,order_date)=2 AND YEAR(order_date) = 2020
GROUP BY staff_id
ORDER BY num_of_orders;

-----

SELECT TOP 1 staff_id, COUNT(order_id) AS num_of_orders
FROM sale.orders
WHERE  order_date LIKE '2020-0[4-6]-%'
GROUP BY staff_id
ORDER BY num_of_orders;


--QUESTION-7
--Find the product with the least profit.

SELECT TOP 1 product_id, SUM(quantity * list_price * (1-discount)) AS total_profit
FROM sale.order_item
GROUP BY product_id
ORDER BY total_profit;

--QUESTION-8
--Find the store with the highest turnover in the 4th, 5th and 6th months of 2018.

SELECT TOP 1 a.store_name, SUM(c.quantity * c.list_price * (1-c.discount)) AS total_profit
FROM sale.store AS a
	JOIN sale.orders AS b ON a.store_id = b.store_id
	JOIN sale.order_item AS c ON b.order_id = c.order_id
WHERE order_date LIKE '2018-0[4-6]-%'
GROUP BY a.store_name
ORDER BY total_profit DESC;

--QUESTION-9
--Report the weekly sales performance of the employees for the 4th month of 2020.

SELECT a.first_name, a.last_name, DATEPART(ISOWK, order_date) AS ord_week,
	SUM(c.quantity) AS total_quantity,
	COUNT(b.order_id) AS total_order,
	SUM(c.quantity * c.list_price * (1-c.discount)) AS total_sales
FROM sale.staff AS a
	JOIN sale.orders AS b ON a.staff_id = b.staff_id
	JOIN sale.order_item AS c ON b.order_id = c.order_id
WHERE order_date LIKE '2020-04-%'
GROUP BY a.first_name, a.last_name,DATEPART(ISOWK, order_date);

------------------------
--difference between week and isoweek

select datepart(w, '2018-01-01')
select datepart(isowk, '2018-01-01')
select datename(dw, '2018-01-01')


----------------------------------------------------------
--JOINs

SELECT * FROM product.stock

SELECT a.product_id, b.store_id, ISNULL(c.quantity,0) quantity --COALESCE
FROM product.product a
	CROSS JOIN sale.store b
	LEFT JOIN product.stock c ON a.product_id=c.product_id
	AND b.store_id=c.store_id
ORDER BY 1,2;


--------------------------------------------
--COALESCE vs. ISNULL

SELECT ISNULL(phone, 0)
FROM sale.customer


SELECT COALESCE(phone, 0)
FROM sale.customer   --GIVES ERROR

SELECT 1 + '1' --implicit conversion


--NULLIF
--zero division hatalarýný engellemek için kullanýlýr

SELECT NULLIF(1, '1')

SELECT 1/0

SELECT 1/NULLIF(points,0)