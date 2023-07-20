



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

--Write a query that returns the list of each order id and that order's total net price (please take into consideration of discounts and quantities)



-------------




--Write a query that returns monthly order counts of the States.






--------------





-----///////////////////////------

--GRUPING SETS

--1. Calculate the total sales price.





--2. Calculate the total sales price of the brands





--3. Calculate the total sales price of the model year





--4. Calculate the total sales price by brands and model year.






------GROUPING SETS






--------------------------



---summary table


--brand, category, model_year, total_sales_price


/*
SELECT ...
INTO	...
FROM ....

*/





--Question: Write a query using summary table that returns the total total_sales from each category by model year. (in pivot table format)

---Pivot oluþturacaðýmýz temel tabloyu belirle

--Tabloyu geçici olarak sabitle




----







----




--Write a query that returns count of the orders day by day in a pivot table format that has been shipped two days later.





