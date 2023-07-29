
----SQL Programming Basics

CREATE PROCEDURE sp_sampleproc_1 AS
BEGIN
	SELECT 'HELLO WORLD' AS [Message]

END;


EXECUTE sp_sampleproc_1;

EXEC sp_sampleproc_1;

sp_sampleproc_1;



ALTER PROCEDURE sp_sampleproc_1 AS
BEGIN
	PRINT 'HELLO WORLD'

END;


EXEC sp_sampleproc_1


---------------------------------

CREATE TABLE ORDER_TBL
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);


INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 );

SELECT	*
FROM	ORDER_TBL;

---------


CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);


INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 );

SELECT	*
FROM	ORDER_DELIVERY


--LET'S CREATE PROCEDURE THAT RETURN COUNT OF ORDERS AND RUN IT


CREATE PROC	sp_ord_count_1 AS
BEGIN
	SELECT	COUNT(ORDER_ID)
	FROM	ORDER_TBL
END;

EXEC sp_ord_count_1


---LET'S CREATE PROCEDURE THAT RETURNS MAX. ORDER AND RUN IT

CREATE PROC	sp_ord_count_2 AS
BEGIN
	SELECT	MAX(ORDER_ID)
	FROM	ORDER_TBL
END;

EXEC sp_ord_count_2


--LET'S INSERT VALUE TO OUR TABLE AND LET'S SEE HOW OUR PROCEDURE ACTS


INSERT ORDER_TBL VALUES(9,9, NULL, NULL, NULL);

SELECT	*
FROM	ORDER_TBL;

--AS WE UPDATE OUR TABLE, RESULT OF THE PROCEDURE WILL CHANGE:
--(Tablomuzu güncelledikçe prosedürün sonucu deðiþecek)

EXECUTE sp_ord_count_2;






--ANOTHER PROCEDURE
--LET'S CREATE PROCEDURE THAT RETURNS COUNT OF ORDERS GIVEN IN DATE PARAMETER 
--(Verilen tarihte kaç tane sipariþ olduðunu dönen bir prosedür yazalým)

CREATE PROC	sp_sample_proc1 ( @ORD_DATE DATE )
AS

BEGIN
	SELECT  COUNT(ORDER_ID)
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @ORD_DATE
END;

EXEC sp_sample_proc1 '2023-07-28'




--DEFINE A PROCEDURE THAT RETURNS THE ORDER DETAILS OF DESIRED CUSTOMER ON THE REQUESTED DATE:
--(Ýstenilen müþterinin istenilen tarihteki sipariþ bilgilerini döndüren bir proc. tanýmlayýn):


CREATE PROC sp_customer_orders_1 ( @CUST VARCHAR(50), @DAY DATE = '2023-07-22' )
--WE CAN DEFINE DEFAULT VALUE FOR PARAMETERS WHICH WILL RETURN IF NOTHING ENTERED
AS
BEGIN
	SELECT	*
	FROM	ORDER_TBL
	WHERE	CUSTOMER_NAME = @CUST
	AND ORDER_DATE = @DAY
END;


EXEC sp_customer_orders_1 'Jack' ;

EXEC sp_customer_orders_1 'Jack' , '2023-07-25';


-------------

----\\\   QUERY VARIABLE   ///-----


--DEFINING THE VARIABLES
--(Degiskenleri tanimlama)

DECLARE @V1 INT
DECLARE @V2 INT
DECLARE @RESULT INT 

DECLARE @V1 INT, @V2 INT, @RESULT INT


--ASSIGNING VALUES
--(Deðer Atama)

--SET or SELECT

--SET @V1 = 5

--SELECT @V2 = 6

--SELECT @RESULT = @V1 * @V2

SELECT @V1 = 5, @V2 = 6, @RESULT = @V1 * @V2

--RETURNING RESULT
--(SONUCU CAGIRMA)

SELECT @RESULT   --Error. Needs to select and execute all from declare


--------

DECLARE @V1 INT = 5, @V2 INT = 6
DECLARE @RESULT INT = @V1 * @V2
SELECT @RESULT


------------

