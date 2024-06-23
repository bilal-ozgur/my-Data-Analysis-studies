


--Find the average price of products that have not been sold. 


SELECT DISTINCT product_id
FROM	sale.order_item



SELECT	AVG(list_price) avg_price
FROM	product.product
WHERE	product_id NOT IN (
							SELECT  product_id
							FROM	sale.order_item 
							)

------NOT EXISTS

SELECT	AVG(list_price) avg_price
FROM	product.product A
WHERE	NOT EXISTS (
								SELECT  product_id
								FROM	sale.order_item B
								WHERE	A.product_id = B.product_id
								)

-----


--Retrieve the cities that fall below the average revenue of the state they are located in during the first 6 months of 2018.

--2018 yýlýnýn ilk 6 ayýnda bulunduðu eyaletin ciro ortalamasýnýn altýnda kalan þehirleri getiriniz.

--


WITH T1 AS (
SELECT	state, city, SUM(quantity * list_price * (1-discount)) city_turnover
FROM	sale.customer A
		INNER JOIN
		sale.orders B
		ON A.customer_id = B.customer_id
		INNER JOIN 
		sale.order_item C
		ON B.order_id = C.order_id
WHERE	DATEPART(QUARTER , order_date) IN (1,2)
AND		YEAR(order_date) = 2018
GROUP BY
		state, city
) , T2 AS (
SELECT	state, AVG(city_turnover) avg_turnover
FROM	T1
GROUP BY
		state
)
SELECT	T1.*, T2.avg_turnover
FROM	T1 INNER JOIN T2 ON T1.state = T2.state
WHERE	city_turnover < avg_turnover

-------------------



