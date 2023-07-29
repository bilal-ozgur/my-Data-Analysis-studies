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

  WITH		JanuaryCustomers AS (
	  SELECT    DISTINCT Cust_ID
	  FROM		e_commerce_data
	  WHERE		MONTH(Order_Date) = 1
	  ), Allmonths AS (
	  SELECT DISTINCT DATEPART(YEAR, Order_Date) AS [year],
					  DATEPART(MONTH, Order_Date) AS [month]
	  FROM e_commerce_data
	  WHERE DATEPART(YEAR, Order_Date ) = 2011
	  ), MonthlyCustomers AS (
	  SELECT Cust_ID,
			 COUNT(DISTINCT DATEPART(MONTH, Order_Date)) AS months_count
	  FROM e_commerce_data
	  WHERE DATEPART(YEAR, Order_Date) = 2011
	  GROUP BY Cust_ID
	  )
	SELECT COUNT(*)
	FROM JanuaryCustomers AS a
	JOIN MonthlyCustomers AS b ON a.Cust_ID = b.Cust_ID
	WHERE b.months_count = (SELECT COUNT(*) FROM Allmonths)




  SELECT    *
  FROM		e_commerce_data

