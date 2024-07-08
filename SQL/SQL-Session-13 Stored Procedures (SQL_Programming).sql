USE SampleRetail

SELECT * FROM [dbo].[ORDER_DELIVERY]


-- 2 TANE PROCEDURE OLUSTURALIM

-- 1
GO
CREATE PROCEDURE sp_ord_count_1 AS
BEGIN
	SELECT COUNT(ORDER_ID)
	FROM   ORDER_TBL
END;


EXECUTE sp_ord_count_1

-- 2

GO
CREATE PROC sp_ord_count_2 AS
BEGIN
	SELECT MAX(ORDER_ID)
	FROM   ORDER_TBL
END;

EXEC sp_ord_count_2

INSERT ORDER_TBL VALUES(9,9,NULL, NULL, NULL)

EXECUTE sp_ord_count_2


-- ÝÇÝNE PARAMETRE ALAN BÝR PROCEDURE OLUÞTURALIM --
-- Ýstenilen tarihte ki sipariþ adetini döndüren bir proc. tanýmlayýn
GO
CREATE PROC sp_sample_proc1 ( @ORD_DATE DATE ) AS
BEGIN
	SELECT COUNT(ORDER_ID)
	FROM  ORDER_TBL
	WHERE ORDER_DATE = @ORD_DATE
END;

EXEC sp_sample_proc1 '2024-07-01'

-- ÝÇÝNE 2 PARAMETRE ALAN BÝR PROCEDURE YAZALIM
-- Ýstenilen müþterinin istenilen tarihteki sipariþ bilgilerini döndüren bir proc. tanýmlayýn

GO
CREATE PROC sp_customer_orders_1 (@CUST_NAME VARCHAR(50), @ORDER_DATE DATE = '2024-07-01' ) AS 
-- = (eþittir) ile parametreye default deðer atýlabilinir
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE CUSTOMER_NAME = @CUST_NAME
	AND ORDER_DATE = @ORDER_DATE
END;

EXECUTE sp_customer_orders_1 'John', '2024-07-02'


--------------------------

--- QUERY VARIABLE  ----------

-- DEGISKEN TANIMLAMA
DECLARE @V1 INT 
DECLARE @V2 INT
DECLARE @RESULT INT
--ya da 
DECLARE @V1 INT, @V2 INT, @RESULT INT


-- DEGER ATAMA
SET @V1 = 5
SET @V2 = 6
SELECT @RESULT = @V1 * @V2
-- veya
SELECT @V1 = 5 , @V2 = 6, @RESULT = @V1 * @V2


-- CAGIRMA
PRINT @RESULT
-- veya
SELECT @RESULT

------
DECLARE @V1 INT = 5, @V2 INT = 6 

DECLARE @RESULT INT = @V1 * @V2

SELECT @RESULT

----
-- BASIT BIR ILK ORNEK

DECLARE @CUST_ID INT

SET @CUST_ID = 1

SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_ID = @CUST_ID


-----------
-- IF, ELSE IF, ELSE

IF CONDITION_01
		SELECT ....
ELSE IF CONDITION_02
		SELECT .....
ELSE 
		SELECT .....

-----------------
-- Let's write the query that prints whether the delivery date is earlier or later than the estimated delivery date.
-- ( Teslimat tarihinin tahmini teslimat tarihinden erken mi gec mi oldugunu yazdiran sorguyu yazalim. )

	DECLARE @ORDER INT
	DECLARE @EST_DEL_DATE DATE
	DECLARE @DEL_DATE DATE

	SET @ORDER = 2

	SELECT @EST_DEL_DATE = EST_DELIVERY_DATE
	FROM ORDER_TBL
	WHERE ORDER_ID = @ORDER

	SELECT @DEL_DATE = DELIVERY_DATE
	FROM ORDER_DELIVERY
	WHERE ORDER_ID = @ORDER


	IF @EST_DEL_DATE = @DEL_DATE
		PRINT 'ON TIME'
	ELSE IF @EST_DEL_DATE > @DEL_DATE
		PRINT 'EARLY'
	ELSE 
		PRINT 'LATE'


