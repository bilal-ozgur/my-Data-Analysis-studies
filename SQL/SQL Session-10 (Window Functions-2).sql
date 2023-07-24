--SQL SESSION-10 (Window Functions-2)

--*** Windowed functions can only appear in the SELECT or ORDER BY clauses.


--3. ANALYTIC NUMBERING FUNCTIONS--

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()

--The ORDER BY clause is mandatory because these functions are order sensitive.
--They are not used with window frames.


--/////////////////////////////////////

--QUESTION: Assign an ordinal number to the product prices for each category in ascending order.
--(Herbir kategori içinde ürünlerin fiyat sýralamasýný yapýnýz - artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT	category_id,
		list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) AS rank_number
FROM	product.product;


--Lets try previous query again using RANK() and DENSE_RANK() functions.


SELECT	category_id,
		list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) AS [row_number],
		RANK() OVER(PARTITION BY category_id ORDER BY list_price) AS rank_number,
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) AS [dense_rank]
FROM	product.product;


--/////////////////////////////////////

--QUESTION: Which orders' average product price is lower than the overall average price?
--(Hange sipariþlerin ortalama ürün fiyatý genel ortalama fiyattan daha düþüktür?)

SELECT	*
FROM	(
		SELECT	DISTINCT
				order_id,
				AVG(list_price) OVER() AS avg_price,
				AVG(list_price) OVER(PARTITION BY order_id) AS avg_price_by_orders
		FROM	sale.order_item
		) AS subq
WHERE avg_price_by_orders < avg_price
ORDER BY avg_price_by_orders DESC;

------------------------------

SELECT	order_id,
		AVG(list_price) AS avg_price_by_orders,
		(SELECT AVG(list_price) FROM sale.order_item) AS overall_avg_price
FROM	sale.order_item
GROUP BY order_id
HAVING	 AVG(list_price) < (SELECT AVG(list_price) FROM sale.order_item)
ORDER BY avg_price_by_orders DESC;



--/////////////////////////////////////

--QUESTION: Calculate the stores' weekly cumulative count of orders for 2018.
--(maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz)

SELECT	DISTINCT 
		a.store_id,
		a.store_name,
		DATEPART(WK, order_date) AS [week],
		COUNT(order_id) OVER(PARTITION BY a.store_id, DATEPART(WK, order_date)) "weeks_order",
		COUNT(order_id) OVER(PARTITION BY a.store_id ORDER BY DATEPART(WK, order_date)) "cume_total_order"
FROM	sale.store AS a,
		sale.orders AS b
WHERE	a.store_id = b.store_id
		AND YEAR(order_date) = 2018



--/////////////////////////////////////

--QUESTION: Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--('2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn)


WITH cte AS(
	SELECT	DISTINCT
			order_date,
			SUM(quantity) OVER(PARTITION BY order_date) AS daily_quantity
	FROM	sale.orders AS a,
			sale.order_item AS b
	WHERE	a.order_id = b.order_id
			AND order_date BETWEEN '2018-03-12' and '2018-04-12'
)
SELECT	*,
		AVG(daily_quantity) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS sales_moving_average_7
FROM	cte

----
--SOLUTION WITH GROUP BY

SELECT	a.order_date,
		SUM(quantity) AS daily_qty,
		AVG(SUM(quantity)) OVER(ORDER BY order_date ROWS 6 PRECEDING) AS sales_moving_average_7
FROM	sale.orders AS a,
		sale.order_item AS b
WHERE	a.order_id = b.order_id
		AND order_date BETWEEN '2018-03-12' and '2018-04-12'
GROUP BY a.order_date;




--/////////////////////////////////////

--QUESTION: Write a query that returns the highest daily turnover amount for each week on a yearly basis.
--(Yýl bazýnda her haftaya ait en yüksek günlük ciro miktarýný döndüren bir sorgu yazýnýz)

SELECT	DISTINCT
		order_year, order_week,
		MAX(daily_turnover) OVER(PARTITION BY order_year, order_week) AS highest_turnover
FROM	
		(
		SELECT	DISTINCT
				order_date,
				YEAR(order_date) AS order_year,
				DATEPART(ISO_WEEK, order_date) AS order_week,   --WEEK/WW/WK 
				SUM(quantity * list_price * (1-discount)) OVER(PARTITION BY order_date) AS daily_turnover
		FROM	sale.orders AS a,
				sale.order_item AS b
		WHERE	a.order_id = b.order_id
		) AS subq



------SOLUTION WITH GROUP BY AND FIRST_VALUE

SELECT	DISTINCT 
		YEAR(order_date) AS order_year,
		DATEPART(ISO_WEEK, order_date) AS order_week,
		--SUM(quantity * list_price * (1-discount)) AS daily_turnover,
		FIRST_VALUE(SUM(quantity * list_price * (1-discount))) OVER(PARTITION BY YEAR(order_date), DATEPART(ISO_WEEK, order_date) 
																ORDER BY SUM(quantity * list_price * (1-discount)) DESC)  AS highest_turnover
FROM	sale.orders AS a,
		sale.order_item AS b
WHERE	a.order_id = b.order_id
GROUP BY order_date



--/////////////////////////////////////

--QUESTION: List customers whose have at least 2 consecutive orders are not shipped.
--(Peþpeþe en az 2 sipariþi gönderilmeyen müþterileri bulunuz)


SELECT	customer_id
FROM	(
		SELECT	order_id, customer_id, order_date, shipped_date,
				LEAD(shipped_date, 1, '0001-01-01') OVER(PARTITION BY customer_id ORDER BY order_date) AS next_shipped_date
		FROM	sale.orders
		) AS subq
WHERE	(shipped_date IS NULL AND next_shipped_date IS NULL)



--/////////////////////////////////////

--QUESTION: Write a query that returns how many days are between the third and fourth order dates of each staff.
--(Her bir personelin üçüncü ve dördüncü sipariþleri arasýndaki gün farkýný bulunuz)












--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--////////////////////////

--CUME_DIST()

--creates a column that contain cumulative distribution of the sorted column values.
--cume_dist = row number / total rows

--////////////////////////

--QUESTION: Write a query that returns the cumulative distribution of the list price in product table by brand.
--(product tablosundaki list price' larýn kümülatif daðýlýmýný marka kýrýlýmýnda hesaplayýnýz)










--////////////////////////

-- PERCENT_RANK()

--creates a column that contain relative standing of a value in the sorted column values.
--percent_rank = (row number-1) / (total rows-1)

--////////////////////////

--QUESTION: Write a query that returns the relative standing of the list price in the product table by brand.










--////////////////////////

--NTILE()

--divides the sorted column into equal groups according to the given parameter (N) value and returns which group the each values are in.

--////////////////////////



