
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









--EXISTS / NOT EXISTS

--QUESTION: Write a query that returns a list of States where 'Apple - Pre-Owned iPad 3 - 32GB - White'
--product is not ordered









--QUESTION: Write a query that returns stock information of the products in Davi techno Retail store. 
--The BFLO Store hasn't got any stock of that products.









----///////////////////////////

--Subquery in SELECT Statement

--QUESTION: Write a query that creates a new column named "total_price" calculating 
--the total prices of the products on each order.









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

--QUESTION: List customers who have an order prior to the last order date of a customer named 
--Jerald Berray and are residents of the city of Austin. 









--QUESTION: List the stores whose turnovers are under the average store turnovers in 2018.









--QUESTION: Write a query that returns the net amount of their first order for customers who placed 
--their first order after 2019-10-01.



