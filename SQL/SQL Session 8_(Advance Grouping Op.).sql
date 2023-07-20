



--GROUPING OPERATIONS



--HAVING


--Write a query that checks if any product id is duplicated in product table.

SELECT product_id, COUNT(product_id) as cnt_of_ids
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1


-------------------------


--Write a query that returns category ids with conditions max list price above 4000 or a min list price below 500.


SELECT 
	category_id,
	MAX(list_price) AS max_price, 
	MIN(list_price) AS min_price
FROM product.product
GROUP BY
	category_id
HAVING 
	MIN(list_price) < 500
	or MAX(list_price) > 4000

---
--SOLUTION WITH SUBQUERY
SELECT *
FROM (SELECT 
		category_id,
		MAX(list_price) AS max_price, 
		MIN(list_price) AS min_price
	 FROM product.product
	 GROUP BY
		category_id) AS a
WHERE 
	min_price < 500 OR max_price > 4000;


--Find the average product prices of the brands. Display brand name and average prices in descending order.

SELECT 
	brand_name,
	AVG(list_price) AS avg_list_price
FROM
	product.brand AS a,
	product.product AS b
WHERE 
	a.brand_id = b.brand_id
GROUP BY 
	brand_name
ORDER BY 
	avg_list_price DESC;


--Write a query that returns the list of brands whose average product prices are more than 1000

SELECT 
	brand_name,
	AVG(list_price) AS avg_list_price
FROM
	product.brand AS a,
	product.product AS b
WHERE 
	a.brand_id = b.brand_id
GROUP BY 
	brand_name
HAVING 
	AVG(list_price) > 1000
ORDER BY 
	avg_list_price DESC;

--HOMEWORK: --Ortalama ürün fiyatýnýn 1000 dolardan yüksek olduðu markalarýn en çok satýldýðý þehir.

SELECT 
	brand_name
FROM
	product.brand AS a,
	product.product AS b
WHERE 
	a.brand_id = b.brand_id
GROUP BY 
	brand_name
HAVING 
	AVG(list_price) > 1000

--Write a query that returns the list of each order id and that order's total net price (please take into consideration of discounts and quantities)

SELECT order_id, SUM(quantity * list_price * (1-discount)) AS net_price
FROM sale.order_item
GROUP BY order_id;

-------------


--Write a query that returns monthly order counts of the States.

SELECT 
	state, 
	YEAR(order_date) AS years, 
	MONTH(order_date) AS months,
	COUNT(order_id) AS num_of_orders
FROM 
	sale.orders AS a, 
	sale.customer AS b
WHERE 
	a.customer_id = b.customer_id
GROUP BY 
	state,
	YEAR(order_date), 
	MONTH(order_date);
--------------





-----///////////////////////------

--GRUPING SETS

--1. Calculate the total sales price.

SELECT SUM(list_price * quantity * (1-discount) ) AS total_sales
FROM sale.order_item;


--2. Calculate the total sales price of the brands

SELECT c.brand_name, SUM(a.list_price * quantity * (1-discount) ) AS total_sales
FROM sale.order_item AS a, product.product AS b, product.brand AS c
WHERE a.product_id = b.product_id AND b.brand_id = c.brand_id
GROUP BY c.brand_name;


--3. Calculate the total sales price of the model year

SELECT model_year, SUM(a.list_price * quantity * (1-discount) ) AS total_sales
FROM sale.order_item AS a, product.product AS b
WHERE a.product_id = b.product_id 
GROUP BY model_year;

--4. Calculate the total sales price by brands and model year.

SELECT c.brand_name, model_year, SUM(a.list_price * quantity * (1-discount) ) AS total_sales
FROM sale.order_item AS a, product.product AS b, product.brand AS c
WHERE a.product_id = b.product_id AND b.brand_id = c.brand_id
GROUP BY c.brand_name, model_year
ORDER BY brand_name, model_year;

------GROUPING SETS

SELECT	c.brand_name, model_year, 
		SUM(a.list_price * quantity * (1-discount) ) AS total_sales
