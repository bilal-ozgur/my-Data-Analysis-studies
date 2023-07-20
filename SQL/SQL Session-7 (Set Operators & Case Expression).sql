
---SQL SESSION-7 (Set Operators & CASE Expression)


---*******SET OPERATIONS*******---
---////////////////////////////---


---UNION / UNION ALL-------------------------------------------------

---QUESTION: List the products sold in the cities of Charlotte and Aurora

SELECT 
	product_name
FROM 
	sale.customer AS a,
	sale.orders AS b,
	sale.order_item AS c,
	product.product AS d
WHERE
	a.customer_id = b.customer_id
	AND b.order_id = c.order_id 
	AND c.product_id = d.product_id
	AND city = 'Charlotte'

UNION

SELECT 
	product_name
FROM 
	sale.customer AS a,
	sale.orders AS b,
	sale.order_item AS c,
	product.product AS d
WHERE
	a.customer_id = b.customer_id
	AND b.order_id = c.order_id 
	AND c.product_id = d.product_id
	AND city = 'Aurora';



---UNION ALL/UNION vs IN 
SELECT 
	DISTINCT product_name
FROM 
	sale.customer AS a,
	sale.orders AS b,
	sale.order_item AS c,
	product.product AS d
WHERE
	a.customer_id = b.customer_id
	AND b.order_id = c.order_id 
	AND c.product_id = d.product_id
	AND city IN ('Charlotte','Aurora');



SELECT 
	product_name
FROM 
	sale.customer AS a,
	sale.orders AS b,
	sale.order_item AS c,
	product.product AS d
WHERE
	a.customer_id = b.customer_id
	AND b.order_id = c.order_id 
	AND c.product_id = d.product_id
	AND city = 'Charlotte'

UNION ALL

SELECT 
	product_name
FROM 
	sale.customer AS a,
	sale.orders AS b,
	sale.order_item AS c,
	product.product AS d
WHERE
	a.customer_id = b.customer_id
	AND b.order_id = c.order_id 
	AND c.product_id = d.product_id
	AND city = 'Aurora';



---SOME IMPORTANT RULES OF UNION / UNION ALL
---Even if the contents of to be unified columns are different, the data type must be the same.
---(NOT: Sütunlarýn içeriði farklý da olsa veritipinin ayný olmasý yeterlidir.)

SELECT brand_id
FROM product.brand
UNION ALL
SELECT category_id
FROM product.category;


---The number of columns to be unified must be the same in both queries.
---(Her iki sorguda da ayný sayýda column olmasý lazým.)


SELECT *
FROM product.brand
UNION ALL
SELECT *
FROM product.category;


---other databases can be use

SELECT city
FROM sale.customer
UNION ALL
SELECT Capital
FROM [Workshop].[dbo].[Countries]


