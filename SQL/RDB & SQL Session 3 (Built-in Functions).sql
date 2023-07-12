

SELECT GETDATE()



-- Data Types


CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

	

SELECT *
FROM t_date_time


SELECT GETDATE()

INSERT t_date_time 
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())



INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )



SELECT *
FROM t_date_time


-----------
SELECT GETDATE();

SELECT	DAY(GETDATE()), 
		MONTH(GETDATE()),
		YEAR(GETDATE()),
		DATEPART(WEEKDAY, GETDATE()),
		DATENAME(WEEKDAY, GETDATE()),
		DATENAME(MONTH, GETDATE()),
		DATEPART(QUARTER, GETDATE())

-----


SELECT DATEDIFF(DAY, '2000-12-01', GETDATE())

SELECT DATEDIFF(YEAR, '2000-12-01', GETDATE())



SELECT DATEDIFF(MINUTE, '2000-12-01', GETDATE())

SELECT DATEDIFF(MINUTE, '2000-12-01 00:00:00', GETDATE())


SELECT order_date, required_date,  DATEDIFF(DAY, order_date, required_date)
FROM sale.orders



SELECT GETDATE();
SELECT DATEADD(DAY, 3, GETDATE())
		, DATEADD(MINUTE, 3, GETDATE())



--Write a query returns orders that are shipped more than two days after the order date. 


SELECT *, DATEDIFF(DAY, order_date, shipped_date) shipped_date_diff
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



SELECT *, DATEADD(DAY, 2, order_date)
FROM sale.orders
WHERE shipped_date > DATEADD(DAY, 2, order_date);



--------



----STRING FUNCTIONS

SELECT len('Ali'), len('Abdurrahman')
--
SELECT CAST('Ali' AS CHAR(20))

Ali                 
--
SELECT CAST('Ali' AS varCHAR(20))

Ali
--
SELECT CAST('Abdurrahman' AS varCHAR(20))

Abdurrahman
--

SELECT len('Ali'), len('Abdurrahman')


SELECT CHARINDEX('D', 'Abdurrahman')


SELECT CHARINDEX('D', 'Abdurrahman', 4)


SELECT CHARINDEX('A', 'Abdurrahman')


SELECT CHARINDEX('A', 'Abdurrahman', 2)


SELECT PATINDEX('%RR%', 'Abdurrahman')


SELECT PATINDEX('%RR', 'Abdurrahman')


----

SELECT LEFT('CHARACTER', 3)


SELECT LEFT('  CHARACTER', 3)


SELECT RIGHT('CHARACTER', 5)


SELECT SUBSTRING('CHARACTER', 3, 5)


----

SELECT TRIM('  CHARACTER  ')
--CHARACTER


SELECT LTRIM('  CHARACTER  ')
--CHARACTER  

SELECT RTRIM('  CHARACTER  ')
--  CHARACTER



SELECT TRIM('/* ' FROM ' /* CHARACTER /* ')

--CHARACTER

---


SELECT REPLACE('CHARACTER', 'AC', '/')



SELECT REPLACE('/CHA/RACTER/', '/', '')

---

SELECT LOWER('CHARACTER')

SELECT UPPER('character')


----

SELECT 'CHAR' + 'ACTER'

SELECT CONCAT('CHAR' , 'ACTER')

SELECT 1 + 1


---Title yapacak bir fonksiyon yazýnýz


SELECT UPPER(LEFT('character', 1))


SELECT SUBSTRING('character', 2, LEN('character'))

SELECT UPPER(LEFT('character', 1)) + LOWER(SUBSTRING('character', 2, LEN('character')))


SELECT UPPER(LEFT('aHMET', 1)) + LOWER(SUBSTRING('aHMET', 2, LEN('aHMET')))





SELECT UPPER(LEFT(first_name, 1)) + LOWER(SUBSTRING(first_name, 2, LEN(first_name)))
FROM sale.customer


-----


-----


SELECT CAST(19.99 AS INT)


SELECT CAST(19.99 AS decimal(3, 1))


SELECT CAST(19.99 AS decimal(5, 3))


SELECT CONVERT(INT , 19.99)


SELECT CONVERT(DATE, GETDATE())


SELECT CONVERT(VARCHAR, GETDATE(), 110)


SELECT CONVERT(VARCHAR, GETDATE(), 111)


SELECT CONVERT(DATE, '2023/07/08')

SELECT CONVERT(DATE, '07-22-2023', 110)

---sp_help 'sale.orders'


SELECT ROUND(10.453, 2)


SELECT ROUND(10.456, 2)



SELECT ROUND(10.456, 2, 0)


SELECT ROUND(10.456, 2, 1)


----


SELECT ISNULL(NULL , 'Ali')


SELECT ISNULL(NULL , 1)

SELECT ISNULL(NULL , 1)



SELECT * , ISNULL(CAST(shipped_date AS VARCHAR(20)), 'KARGOLANMAMIS')
FROM sale.orders


----


SELECT COALESCE(NULL, NULL, 'ALÝ', 'VELÝ')


SELECT NULLIF('AHMET', 'ALÝ')

SELECT NULLIF('AHMET', 'AHMET')


SELECT *, NULLIF(state, 'TX')
FROM sale.customer