DECLARE @CUST_ID INT

SET	@CUST_ID = 1

SELECT	*
FROM	ORDER_TBL
WHERE	CUSTOMER_ID = @CUST_ID


------------

---\\\\  IF, ELSE IF, ELSE  ///////--


IF CONDITION_1
	SELECT ....

ELSE IF CONDITION_2	
	SELECT ....

ELSE
	SELECT ....

--------

DECLARE @ORDER INT 
DECLARE @EST_DEL_DATE DATE
DECLARE @DEL_DATE DATE

SET @ORDER = 2

SELECT	@EST_DEL_DATE = EST_DELIVERY_DATE
FROM	ORDER_TBL
WHERE	ORDER_ID = @ORDER

SELECT	@DEL_DATE = DELIVERY_DATE
FROM	ORDER_DELIVERY
WHERE	ORDER_ID = @ORDER

SELECT	@EST_DEL_DATE, @DEL_DATE


IF @EST_DEL_DATE = @DEL_DATE
	PRINT 'ON TIME'
ELSE IF @EST_DEL_DATE > @DEL_DATE
	PRINT 'EARLY'
ELSE PRINT 'LATE'


SELECT	*
FROM	ORDER_TBL AS A,
		ORDER_DELIVERY AS B
WHERE	A.ORDER_ID = B.ORDER_ID



--------

--Commonly used with EXISTS
--(EXISTS ile cok kullanilir.)


IF EXISTS ( SELECT 1 )
	PRINT 'YES'
ELSE 
	PRINT 'NO' 



IF NOT EXISTS ( SELECT 1 )
	PRINT 'YES'
ELSE 
	PRINT 'NO' 



