SELECT '07/26/1999' AS 'The Date';


--WORKING WITH CAST() FUNCTION;

SELECT CAST ('07/26/1999' AS DATETIME) AS 'The Date';

SELECT CAST('1250.00' AS decimal(10,2)) AS 'A Number';

SELECT CAST(
			CAST('6/8/1992' AS DATETIME) - 
			CAST('10/3/1989' AS DATETIME) AS INT );

SELECT order_date
FROM sale.orders;

SELECT CAST(order_date AS DATETIME) AS 'Our-casted-dates'
FROM sale.orders;

SELECT CAST(order_date AS char(12)) AS 'Our-casted-dates'
FROM sale.orders;



--WORKING WITH CONVERT() FUNCTION;

SELECT TOP 1 order_date
FROM sale.orders 

--mon dd yyyy hh:miAM/PM; Default

SELECT TOP 1 CONVERT(varchar, order_date, 100) AS order_date
FROM sale.orders 

--mm/dd/yyyy; USA
SELECT TOP 1 CONVERT(varchar, order_date, 101) AS order_date
FROM sale.orders 

--yyyy.mm.dd; ANSI
SELECT TOP 1 CONVERT(varchar, order_date, 102) AS order_date
FROM sale.orders

--dd/mm/yyyy; British/French
SELECT TOP 1 CONVERT(varchar, order_date, 103) AS order_date
FROM sale.orders

--dd/mm/yyyy; British/French
SELECT TOP 1 CONVERT(varchar, order_date, 103) AS order_date
FROM sale.orders

--dd.mm.yyyy; German
SELECT TOP 1 CONVERT(varchar, order_date, 104) AS order_date
FROM sale.orders

--dd-mm-yyyy; Italian
SELECT TOP 1 CONVERT(varchar, order_date, 105) AS order_date
FROM sale.orders

