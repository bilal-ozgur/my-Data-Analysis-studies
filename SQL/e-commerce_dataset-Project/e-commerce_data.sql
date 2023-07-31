--Before starting let's convert our ID columns into the numeric values

UPDATE [dbo].e_commerce_data
SET Ord_ID = SUBSTRING(Ord_ID, CHARINDEX('_', Ord_ID) + 1 , LEN(Ord_ID)),
	Cust_ID = SUBSTRING(Cust_ID, CHARINDEX('_', Cust_ID) + 1 , LEN(Cust_ID)),
	Prod_ID = SUBSTRING(Prod_ID, CHARINDEX('_', Prod_ID) + 1 , LEN(Prod_ID)),
	Ship_ID = SUBSTRING(Ship_ID, CHARINDEX('_', Ship_ID) + 1 , LEN(Ship_ID));


ALTER TABLE e_commerce_data ALTER COLUMN Ord_ID INT
ALTER TABLE e_commerce_data ALTER COLUMN Cust_ID INT
ALTER TABLE e_commerce_data ALTER COLUMN Prod_ID INT
ALTER TABLE e_commerce_data ALTER COLUMN Ship_ID INT

ALTER TABLE e_commerce_data ALTER COLUMN Order_Date DATE
ALTER TABLE e_commerce_data ALTER COLUMN Ship_Date DATE


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
WHERE		Prod_ID IN ('14','11')
GROUP BY	Cust_ID
HAVING		COUNT(DISTINCT Prod_ID) = 2;


--Then, let's find ratio of these products to the total number of products purchased by the customer

WITH t1 AS (
			SELECT		Cust_ID
						,SUM(Order_Quantity) AS sum_of_quantity			
			FROM		e_commerce_data
			WHERE		Prod_ID IN ('14','11')
			GROUP BY	Cust_ID
			HAVING		COUNT(DISTINCT Prod_ID) = 2		
			)
SELECT	DISTINCT 
		a.Cust_ID, sum_of_quantity,
		SUM(Order_Quantity) OVER(PARTITION BY b.Cust_ID) AS overall_quantity,
		FORMAT(sum_of_quantity / SUM(Order_Quantity) OVER(PARTITION BY b.Cust_ID), 'P', 'EN-US')  AS ratio 
FROM	t1 AS a,
		e_commerce_data AS B
WHERE	a.Cust_ID = b.Cust_ID;




-- Customer Segmentation
-- Categorize customers based on their frequency of visits. The following steps will guide you. If you want, you can track your own way.


-- 1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)

CREATE VIEW monthly_visit_log AS
SELECT	DISTINCT Ord_ID,
		Cust_ID,
		YEAR(Order_Date) AS [year],
		MONTH(Order_Date) AS [month]
FROM	e_commerce_data;

--Let's run this view
SELECT	*
FROM	monthly_visit_log;




-- 2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)

--Let's create view that returns number of monthly visits by users

CREATE VIEW cnt_of_monthly_visits AS
SELECT   YEAR(Order_Date) AS Years,
		 MONTH(Order_Date) AS Months,
		 COUNT(Ord_ID) AS cnt_of_orders
FROM	 e_commerce_data
GROUP BY YEAR(Order_Date),
		 MONTH(Order_Date);

--Let's run our view:
SELECT	*
FROM	cnt_of_monthly_visits;



--Let's create view that returns monthly count of visits by each users
CREATE VIEW cnt_of_monthly_user_visits AS
SELECT   Cust_ID,
		 YEAR(Order_Date) AS Years,
		 MONTH(Order_Date) AS Months,
		 COUNT(Ord_ID) AS cnt_of_orders
FROM	 e_commerce_data
GROUP BY Cust_ID,YEAR(Order_Date),
		 MONTH(Order_Date);


--Let's run this view:
SELECT	*
FROM	cnt_of_monthly_user_visits;



--3. For each visit of customers, create the next month of the visit as a separate column.

SELECT	DISTINCT Ord_ID,
		Cust_ID, 
		Order_Date,
		LEAD(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_Date ) AS next_month
FROM   (SELECT	DISTINCT Ord_ID,
				Cust_ID, 
				Order_Date
		FROM	e_commerce_data) AS subq


--4. Calculate the monthly time gap between two consecutive visits by each customer.


SELECT	DISTINCT Ord_ID,
		Cust_ID, 
		Order_Date,
		LEAD(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_Date ) AS next_month,
		DATEDIFF(MONTH, Order_Date,LEAD(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_Date )) AS month_diff
FROM   (SELECT	DISTINCT Ord_ID,
				Cust_ID, 
				Order_Date
		FROM	e_commerce_data) AS subq



--5. Categorise customers using average time gaps. Choose the most fitted labeling model for you.

--Let's create view that keeps customers' average time gaps

CREATE VIEW customer_retention AS
WITH t1 AS (
SELECT	DISTINCT Ord_ID,
		Cust_ID, 
		Order_Date,
		LEAD(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_Date ) AS next_month,
		DATEDIFF(MONTH, Order_Date,LEAD(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_Date )) AS month_diff
FROM   (SELECT	DISTINCT Ord_ID,
				Cust_ID, 
				Order_Date
		FROM	e_commerce_data) AS subq
		)
SELECT  *,
		AVG(month_diff) OVER(PARTITION BY Cust_ID) AS customers_avg_gaps,	
		AVG(month_diff) OVER() AS avg_gaps
FROM	t1;


--Let's use this view and categorise customers' most fitted labeling model

SELECT DISTINCT Cust_ID,
	CASE 
		WHEN customers_avg_gaps IS NULL THEN 'CHURN'
		WHEN customers_avg_gaps > avg_gaps THEN 'NOT SATISFIED'
		WHEN customers_avg_gaps < avg_gaps THEN 'SATISFIED'
		WHEN customers_avg_gaps = 0 THEN 'REGULAR'
		WHEN customers_avg_gaps = avg_gaps THEN 'AVERAGE'
	END AS [status]
FROM customer_retention
ORDER BY 1;






--Month-Wise Retention Rate

--Find month-by-month customer retention rate since the start of the business.

-- Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month


--Let's find total Number of customers by months

SELECT	YEAR(Order_Date) AS "Year",
		MONTH(Order_Date) AS "Month",
		COUNT(DISTINCT Cust_ID) AS cnt_customers
FROM	e_commerce_data
GROUP BY YEAR(Order_Date),
		 MONTH(Order_Date);

--Let's find number of Customers Retained in The Current Month

--I am stuck here. No time :( 
SELECT	*
FROM	(
		SELECT	YEAR(Order_Date) AS "Year",
				MONTH(Order_Date) AS "Month",
				COUNT(DISTINCT Cust_ID) AS retained_customers
		FROM	e_commerce_data
		GROUP BY YEAR(Order_Date),
				 MONTH(Order_Date)
		) as a
PIVOT
	(
	COUNT(Cust_ID)
	FOR "Month" IN ([1], [2], [3], [4],[5], [6], [7], [8],[9], [10], [11], [12])
	) AS pivot_table


--I am stuck here :( 


SELECT	*
FROM	e_commerce_data