-----Write a query that prints 'lower than 2' if the number of orders placed on the requested date is less than 2, count of orders itself if the number of orders is between 2 and 5, and 'upper than 5' if it is greater than 5.
---( Ýstenilen tarihte verilen sipariþ sayýsý 2 ten küçükse 'lower than 2', 2 ile 5 arasýndaysa sipariþ sayýsý, 5' den büyükse 'upper than 5' yazdýran bir sorgu yazýnýz. )


DECLARE @DATE DATE
DECLARE @ORDER_CNT INT

SET @DATE = '2023-07-28'

SELECT	@ORDER_CNT = COUNT(ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @DATE

IF @ORDER_CNT < 2
	PRINT 'LOWER THAN 2'
ELSE IF @ORDER_CNT BETWEEN 2 AND 5
	SELECT @ORDER_CNT
ELSE	
	PRINT 'UPPER THAN 5'


--LET'S CONVERT THIS CODE ABOVE INTO PROCEDURE

CREATE PROCEDURE sp_ordersday_1 (@DATE DATE) AS
BEGIN

DECLARE @ORDER_CNT INT

SELECT	@ORDER_CNT = COUNT(ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @DATE

IF @ORDER_CNT < 2
	PRINT 'LOWER THAN 2'
ELSE IF @ORDER_CNT BETWEEN 2 AND 5
	SELECT @ORDER_CNT
ELSE	
	PRINT 'UPPER THAN 5'

END;

--Let's execute the procedure:

EXEC sp_ordersday_1 '2023-07-28'





---\\\\  WHILE  /////---


--Start Value

--Ending Value

--Iteration Command


DECLARE @START INT, @END INT

SET @START = 1

SET @END  = 50

WHILE @START <= @END
BEGIN
	PRINT @START
	SET @START += 1
END;


--CONTINUE
--BREAK   

--------------------

--- \\\   USER DEFINED FUNCTIONS  /// ---


----Scalar-Valued Functions ( Tek bir deger donen fonksiyonlar )

CREATE FUNCTION sp_lower_string ( @STRING VARCHAR(100) )
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN LOWER( @STRING )
END;

sp_lower_string('Hello World')  --ERROR

SELECT sp_lower_string ( 'HELLO WORLD' ) --ERROR

EXECUTE dbo.sp_lower_string ( 'HELLO WORLD' ) --ERROR

SELECT dbo.sp_lower_string ( 'HELLO WORLD' )
--Needs to call Scalar-Valued Functions with their scheme (dbo.) and using SELECT


--LET'S TRY THIS FUNCTION ON TABLE'S COLUMN VALUES 
SELECT	dbo.sp_lower_string (CUSTOMER_NAME)
FROM	ORDER_TBL




--Define a function that converts the initial letter of the string it receives to uppercase and the others to lowercase.
--(Aldigi stringin bas harfini buyuk, digerlerini kucuk harfe donusturen bir fonksiyon tanimlayin.)


CREATE FUNCTION fn_title_1 (@STRING VARCHAR(32))
RETURNS VARCHAR(32)
AS
BEGIN
	RETURN UPPER(LEFT (@STRING, 1)) + LOWER(SUBSTRING(@STRING, 2, LEN(@STRING)))
END;


SELECT dbo.fn_title_1 ('bilal')


---------------


DECLARE @ORDER INT 
DECLARE @EST_DEL_DATE DATE
DECLARE @DEL_DATE DATE

SET @ORDER = 2

SELECT	@EST_DEL_DATE = EST_DELIVERY_DATE
FROM	ORDER_TBL
WHERE	ORDER_ID = @ORDER

SELECT	@DEL_DATE = DELIVERY_DATE
FROM	ORDER_DELIVERY
WHERE	ORDER_ID = @ORDER

SELECT	@EST_DEL_DATE, @DEL_DATE


IF @EST_DEL_DATE = @DEL_DATE
	PRINT 'ON TIME'
ELSE IF @EST_DEL_DATE > @DEL_DATE
	PRINT 'EARLY'
ELSE PRINT 'LATE'


CREATE FUNCTION dbo.fn_order_status (@ORDER INT)
RETURNS VARCHAR(10)
AS
BEGIN
		DECLARE @EST_DEL_DATE DATE
		DECLARE @DEL_DATE DATE
		DECLARE @STATUS VARCHAR(10)
		SELECT	@EST_DEL_DATE = EST_DELIVERY_DATE
		FROM	ORDER_TBL
		WHERE	ORDER_ID = @ORDER
		SELECT	@DEL_DATE = DELIVERY_DATE
		FROM	ORDER_DELIVERY
		WHERE	ORDER_ID = @ORDER
		IF @EST_DEL_DATE = @DEL_DATE
			SET @STATUS = 'ON TIME'
		
		ELSE IF @EST_DEL_DATE > @DEL_DATE
			SET @STATUS = 'EARLY'
		ELSE SET @STATUS = 'LATE'
RETURN @STATUS
END;

SELECT	dbo.fn_order_status(1) AS [STATUS];



----Table Valued Functions ( Bir tablo dönen fonksiyonlar )



--EXAMPLE 1 - WITHOUT PARAMETERS

CREATE FUNCTION fn_table_values_1 ()
RETURNS TABLE
AS

RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE < '2023-07-26';

--RETURN THE FUNCTION 
--(Yazilan fonksiyonun cagrilmasi)

SELECT	*
FROM	dbo.fn_table_values_1();



--EXAMPLE 2 - WITH PARAMETERS

CREATE FUNCTION fn_table_values_2 (@DATE DATE)
RETURNS TABLE
AS

RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE < @DATE;

SELECT	*
FROM	dbo.fn_table_values_2('2023-07-27');


-----
--CREATING TABLE FUNCTION WITH VARIABLE

DECLARE @TABLE1 TABLE(ID INT, NAME VARCHAR(32))

INSERT	@TABLE1 VALUES ( 1 , 'Ahmet')

SELECT	*
FROM	@TABLE1

----

CREATE FUNCTION fn_table_valued_3 (@ORDER INT)
RETURNS @TABLE TABLE(ID INT, NAME VARCHAR(32))
AS
BEGIN
	INSERT  @TABLE
	SELECT	CUSTOMER_ID, CUSTOMER_NAME
	FROM	ORDER_TBL
	WHERE	dbo.fn_order_status(@ORDER) = 'ON TIME'
			AND ORDER_ID = @ORDER

RETURN
END;


SELECT	*
FROM	dbo.fn_table_valued_3(3);
