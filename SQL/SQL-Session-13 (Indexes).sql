--SQL Session-14 (Indexes)

--Bir sorgunun en performanslý hali idealde sorgu costunun %100 Index Seek yöntemi ile 
--getiriliyor olmasýdýr!


--creating a new table
---------------------------------------------------

CREATE TABLE website_visitor(
		visitor_id int IDENTITY(1,1),
		first_name varchar(50),
		last_name varchar(50),
		phone_number bigint,
		city varchar(50)
);


--inserting random values into the table
---------------------------------------------------

DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT 
			'visitor_name' + cast (@i as varchar(20)) 
			,'visitor_surname' + cast (@i as varchar(20))
			,5326559632 + @i 
			,'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;

SELECT * FROM website_visitor


--STATISTICS
---------------------------------------------------

SET STATISTICS IO ON
--SET STATISTICS TIME ON



--without primary key/clustered index
---------------------------------------------------

SELECT *
FROM website_visitor
WHERE visitor_id=100   --SELECT 1879*8  -- 15032 KB, table scan

EXEC sp_spaceused website_visitor  --15032 KB


--with primary key/clustered index
---------------------------------------------------

--CREATE CLUSTERED INDEX cls_idx ON website_visitor(visitor_id)
--ya da

--ALTER TABLE website_visitor
--ADD CONSTRAINT pk_idx PRIMARY KEY (visitor_id)

SELECT *
FROM website_visitor
WHERE visitor_id=100   --SELECT 3*8  -- 24 KB, clustered_index_seek

EXEC sp_spaceused website_visitor  --15304 KB


--without nonclustered index
---------------------------------------------------

SELECT *
FROM website_visitor
WHERE first_name='visitor_name200'


--with nonclustered index
---------------------------------------------------

CREATE NONCLUSTERED INDEX ncls_idx ON website_visitor(first_name)

SELECT *
FROM website_visitor
WHERE first_name='visitor_name200'

EXEC sp_spaceused website_visitor  --22416 KB, index_size: 6544



--with nonclustered index and multiple columns
---------------------------------------------------

CREATE INDEX ncls_idx
ON website_visitor(first_name)
INCLUDE([last_name], [phone_number], [city])
WITH(DROP_EXISTING=ON)

SELECT *
FROM website_visitor
WHERE first_name='visitor_name200'

EXEC sp_spaceused website_visitor  --30032 KB, index_size: 14216


--filtering another column of nonclustered index
---------------------------------------------------


SELECT *
FROM website_visitor
WHERE city='city44'
ORDER BY last_name


CREATE NONCLUSTERED INDEX [xxx]
ON [dbo].[website_visitor] ([city])
INCLUDE ([first_name],[last_name],[phone_number])

SET STATISTICS IO OFF

DROP INDEX ncls_idx ON [website_visitor]

DROP TABLE [website_visitor]