-- Now let's add this to a procedure that takes parameters
-- ( Þimdi bunu parametre alan bir prosedüre ekleyelim )

CREATE PROCEDURE sp_del_check (@ORDER TINYINT) AS 
BEGIN
	DECLARE @EST_DEL_DATE DATE
	DECLARE @DEL_DATE DATE

	SELECT @EST_DEL_DATE = EST_DELIVERY_DATE
	FROM ORDER_TBL
	WHERE ORDER_ID = @ORDER

	SELECT @DEL_DATE = DELIVERY_DATE
	FROM ORDER_DELIVERY
	WHERE ORDER_ID = @ORDER


	IF @EST_DEL_DATE = @DEL_DATE
		PRINT 'ON TIME'
	ELSE IF @EST_DEL_DATE > @DEL_DATE
		PRINT 'EARLY'
	ELSE 
		PRINT 'LATE'
END;

EXECUTE sp_del_check '3'


SELECT * FROM ORDER_TBL
SELECT * FROM ORDER_DELIVERY

SELECT *
FROM ORDER_TBL A, ORDER_DELIVERY B
WHERE A.ORDER_ID = B.ORDER_ID

-- Istenilen tarihte verilen siparis sayýsý 2'den kucukse 'lower than 2',
-- 2 ile 5 arasindaysa siparisi, 5'den buyukse ''more than 5' yazdiran bir sorgu yaziniz

DECLARE @ORDER_DATE DATE
DECLARE @CNT_ORDER INT

SET @ORDER_DATE = '2024-07-04'

SELECT  @CNT_ORDER = COUNT(ORDER_ID)
FROM	ORDER_TBL
WHERE	ORDER_DATE = @ORDER_DATE

IF @CNT_ORDER < 2
	PRINT 'LOWER THAN 2'
ELSE IF @CNT_ORDER > 5
	PRINT 'MORE THAN 5'
ELSE 
	PRINT @CNT_ORDER

-- WITH STORE PROCEDURE

CREATE PROCEDURE sp_ordersday_1(@ORDER_DATE DATE) AS
BEGIN
	DECLARE @CNT_ORDER INT

	SELECT  @CNT_ORDER = COUNT(ORDER_ID)
	FROM	ORDER_TBL
	WHERE	ORDER_DATE = @ORDER_DATE

	IF @CNT_ORDER < 2
		PRINT 'LOWER THAN 2'
	ELSE IF @CNT_ORDER > 5
		PRINT 'MORE THAN 5'
	ELSE 
		PRINT @CNT_ORDER
END

EXECUTE sp_ordersday_1 '2024-07-03'


-- WHILE 

-- Start Value
-- Ending Value
-- Iteration command

DECLARE @START INT, @END INT

SET @START = 1 
SET @END = 50

WHILE @START <= @END
BEGIN
	PRINT @START
	SET @START += 1
END

--------------

-- USER DEFINED FUNCTIONS

-- Scaler-Valued Functýons

CREATE FUNCTION sp_lower_string (@STRING VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN( SELECT LOWER (@STRING) )
END;

-- YA DA

CREATE FUNCTION sp_lower_string (@STRING VARCHAR (100))
RETURNS VARCHAR (100)
AS
BEGIN
		RETURN  LOWER (@STRING)
END;

--CLARUSWAY

-- Scaler-Valued Functions, Stored Procedures'ta ki gibi cagrilmaz.
-- SELECT ile cagirilir. ve basinda dbo. sema ismi olmali

SELECT dbo.sp_lower_string('CLARUSWAY')

SELECT   dbo.sp_lower_string( CUSTOMER_NAME )
FROM	 ORDER_TBL


-- Create a function that converts the first letter of a string to uppercase and all other letters to lowercase.
-- (Aldigi stringin bas harfini buyuk, digerlerini kucuk harfe donusturen bir fonksiyon uretin.)