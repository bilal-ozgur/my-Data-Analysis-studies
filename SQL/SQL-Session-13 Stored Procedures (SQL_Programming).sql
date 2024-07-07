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


-- ���NE PARAMETRE ALAN DE���KEN B�R PROCEDURE OLU�TURALIM --
-- �stenilen tarihte ki sipari� adetini d�nd�ren bir proc. tan�mlay�n
GO
CREATE PROC sp_sample_proc1 ( @ORD_DATE DATE ) AS
BEGIN
	SELECT COUNT(ORDER_ID)
	FROM  ORDER_TBL
	WHERE ORDER_DATE = @ORD_DATE
END;

EXEC sp_sample_proc1 '2024-07-01'

-- ���NE 2 PARAMETRE ALAN B�R PROCEDURE YAZALIM
-- �stenilen m��terinin istenilen tarihteki sipari� bilgilerini d�nd�ren bir proc. tan�mlay�n

GO
CREATE PROC sp_customer_orders_1 (@CUST_NAME VARCHAR(50), @ORDER_DATE DATE = '2024-07-01' ) AS 
-- = (e�ittir) ile parametreye default de�er at�labilinir
BEGIN
	SELECT *
	FROM ORDER_TBL
	WHERE CUSTOMER_NAME = @CUST_NAME
	AND ORDER_DATE = @ORDER_DATE
END;

EXECUTE sp_customer_orders_1 'John', '2024-07-02'

