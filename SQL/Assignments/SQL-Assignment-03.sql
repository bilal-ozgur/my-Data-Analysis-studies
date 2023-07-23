--SQL ASSIGNMENT - 03 - Q2319 BILAL TALHA OZGUR
--Discount Effects 

--Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.
--(In this assignment, you are expected to generate a solution using SQL with a logical approach. )



---PREPARATION OF TABLES:

CREATE VIEW discount_effect AS
WITH t1 AS
	(
	SELECT	product_id,
			discount,
			cnt_of_orders,
			sum_of_quantities,
			sum_of_quantities - LAG(sum_of_quantities) OVER (PARTITION BY product_id ORDER BY product_id) AS diff_quantities
	FROM (
		SELECT	DISTINCT
				product_id,
				discount,
				COUNT(order_id) OVER(PARTITION BY product_id, discount) AS cnt_of_orders,
				SUM(quantity) OVER(PARTITION BY product_id, discount) AS sum_of_quantities
		FROM sale.order_item
		) AS subq
		)
SELECT  product_id,
		discount,
		cnt_of_orders,
		sum_of_quantities,
		diff_quantities,
		SUM(diff_quantities) OVER(PARTITION BY product_id) AS sum_diff
FROM	t1;

-----SOLUTION:

SELECT	product_id,
		Discount_Effect
FROM (		
		SELECT	 product_id,
				 CASE 
					WHEN sum_diff > 3 THEN 'Positive'
					WHEN sum_diff < -3 THEN 'Negative'
					ELSE 'Neutral'
				 END AS Discount_Effect
		FROM	 discount_effect
	) AS subq
GROUP BY product_id, Discount_Effect
ORDER BY 1;

