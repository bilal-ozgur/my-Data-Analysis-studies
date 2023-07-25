--SQL SESSION-10 (Window Functions-2)

--*** Windowed functions can only appear in the SELECT or ORDER BY clauses.


--3. ANALYTIC NUMBERING FUNCTIONS--

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()

--The ORDER BY clause is mandatory because these functions are order sensitive.
--They are not used with window frames.


--/////////////////////////////////////

--QUESTION: Assign an ordinal number to the product prices for each category in ascending order.
--(Herbir kategori içinde ürünlerin fiyat sıralamasını yapınız - artan fiyata göre 1'den başlayıp birer birer artacak)


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
--(Hange siparişlerin ortalama ürün fiyatı genel ortalama fiyattan daha düşüktür?)

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
--(mağazaların 2018 yılına ait haftalık kümülatif sipariş sayılarını hesaplayınız)

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
--('2018-03-12' ve '2018-04-12' arasında satılan ürün sayısının 7 günlük hareketli ortalamasını hesaplayın)


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
--(Yıl bazında her haftaya ait en yüksek günlük ciro miktarını döndüren bir sorgu yazınız)

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
--(Peşpeşe en az 2 siparişi gönderilmeyen müşterileri bulunuz)


--SOLUTION 1--
SELECT	customer_id
FROM	(
		SELECT	order_id, customer_id, order_date, shipped_date,
				LEAD(shipped_date, 1, '0001-01-01') OVER(PARTITION BY customer_id ORDER BY order_date) AS next_shipped_date
		FROM	sale.orders
		) AS subq
WHERE	(shipped_date IS NULL AND next_shipped_date IS NULL);


-------
--SOLUTION 2--
WITH t1 AS(
	SELECT	customer_id, order_id,
			CASE WHEN shipped_date IS NULL THEN 'not delivered' ELSE 'delivered' END AS delivery_status
	FROM	sale.orders
), t2 AS(
	SELECT	*,
			LEAD(delivery_status) OVER(PARTITION BY customer_id ORDER BY order_id) AS next_order_delivery_status
	FROM	t1
)
SELECT	customer_id
FROM	t2
WHERE	delivery_status='not delivered' AND next_order_delivery_status='not delivered';


--SOLUTION 3--
--WITH CASE IN LEAD WITHOUT USING CTEs


SELECT	customer_id
FROM	(
	SELECT	*,
			CASE WHEN shipped_date IS NULL THEN 'not delivered' ELSE 'delivered' END AS delivery_status,
			LEAD(CASE WHEN shipped_date IS NULL THEN 'not delivered' ELSE 'delivered' END) OVER(PARTITION BY customer_id ORDER BY order_id) AS next_order_delivery_status
	FROM	sale.orders
		) AS subq
WHERE	delivery_status='not delivered' AND next_order_delivery_status='not delivered';


--/////////////////////////////////////

--QUESTION: Write a query that returns how many days are between the third and fourth order dates of each staff.
--(Her bir personelin üçüncü ve dördüncü siparişleri arasındaki gün farkını bulunuz)


SELECT	subq.staff_id, first_name, last_name, order_date, previous_order,
		DATEDIFF(DAY,  previous_order, order_date) AS date_diff
FROM	(
		SELECT	*,
				ROW_NUMBER() OVER(PARTITION BY staff_id ORDER BY order_id) AS orders_rows,
				LAG(order_date) OVER(PARTITION BY staff_id ORDER BY order_id) AS previous_order
		FROM	sale.orders
		) AS subq
INNER JOIN sale.staff AS b ON subq.staff_id = b.staff_id
WHERE	orders_rows = 4;



--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

--////////////////////////

--CUME_DIST()

--creates a column that contain cumulative distribution of the sorted column values.
--cume_dist = row number / total rows

--////////////////////////

--QUESTION: Write a query that returns the cumulative distribution of the list price in product table by brand.
--(product tablosundaki list price' ların kümülatif dağılımını marka kırılımında hesaplayınız)


SELECT	brand_id, list_price,
		CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price) AS cume_dist
FROM	product.product;



--////////////////////////

-- PERCENT_RANK()

--creates a column that contain relative standing of a value in the sorted column values.
--percent_rank = (row number-1) / (total rows-1)

--////////////////////////

--QUESTION: Write a query that returns the relative standing of the list price in the product table by brand.


SELECT	brand_id, list_price,
		FORMAT(ROUND(PERCENT_RANK() OVER(PARTITION BY brand_id ORDER BY list_price), 3 ),'p') AS percent_rank
FROM	product.product;




--////////////////////////

--NTILE()

--divides the sorted column into equal groups according to the given parameter (N) value and returns which group the each values are in.

--////////////////////////

SELECT	list_price,
		NTILE(5) OVER(ORDER BY list_price) AS [ntile]
FROM	product.product;


-------------------------------------------------------------------
--EXTRA:

--use of FORMAT function

SELECT	FORMAT(list_price, 'c') AS list_price
FROM	product.product;


SELECT	FORMAT(GETDATE(), 'D') AS "date";

SELECT	FORMAT(GETDATE(), 'd') AS "date";

-------------------------------------------------------------------

SELECT	*
FROM	sale.customer
WHERE	first_name LIKE N'%an%';

SELECT	'yağız';

SELECT	N'yağız';

SELECT	'😀';

SELECT	N'😀';