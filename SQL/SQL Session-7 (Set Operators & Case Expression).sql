
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



---QUESTION: Write a query that contains only products ordered in 2019 (The result should not include products ordered in other years)
---(Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz)









---///////////////////////////////////////////////////////////////////////

---*******CASE EXPRESSION*******---
---////////////////////////////---


---Simple Case Expression-------------------------------------------------

---QUESTION: Create a new column with the meaning of the values in the Order_Status column. 
---(Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun)

---1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed









---Searched Case Expression-------------------------------------------------

---QUESTION: Create a new column with the meaning of the values in the Order_Status column. 
---(use searched case expresion)

---1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed









---QUESTION: Create a new column that shows which email service provider ("Gmail", "Hotmail", "Yahoo" or "Other" ).
---(Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz)









---QUESTION: Write a query that gives the first and last names of customers who have ordered products from the computer accessories, speakers, and mp4 player categories in the same order.









---QUESTION: Write a query that returns the count of the orders day by day in a pivot table format that has been shipped two days later.
---(2 günden geç kargolanan sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz)