---QUESTION: Write a query that returns all customers whose first or last name is Thomas.  
---(don't use 'OR')

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas'

UNION ALL

SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Thomas';



---INTERSECT-------------------------------------------------

---QUESTION: Write a query that returns all brands with products for both 2018 and 2020 model year.

SELECT *
FROM product.brand
WHERE brand_id IN (

	SELECT brand_id
	FROM product.product
	WHERE model_year = 2018
	INTERSECT
	SELECT brand_id
	FROM product.product
	WHERE model_year = 2020
);


---QUESTION: Write a query that returns the first and the last names of the customers who placed orders in all of 2018, 2019, and 2020.

SELECT first_name, last_name
FROM sale.customer
WHERE customer_id IN (

	SELECT customer_id
	FROM sale.orders
	WHERE YEAR(order_date) = 2018
	INTERSECT
	SELECT customer_id
	FROM sale.orders
	WHERE YEAR(order_date) = 2019
	INTERSECT
	SELECT customer_id
	FROM sale.orders
	WHERE YEAR(order_date) = 2020
);


---EXCEPT-------------------------------------------------

---QUESTION: Write a query that returns the brands have 2018 model products but not 2019 model products.

SELECT *
FROM product.brand
WHERE brand_id IN (
	SELECT brand_id
	FROM product.product
	WHERE model_year = '2018'
	EXCEPT
	SELECT brand_id
	FROM product.product
	WHERE model_year = '2019'
);
--------------------
--SOLUTION WITH CTE

WITH t1 AS
(
	SELECT brand_id
	FROM product.product
	WHERE model_year = '2018'
	EXCEPT
	SELECT brand_id
	FROM product.product
	WHERE model_year = '2019'
)
SELECT t1.brand_id, brand_name
FROM product.brand AS b, t1
WHERE b.brand_id = t1.brand_id;



---QUESTION: Write a query that contains only products ordered in 2019 (The result should not include products ordered in other years)
---(Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz)



SELECT c.product_id, product_name
FROM 
	sale.orders AS a,
	sale.order_item AS b,
	product.product AS c
WHERE 
	a.order_id = b.order_id
	AND b.product_id = c.product_id
	AND YEAR(order_date) = 2019
EXCEPT
SELECT c.product_id, product_name
FROM 
	sale.orders AS a,
	sale.order_item AS b,
	product.product AS c
WHERE 
	a.order_id = b.order_id
	AND b.product_id = c.product_id
	AND YEAR(order_date) <> 2019;


---///////////////////////////////////////////////////////////////////////

---*******CASE EXPRESSION*******---
---////////////////////////////---


---Simple Case Expression-------------------------------------------------

---QUESTION: Create a new column with the meaning of the values in the Order_Status column. 
---(Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun)

---1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT *,
	CASE order_status
		WHEN 4 THEN 'Completed'
		WHEN 3 THEN 'Rejected'
		WHEN 2 THEN 'Processing'
		WHEN 1 THEN 'Pending'
	END AS order_status_desc
FROM sale.orders;


---Searched Case Expression-------------------------------------------------

---QUESTION: Create a new column with the meaning of the values in the Order_Status column. 
---(use searched case expresion)

---1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed


SELECT *,
	CASE 
		WHEN order_status=4 THEN 'Completed'
		WHEN order_status=3 THEN 'Rejected'
		WHEN order_status=2 THEN 'Processing'
		WHEN order_status=1 THEN 'Pending'
	END AS order_status_desc
FROM sale.orders;


---QUESTION: Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" ).
---(Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz)

SELECT first_name, last_name, email,
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%Hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%Yahoo%' THEN 'Yahoo'
		WHEN email IS NOT NULL THEN 'Other'
		ELSE NULL
	END AS 'email_service_provider'
FROM sale.customer;

--------SOLUTION WITH GROUP BY;

SELECT COUNT(customer_id)
FROM sale.customer
GROUP BY
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%Hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%Yahoo%' THEN 'Yahoo'
		WHEN email IS NOT NULL THEN 'Other'
		ELSE NULL
	END;



---QUESTION: Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.

WITH cte AS 
(
	SELECT a.customer_id, first_name, last_name, b.order_id,
		SUM(CASE WHEN category_name = 'Computer Accessories' THEN 1 ELSE 0 END) AS ca,
		SUM(CASE WHEN category_name = 'Speakers' THEN 1 ELSE 0 END) AS sp,
		SUM(CASE WHEN category_name = 'mp4 player' THEN 1 ELSE 0 END) AS mp4
	FROM 
		sale.customer AS a,
		sale.orders AS b,
		sale.order_item AS c,
		product.product AS d,
		product.category AS e
	WHERE 
		a.customer_id = b.customer_id 
		AND b.order_id = c.order_id
		AND c.product_id = d.product_id
		AND d.category_id = e.category_id
	GROUP BY a.customer_id, first_name, last_name, b.order_id
)
SELECT *
FROM cte
WHERE ca > 0 AND sp > 0 AND mp4 > 0;

---------------------------
--SOLUTION WITH SUBQUERY:

SELECT *
FROM (
	SELECT a.customer_id, first_name, last_name, b.order_id,
		SUM(CASE WHEN category_name = 'Computer Accessories' THEN 1 ELSE 0 END) AS ca,
		SUM(CASE WHEN category_name = 'Speakers' THEN 1 ELSE 0 END) AS sp,
		SUM(CASE WHEN category_name = 'mp4 player' THEN 1 ELSE 0 END) AS mp4
	FROM 
		sale.customer AS a,
		sale.orders AS b,
		sale.order_item AS c,
		product.product AS d,
		product.category AS e
	WHERE 
		a.customer_id = b.customer_id 
		AND b.order_id = c.order_id
		AND c.product_id = d.product_id
		AND d.category_id = e.category_id
	GROUP BY a.customer_id, first_name, last_name, b.order_id ) AS subquery
WHERE ca > 0 AND sp > 0 AND mp4 > 0;


---QUESTION: Write a query that returns the count of the orders day by day in a pivot table format that has been shipped two days later.
---(2 günden geç kargolanan sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz)

SELECT 
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS Monday,
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS Tuesday,
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS Thursday,
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS Saturday,
	SUM(CASE WHEN DATENAME(DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS Sunday
FROM 
	sale.orders
WHERE 
	DATEDIFF(DAY, order_date, shipped_date) > 2;

----SOLUTION WITH GROUP BY:

