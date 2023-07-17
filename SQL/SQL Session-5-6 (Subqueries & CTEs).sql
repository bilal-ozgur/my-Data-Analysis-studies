
-- SQL Session-5/6, 12.07.2023, (Subqueries & CTEs)

----SUBQUERIES----
--------------------------------------------

--A subquery is a query nested inside another statement such as SELECT, INSERT, UPDATE or DELETE.
--A subquery must be enclosed in parentheses.
--The inner query can be run by itself.
--The subquery in a SELECT clause must return a single value.
--The subquery in a FROM clause must be used with an alias.
--An ORDER BY clause is not allowed to use in a subquery.
--(unless TOP, OFFSET or FOR XML is also specified)


-- ****Single-Row Subqueries**** --
--**************************************

--QUESTION: Write a query that shows all employees in the store where Davis Thomas works.

SELECT * 
FROM sale.staff
WHERE store_id = (SELECT store_id
				  FROM sale.staff
				  WHERE first_name + last_name = 'DavisThomas');

SELECT store_id
FROM sale.staff
WHERE first_name + last_name = 'DavisThomas'

--QUESTION: Write a query that shows the employees for whom Charles Cussona is a first-degree manager.
--(To which employees are Charles Cussona a first-degree manager?)

SELECT *
FROM sale.staff

SELECT *
FROM sale.staff
WHERE manager_id = (SELECT staff_id
					FROM sale.staff
					WHERE first_name + last_name = 'CharlesCussona')

-- Subquerry'de neden staff_id yazdik? Soruda eger Charless Cussona yerine staff_id'si 2 olmayan yani staff_idsi farkli biri olsaydi bu sefer sonuc farkli cikacakti?




--QUESTION: Write a query that returns the list of products that are more expensive than the product
--named 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'.(Also show model year and list price)

