--CASE Expression

-- 1 -) Classify staff according to the count of orders they receive as follows:

--a) 'High-Performance Employee' if the number of orders is greater than 400
--b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
--c) 'Low-Performance Employee' if the number of orders is between 1 and 100
--d) 'No Order' if the number of orders is 0
--Then, list the staff's first name, last name, employee class, and count of orders.  (Count of orders and first names in ascending order)

SELECT 
	first_name,
	last_name,
	CASE 
		WHEN COUNT(order_id) > 400 THEN 'High-Performance Employee'
		WHEN COUNT(order_id) > 99 AND COUNT(order_id) < 401 THEN 'Normal-Performance Employee'
		WHEN COUNT(order_id) > 0 AND COUNT(order_id) < 100 THEN 'Low-Performance Employee'
		WHEN COUNT(order_id) = 0 THEN 'No Order'
	END AS employee_class,
	COUNT(order_id) AS Count_of_orders
FROM 
	sale.staff as st
	LEFT JOIN sale.orders AS sl ON st.staff_id = sl.staff_id
GROUP BY
	first_name,
	last_name
ORDER BY 
Count_of_orders, first_name


-- 2-) List counts of orders on the weekend and weekdays. Submit your answer in a single row with two columns. For example: 164 161. First value is for weekend.

