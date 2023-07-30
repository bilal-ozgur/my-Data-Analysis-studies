-- 1. Find the top 3 customers who have the maximum count of orders.

  SELECT	Cust_ID, SUM(Order_Quantity) AS total_qty_order
  FROM		e_commerce_data
  GROUP BY	Cust_ID
  ORDER BY	total_qty_order DESC;




  -- 2. Find the customer whose order took the maximum time to get shipping.

  SELECT    TOP 1 Cust_ID, Customer_Name, Province, Region,  Order_Date, Ship_Date, DaysTakenForShipping
  FROM		e_commerce_data
  ORDER BY	DaysTakenForShipping DESC;




  -- 3. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

--First, let's find unique customers in January;

SELECT	DISTINCT Cust_ID
FROM	e_commerce_data
WHERE	MONTH(Order_Date) = 1;

--Second, let's find how many of these customers came back month by month in 2011;

SELECT
		DATENAME(MONTH, order_date) AS month_of_year,
	    COUNT(DISTINCT Cust_ID) AS cnt_of_order
FROM    e_commerce_data
WHERE   YEAR(Order_Date) = 2011 AND
		Cust_ID IN ( SELECT	DISTINCT Cust_ID
					FROM	e_commerce_data
					WHERE	MONTH(Order_Date) = 1 AND
							YEAR(Order_Date) = 2011
					)	
GROUP BY
		DATENAME(MONTH, order_date);



-- 4. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.

-- First, let's find customers, their orders and their previous orders

SELECT  Cust_ID, Order_Date, first_ord_date,
		DATEDIFF(DAY, first_ord_date, Order_Date) AS day_diff
FROM	(
		SELECT	Ord_ID, Cust_ID, Order_Date,
				ROW_NUMBER() OVER(PARTITION BY Cust_ID ORDER BY Order_Date) AS orders_rows,
				MIN(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_Date) AS first_ord_date
		FROM	e_commerce_data
		) AS subq
WHERE	orders_rows = 3
ORDER BY Cust_ID;




-- 5. Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.

--First, let's find customers purchased both product 11 and product 14
SELECT		Cust_ID, 
			SUM(Order_Quantity) AS sum_of_quantity			
FROM		e_commerce_data
WHERE		Prod_ID IN ('Prod_14','Prod_11')
GROUP BY	Cust_ID
HAVING		COUNT(DISTINCT Prod_ID) = 2;


--Then, let's find ratio of these products to the total number of products purchased by the customer
WITH t1 AS (
			SELECT		Cust_ID
						,SUM(Order_Quantity) AS sum_of_quantity			
			FROM		e_commerce_data
			WHERE		Prod_ID IN ('Prod_14','Prod_11')
			GROUP BY	Cust_ID
			HAVING		COUNT(DISTINCT Prod_ID) = 2		
			)
SELECT	DISTINCT 
		a.Cust_ID, sum_of_quantity,
		SUM(Order_Quantity) OVER(PARTITION BY b.Cust_ID) AS overall_quantity,
		CAST(sum_of_quantity / SUM(Order_Quantity) OVER(PARTITION BY b.Cust_ID) AS decimal(3,2))  AS ratio 
FROM	t1 AS a,
		e_commerce_data AS B
WHERE	a.Cust_ID = b.Cust_ID;
