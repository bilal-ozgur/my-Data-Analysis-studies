--Discount Effects

--Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.
--(In this assignment, you are expected to generate a solution using SQL with a logical approach. )

SELECT	 * 
FROM	 sale.order_item
ORDER BY product_id


SELECT		product_id,
			discount, 
			COUNT(order_id) AS cnt_of_orders, 
			SUM(quantity) AS sum_of_quantities,
			AVG(quantity * 1.0)
FROM		sale.order_item
GROUP BY	product_id, discount
ORDER BY	1,2 ;



SELECT		DISTINCT product_id,
			discount,
			AVG(discount) OVER(PARTITION BY product_id) as avg_discount,
			AVG(quantity * 1.0) OVER(PARTITION BY product_id) as avg_quantity
FROM		sale.order_item;

---ALTTAKI SORUDAN ILHAM AL. LEAD VEYA FONKSIYONLARINI KULLANARAK COZMEYE CALIS

--QUESTION: Write a query that returns the difference order count between the current month and the next month for each year. 
--(Her bir yýl için peþ peþe gelen aylarýn sipariþ sayýlarý arasýndaki farklarý bulunuz)


SELECT  order_year,
		order_month,
		cnt_of_orders,
		cnt_of_orders - LEAD(cnt_of_orders) OVER (PARTITION BY order_year ORDER BY order_year) AS [difference]

FROM (
		SELECT	DISTINCT
				YEAR(order_date) AS order_year,
				MONTH(order_date) AS order_month,
				COUNT(order_id) OVER(PARTITION BY YEAR(order_date), MONTH(order_date)) AS cnt_of_orders
		FROM sale.orders
	) AS subq;





--A
SELECT
  product_id,
  (
    SUM((discount - avg_discount) * (quantity - avg_quantity))
    / (COUNT(*) - 1) 
  ) / (CASE WHEN STDEV(discount) = 0 THEN 1 ELSE STDEV(discount) END * CASE WHEN STDEV(quantity) = 0 THEN 1 ELSE STDEV(quantity) END) as correlation
FROM (
  SELECT
    product_id,
    discount,
    quantity,
    AVG(discount) OVER(PARTITION BY product_id) as avg_discount,
    AVG(quantity * 1.0) OVER(PARTITION BY product_id) as avg_quantity
  FROM sale.order_item
) as merkezilestirilmis
GROUP BY product_id
HAVING COUNT(*) > 1;



