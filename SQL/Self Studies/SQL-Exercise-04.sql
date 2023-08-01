--- \\\  SQL Exercise - 04  /// ---



--1. Report cumulative total turnover by months in each year in pivot table format.



WITH t1 AS 
(
	SELECT	DISTINCT
			YEAR(order_date) AS [year],
			DATENAME(MONTH, order_date) AS [month],
			--SUM(quantity * list_price * (1-discount)) OVER(PARTITION BY YEAR(order_date),MONTH(order_date)) AS total_turnover,
			FORMAT(CAST(SUM(quantity * list_price * (1-discount)) OVER(PARTITION BY YEAR(order_date) ORDER BY MONTH(order_date)) AS decimal(10,2)),'N', 'en-us') AS cumulative_total_turnover
	FROM	sale.order_item AS a,
			sale.orders AS b
	WHERE	a.order_id = b.order_id
)
SELECT	*
FROM	t1
PIVOT
(
	MAX(cumulative_total_turnover)
	FOR [month] IN ([January],[February],[March],[April],[May],[June],[July],[August],[September],[October],[November],[December])
) AS p1




--2. What percentage of customers purchasing a product have purchased the same product again?


SELECT	*
FROM	sale.orders AS a,
		sale.order_item AS b
WHERE	a.order_id = b.order_id


SELECT	product_id, customer_id
FROM	sale.orders AS a,
		sale.order_item AS b
WHERE	a.order_id = b.order_id
ORDER BY 1



-- Count the total number of orders for each product
SELECT	product_id, COUNT(a.order_id) AS total_orders
FROM	sale.orders AS a,
		sale.order_item AS b
WHERE	a.order_id = b.order_id
GROUP BY product_id;



-- Count the number of customers who have made repeat purchases for each product
SELECT	product_id, 
		COUNT(DISTINCT customer_id) AS cnt_of_customers,
		COUNT(customer_id) - COUNT(DISTINCT customer_id) AS total,
		COUNT(CASE WHEN COUNT(customer_id) - COUNT(DISTINCT customer_id) > 0) OVER()
FROM	sale.orders AS a,
		sale.order_item AS b
WHERE	a.order_id = b.order_id
GROUP BY product_id
ORDER BY 1;