
-- SQL SESSION-1, 06.07.2023, BASIC SQL COMMANDS
------------------------------------------------

-- SELECT Clause
------------------------------------------------

SELECT 1

SELECT 'adsum'

SELECT 1, 'adsum'

SELECT 'adsum' AS first_name --FirstName
SELECT 'adsum' AS [first name];
SELECT 'adsum' AS 'first name';


-- FROM Clause
------------------------------------------------

SELECT * 
FROM sale.customer;

SELECT first_name 
FROM sale.customer;

SELECT last_name AS surname, first_name AS [name]
FROM sale.customer;


-- WHERE Clause
------------------------------------------------
-- (it is used to filter records)

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE city='ann arbor';

SELECT first_name, last_name, street, state 
FROM sale.customer
WHERE city='ann arbor';

SELECT first_name, last_name, street, state 
FROM sale.customer
WHERE NOT city='ann arbor';


-- AND / OR operators

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE city='Allen' AND state='TX';

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE city='Allen' OR state='TX';

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE last_name='chan' AND state='TX' OR state='NY';

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE last_name='chan' AND (state='TX' OR state='NY');


-- IN / NOT IN operators

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE city IN ('Allen', 'Buffalo', 'Austin');

--SELECT first_name, last_name, street, city, state 
--FROM sale.customer
--WHERE city=('Allen', 'Buffalo', 'Austin');  ---ERROR

--SELECT first_name, last_name, street, city, state 
--FROM sale.customer
--WHERE city=('Allen') OR city=('Buffalo') OR city=('Austin');  ---UZUN KULLANIM

SELECT first_name, last_name, street, city, state 
FROM sale.customer
WHERE city NOT IN ('Allen', 'Buffalo', 'Austin');


-- LIKE operator

-- '_' any single character
-- '%' unknown character numbers

SELECT *
FROM sale.customer
WHERE email LIKE '%yahoo%';

SELECT *
FROM sale.customer
WHERE email LIKE 'yahoo%';

SELECT *
FROM sale.customer
WHERE first_name LIKE 'Di_ne';

SELECT *
FROM sale.customer
WHERE first_name LIKE '[TZ]%';

SELECT *
FROM sale.customer
WHERE first_name LIKE '[T-Z]%';

SELECT *
FROM sale.customer
WHERE zip_code LIKE '[7-9]%';

-- BETWEEN operator
-- (the "between" operator is inclusive)

SELECT *
FROM product.product
WHERE list_price BETWEEN 599 AND 999;


--Find customer ids who ordered between '2018-01-08' and '2018-01-12'.

SELECT *
FROM sale.orders
WHERE order_date BETWEEN '2018-01-05' AND '2018-01-08';


-- <, >, <=, >=, =, !=, <>

SELECT *
FROM product.product
WHERE list_price > 999;


-- IS NULL / IS NOT NULL

SELECT *
FROM sale.customer
WHERE phone IS NULL;

SELECT *
FROM sale.customer
WHERE phone IS NOT NULL;


--------------------------------------
-- SELECT TOP N

SELECT TOP 10 *
FROM sale.customer

SELECT TOP 10 first_name
FROM sale.customer


--------------------------------------
-- ORDER BY Clause
-- (by default "order by" keyword sorts the records in ascending order)

SELECT *
FROM sale.orders
ORDER BY customer_id;

SELECT *
FROM sale.orders
ORDER BY customer_id ASC;

SELECT *
FROM sale.orders
ORDER BY customer_id DESC;

SELECT [order_id], [order_status], [order_date]
FROM sale.orders
ORDER BY customer_id DESC;

SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY 1,2;

SELECT first_name, last_name, city, state
FROM sale.customer
ORDER BY first_name DESC, last_name ASC;


--------------------------------------
-- SELECT DISTINCT Clause
-- (it is used to return only distinct (different/unique) values to eliminate
-- duplicate rows in a result set)

SELECT DISTINCT state
FROM sale.customer

SELECT DISTINCT city, state
FROM sale.customer

SELECT DISTINCT *
FROM sale.customer
