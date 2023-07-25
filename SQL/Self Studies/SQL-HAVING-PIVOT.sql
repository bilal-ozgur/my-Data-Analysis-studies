--CHECK YOURSELF- 17

--QUESTION 1--
--Please write a query to return only the order ids that have an average amount of more than $2000. Your result set should include order_id. Sort the order_id in ascending order.

SELECT	order_id
		--AVG(quantity * list_price ) AS avg_amount
FROM	sale.order_item
GROUP BY order_id
HAVING	AVG(quantity * list_price ) > 2000
ORDER BY 1



--QUESTION 2--
--Write a query that returns the count of orders of each day between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.
--Note: The column names should be day names (Sun, Mon, etc.).


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
	FOR day_of_week IN ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
	) as pvt