FROM	sale.order_item AS a, product.product AS b, product.brand AS c
WHERE	 a.product_id = b.product_id AND b.brand_id = c.brand_id
GROUP BY 
	GROUPING SETS (
	(),
	(brand_name),
	(model_year),
	(brand_name , model_year)
	)
ORDER BY brand_name, model_year;

--------------------------

SELECT	c.brand_name, model_year, 
		SUM(a.list_price * quantity * (1-discount) ) AS total_sales,
		GROUPING(c.brand_name) AS brand_gr,
		GROUPING(model_year) AS model_gr
FROM	sale.order_item AS a, product.product AS b, product.brand AS c
WHERE	 a.product_id = b.product_id AND b.brand_id = c.brand_id
GROUP BY 
	GROUPING SETS (
	(),
	(brand_name),
	(model_year),
	(brand_name , model_year)
	)
ORDER BY brand_name, model_year;

-----------

SELECT	c.brand_name, model_year, 
		SUM(a.list_price * quantity * (1-discount) ) AS total_sales,
		GROUPING(c.brand_name) AS brand_gr,
		GROUPING(model_year) AS model_gr
FROM	sale.order_item AS a, product.product AS b, product.brand AS c
WHERE	 a.product_id = b.product_id AND b.brand_id = c.brand_id
GROUP BY 
	GROUPING SETS (
	(),
	(brand_name),
	(model_year),
	(brand_name , model_year)
	)
HAVING GROUPING(c.brand_name) = 0 AND GROUPING(model_year) = 0 
ORDER BY brand_name, model_year;


---SUMMARY TABLE

--brand, category, model_year, total_sales_price

/*
SELECT ...
INTO	...
FROM ....
*/

SELECT
	c.brand_name,
	d.category_name,
	model_year,
	SUM(a.list_price * quantity * (1-discount) ) AS total_sales
INTO
	sale.sale_summary
FROM
	sale.order_item AS a, 
	product.product AS b,
	product.brand AS c, 
	product.category AS d
WHERE a.product_id = b.product_id AND b.brand_id = c.brand_id AND b.category_id = d.category_id
GROUP BY c.brand_name, d.category_name, model_year
ORDER BY brand_name, d.category_name, model_year;

---

SELECT *
FROM sale.sale_summary;


--Question: Write a query using summary table that returns the total total_sales from each category by model year. (in pivot table format)

---Determine the base table to which we will create the pivot (Pivot oluþturacaðýmýz temel tabloyu belirle)

SELECT	brand_name, model_year, total_sales
FROM	sale.sale_summary;

--Temporarily pin the table (Tabloyu geçici olarak sabitle)

SELECT *
FROM (
	SELECT	brand_name, model_year, total_sales
	FROM	sale.sale_summary
	) AS a
PIVOT
(
	SUM(total_sales)
	FOR model_year IN ([2018], [2019], [2020], [2021])
) AS pivot_table


----
--WITHOUT BRAND NAME:

SELECT *
FROM (
	SELECT  model_year, total_sales
	FROM	sale.sale_summary
	) AS a
PIVOT
(
	SUM(total_sales)
	FOR model_year IN ([2018], [2019], [2020], [2021])
) AS pivot_table


----
--BY CREATING VIEW METHOD
CREATE VIEW VIEW_TOTAL_SALES AS
SELECT  brand_name, model_year, total_sales
FROM	sale.sale_summary


SELECT *
FROM VIEW_TOTAL_SALES
PIVOT
(
	SUM(total_sales)
	FOR model_year IN ([2018], [2019], [2020], [2021])
) AS pivot_table


--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.

SELECT 
	DATENAME(WEEKDAY, order_date) AS day_of_week,
	COUNT(order_id) AS cnt_of_order
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY
	DATENAME(WEEKDAY, order_date)



SELECT *
FROM
	(
	SELECT 
		DATENAME(WEEKDAY, order_date) AS day_of_week,
		order_id
	FROM sale.orders
	WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
	) AS a
PIVOT
(
	COUNT(order_id)
	FOR day_of_week IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday])
) AS PVT
