--CHECK YOURSELF- 17
--SORU 1--

SELECT	order_id,
		AVG(quantity * list_price * (1 - discount)) AS avg_amount
FROM	sale.order_item
GROUP BY order_id
HAVING	AVG(quantity * list_price * (1 - discount)) > 2000
ORDER BY 1


SELECT *
FROM
(
	SELECT	order_id,
			AVG(quantity * list_price * (1 - discount)) AS avg_amount
	FROM	sale.order_item
	GROUP BY order_id
	HAVING	AVG(quantity * list_price * (1 - discount)) > 2000
) AS subq
WHERE avg_amount > 2000


SELECT *
FROM sale.order_item
ORDER BY 1


--SORU 2--



SELECT 
	DATENAME(WEEKDAY, order_date) AS day_of_week,
	COUNT(order_id) AS cnt_of_order
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
GROUP BY
	DATENAME(WEEKDAY, order_date)



SELECT *
FROM sale.orders


SELECT *
FROM 
	(
	SELECT	DATENAME(WEEKDAY, order_date) AS day_of_week,
			order_id
	FROM	sale.orders
	WHERE	order_date BETWEEN '2020-01-19' and '2020-01-25'
	) AS subq
PIVOT
	(
	COUNT(order_id)
	FOR day_of_week IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday])
	) as pvt



----ALTTAN ILHAM AL--
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