SELECT *
FROM product.product
WHERE list_price > (SELECT list_price
					FROM product.product
					WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')


-- ****Multiple-Row Subqueries**** --
--**************************************
--They are used with multiple-row operators such as IN, NOT IN, ANY, and ALL.


---//////////////////////////---

--QUESTION: Write a query that returns the first name, last name, and order date of customers 
--who ordered on the same dates as Laurel Goldammer.

SELECT *
FROM sale.orders
WHERE order_date = (SELECT order_date
				     FROM sale.orders
                     WHERE first_name+last_name = 'LaurelGoldammer')

SELECT b.order_date
FROM sale.customer AS a
	JOIN sale.orders AS b ON a.customer_id = b.customer_id
WHERE first_name+last_name = 'LaurelGoldammer'

SELECT first_name, last_name, order_date
FROM sale.customer AS a
	JOIN sale.orders AS b ON a.customer_id = b.customer_id
WHERE order_date IN (SELECT b.order_date
			FROM sale.customer AS a
				  JOIN sale.orders AS b ON a.customer_id = b.customer_id
			WHERE first_name+last_name = 'LaurelGoldammer')

--QUESTION: List the products that ordered in the last 10 orders in Buffalo city.

SELECT DISTINCT product_name
FROM sale.order_item AS a
	JOIN product.product AS b ON a.product_id = b.product_id
WHERE order_id IN (SELECT TOP 10 order_id
						FROM sale.customer AS a 
							JOIN sale.orders AS b ON a.customer_id = b.customer_id
						WHERE city = 'Buffalo' 
						ORDER BY order_id DESC)

-- ****Correlated Subqueries**** --
--**************************************
--A correlated subquery is a subquery that uses the values of the outer query. In other words, the correlated subquery depends on the outer query for its values.
--Because of this dependency, a correlated subquery cannot be executed independently as a simple subquery.
--Correlated subqueries are used for row-by-row processing. Each subquery is executed once for every row
--of the outer query.
--A correlated subquery is also known as repeating subquery or synchronized subquery.

---//////////////////////////---

---- Write a query that returns avg list price for each category 

----SOLUTION 1 -- WITH JOIN METHOD

SELECT product_id, product_name, category_id, list_price,
	(SELECT AVG(list_price) FROM product.product) AS avg_price
FROM product.product

SELECT category_id, AVG(list_price) AS avg_price
FROM product.product
GROUP BY category_id


SELECT product_id, product_name, a.category_id, list_price, b.avg_price
FROM product.product AS a
	JOIN (SELECT category_id, AVG(list_price) AS avg_price
		  FROM product.product
	      GROUP BY category_id) AS b
     ON a.category_id = b.category_id
ORDER BY 1;

-------SOLUTION 2 -- WITH CORRALATED SUBQUERY

SELECT AVG(list_price) AS avg_price
FROM product.product
WHERE category_id = 1

SELECT product_id, product_name, category_id, list_price,
	(SELECT AVG(list_price) FROM product.product WHERE category_id =a.category_id) AS avg_price
FROM product.product AS a;


--EXISTS / NOT EXISTS

--EXISTS
--SOME PRACTISES

SELECT * 
FROM sale.customer
WHERE EXISTS (SELECT 1)

SELECT *
FROM sale.customer AS a
WHERE EXISTS (
			  SELECT 1
			  FROM sale.orders AS b
			  WHERE  b.order_date > '2020-01-01')


SELECT *
FROM sale.customer AS a
WHERE EXISTS (SELECT 1
			  FROM sale.orders AS b
			  WHERE b.order_date > '2020-01-01'
			  AND a.customer_id = b.customer_id)

--NOT EXISTS
--SOME PRACTISES

SELECT *
FROM sale.customer AS a
WHERE NOT EXISTS (SELECT 1);

SELECT *
FROM sale.customer AS a
WHERE NOT EXISTS (SELECT 1
                  FROM sale.orders AS b
				  WHERE b.order_date > '2020-01-01');

SELECT *
FROM sale.customer AS a
WHERE NOT EXISTS (SELECT 1
                  FROM sale.orders AS b
				  WHERE b.order_date > '2020-01-01'
				  AND a.customer_id = b.customer_id);

--QUESTION: Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White' product is not ordered

SELECT state
FROM sale.customer AS a
	JOIN sale.orders AS b ON a.customer_id = b.customer_id
	JOIN sale.order_item AS c ON b.order_id = c.order_id
	JOIN product.product AS d ON c.product_id = d.product_id
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'

SELECT DISTINCT state
FROM sale.customer
WHERE state NOT IN (
				SELECT state
				FROM sale.customer AS a
					JOIN sale.orders AS b ON a.customer_id = b.customer_id
					JOIN sale.order_item AS c ON b.order_id = c.order_id
					JOIN product.product AS d ON c.product_id = d.product_id
				WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
				);

-------

SELECT DISTINCT state
FROM sale.customer AS x
WHERE NOT EXISTS (
				SELECT state
				FROM sale.customer AS a
					JOIN sale.orders AS b ON a.customer_id = b.customer_id
					JOIN sale.order_item AS c ON b.order_id = c.order_id
					JOIN product.product AS d ON c.product_id = d.product_id
				WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White'
				AND state = x.state
				);

--QUESTION: Write a query that returns stock information of the products in Davi techno Retail store. 
--The BFLO Store hasn't got any stock of that products.

SELECT store_name, a2.store_id, product_id, quantity
FROM sale.store AS a2
	JOIN product.stock AS b2 ON a2.store_id = b2.store_id
WHERE a2.store_name = 'Davi techno Retail'
AND NOT EXISTS (
			SELECT store_name, a.store_id, product_id, quantity
			FROM sale.store AS a
				JOIN product.stock AS b ON a.store_id = b.store_id
			WHERE a.store_name = 'The BFLO Store'
				AND quantity > 0
				AND product_id = b2.product_id
				);

----///////////////////////////

--Subquery in SELECT Statement

--QUESTION: Write a query that creates a new column named "total_price" calculating 
--the total prices of the products on each order.

SELECT DISTINCT order_id,
	(SELECT SUM(list_price) FROM sale.order_item AS b WHERE order_id = a.order_id) AS total_price
FROM sale.order_item AS a;

------

SELECT order_id, SUM(list_price) AS total_price
FROM sale.order_item
GROUP BY order_id;


----EXTRA QUESTION:

--List the products whose list price is higher than the average price of the products in the category.

SELECT *
FROM product.product AS a
WHERE list_price > (SELECT AVG(list_price) FROM product.product WHERE category_id = a.category_id)

--/////////////////////////////////////////////////////////////

----CTE's (Common Table Expression)----
--********************************************

--Common Table Expression exists for the duration of a single statement. That means 
--they are only usable inside of the query they belong to.
--It is also called "with statement".
--CTE is just syntax so in theory it is just a subquery. But it is more readable.
--An ORDER BY clause is not allowed to use in a subquery.
--(unless TOP, OFFSET or FOR XML is also specified)
--Each column must have a name.

---//////////////////////////---

--List the products whose list price is higher than the average price of the products in the category.(Same question above but use CTE) 

WITH temp_table AS
	(SELECT AVG(list_price) AS avg_salary
	FROM product.product)
	SELECT product_id, product_name, list_price
	FROM product.product, temp_table
	WHERE product.list_price > temp_table.avg_salary;

--QUESTION: List customers who have an order prior to the last order date of a customer named 
--Jerald Berray and are residents of the city of Austin. 

WITH cte AS
		(SELECT MAX(order_date) AS max_date
		FROM sale.customer AS a
			JOIN sale.orders AS b ON a.customer_id = b.customer_id
		WHERE first_name + last_name = 'JeraldBerray')

SELECT a.customer_id, first_name, last_name, city, order_date, max_date
FROM sale.customer AS a, sale.orders AS b, cte
WHERE a.customer_id=b.customer_id

----SORUM---USTTE KI BIRLESTIRILEN QUERYIM NEDEN ALTTAKIYLE JOIN METODUYLA BIRLESMEDI??
WITH cte AS
		(SELECT MAX(order_date) AS max_date
		FROM sale.customer AS a
			JOIN sale.orders AS b ON a.customer_id = b.customer_id
		WHERE first_name + last_name = 'JeraldBerray')

SELECT a.customer_id, first_name, last_name, city, order_date, max_date
FROM sale.customer AS a
	JOIN sale.orders AS b ON a.customer_id = b.customer_id
	JOIN cte AS c ON b.order_date = c.max_date



WITH cte AS
		(SELECT MAX(order_date) AS max_date
		FROM sale.customer AS a
			JOIN sale.orders AS b ON a.customer_id = b.customer_id
		WHERE first_name + last_name = 'JeraldBerray')

SELECT a.customer_id, first_name, last_name, city, order_date, max_date
FROM sale.customer AS a, sale.orders AS b, cte
WHERE a.customer_id=b.customer_id
	AND b.order_date < max_date
	AND a.city = 'Austin'

--QUESTION: List the stores whose turnovers are under the average store turnovers in 2018.


-- 1st SOLUTION

WITH t1 AS
(		SELECT store_name, 
			SUM(quantity * list_price * (1-discount)) AS turnover
		FROM sale.orders AS a
			JOIN sale.order_item AS b ON a.order_id = b.order_id
			JOIN sale.store AS c ON a.store_id = c.store_id
		WHERE YEAR(order_date) = 2018
		GROUP BY store_name
), t2 AS
(       SELECT AVG(turnover) avg_earn
		FROM t1
)
SELECT *
FROM t1,t2
WHERE turnover < avg_earn

--------------
-- 2nd SOLUTION

WITH t1 AS
(		SELECT store_id, 
			SUM(quantity * list_price * (1-discount)) AS turnover
		FROM sale.orders AS a
			JOIN sale.order_item AS b ON a.order_id = b.order_id
		WHERE YEAR(order_date) = 2018
		GROUP BY store_id
), t2 AS
(       SELECT AVG(turnover) avg_earn
		FROM t1
)
SELECT 
	store_name,
	CAST(turnover AS DECIMAL(10,2)) AS turnover, 
	CONVERT(DECIMAL(10,2), avg_earn) AS avg_earn
FROM 
	t1, t2, sale.store AS x
WHERE 
	t1.store_id = x.store_id
	AND turnover < avg_earn


--QUESTION: Write a query that returns the net amount of their first order for customers who placed 
--their first order after 2019-10-01.

WITH t1 AS
	(SELECT customer_id, MIN(order_id) AS first_oder
	FROM sale.orders 
	GROUP BY customer_id)
SELECT 
	a.customer_id, 
	first_name, 
	last_name, 
	a.order_id
FROM sale.orders AS a
	JOIN sale.order_item b ON a.order_id = b.order_id
	JOIN sale.customer c ON a.customer_id = c.customer_id
	JOIN t1 ON t1.first_oder = a.order_id
WHERE a.order_date > '2019-10-01'
GROUP BY 
	a.customer_id, 
	first_name, 
	last_name, 
	a.order_id
ORDER BY 1
