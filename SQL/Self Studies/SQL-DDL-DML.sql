
--CREATE DATABASE
--*******************

CREATE DATABASE LibraryDB
GO

USE LibraryDB
GO


--Create Schemas
--*******************

CREATE SCHEMA Person
GO

CREATE SCHEMA Book
GO


--Create Tables
--****************

CREATE TABLE [Book].[Book] (
		[Book_ID] INT PRIMARY KEY NOT NULL,
		[Book_name] NVARCHAR(100) NOT NULL,
		[Author_ID] INT NOT NULL,
		[Publisher_ID] INT NOT NULL
		);

SELECT *
FROM Book.Book

CREATE TABLE [Book].[Author] (
		[Author_ID] INT,
		[Author_FirstName] NVARCHAR(50) NOT NULL,
		[Author_LastName] NVARCHAR(50) NOT NULL
		);


CREATE TABLE [Book].[Publisher] (
		[Publisher_ID] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[Publisher_name] NVARCHAR(MAX)  NULL
		);

CREATE TABLE [Person].[Person] (
		[SSN] BIGINT PRIMARY KEY CHECK(LEN(SSN)=11),
		[Person_FirstName] NVARCHAR(50) NULL,
		[Person_LastName] NVARCHAR(50) NULL
		);

CREATE TABLE [Person].[Loan] (
		[SSN] BIGINT NOT NULL,
		[Book_ID] INT NOT NULL,
		PRIMARY KEY([SSN],[Book_ID])
		);

CREATE TABLE [Person].[Phone] (
		[Phone_number] BIGINT PRIMARY KEY,
		[SSN] BIGINT NOT NULL REFERENCES [Person].[Person]
		);

CREATE TABLE [Person].[Mail] (
		[Mail_ID] INT PRIMARY KEY IDENTITY(1,1),
		[Mail] NVARCHAR(900) UNIQUE,
		[SSN] BIGINT  NOT NULL,
		CONSTRAINT FK_SSNum FOREIGN KEY(SSN) REFERENCES Person.Person(SSN)
		);

--INSERT
--****************************

SELECT * FROM Person.Person

INSERT INTO Person.Person ([SSN], [Person_FirstName], [Person_LastName])
VALUES (12233344445,N'Zehra',N'Tekin')

---Insert into içinde ki sütun isimleri sýrasýna göre veri eklenir:
INSERT INTO Person.Person ([Person_FirstName], [Person_LastName], [SSN])
VALUES (N'Eylem', N'Yaðýz', 99998887776)

--Tabloyu oluþtururken NULL deðer kabul edebilir dediðimiz için LastName'yi NULL olarak ekler:
INSERT INTO Person.Person ([SSN], [Person_FirstName])
VALUES (44556677889, N'Mehmet')

--It is not mandatory to use column names & INTO is optional:
INSERT Person.Person VALUES (22277799922, N'Ahmet', N'Güneri')

INSERT Person.Person VALUES (55500033395, N'Ezgi', NULL)

--primary key constraint
INSERT Person.Person VALUES (22277799922, N'Ahmet', N'Güneri')
--ERROR çünkü ayný PK'ya ayný veri girilmez!

--check constraint
INSERT Person.Person VALUES (22277, N'Ahmet', N'Güneri')
--ERROR çünkü CHECK(LEN(SSN)=11) ile sýnýrladýk SSN veri giriþini

--data types must be compatible. Veri tipleri ayný olmalý.

--------------------------------------------
--multiple entries. (birden fazla veri giriþi)

SELECT * FROM Person.Mail
SELECT * FROM Person.Person

INSERT INTO Person.Mail([Mail], [SSN])
VALUES  (N'zehratek@gmail.com', 12233344445),
		(N'ahmetgün@gmail.com', 22277799922),
		(N'eylemyagiz@hotmail.com', 99998887776)
--Mail_ID, IDENTITY(1,1) dediðimiz için sýrayla otomatik veri girer.

--foreign key constraint
INSERT INTO Person.Mail([Mail], [SSN])
VALUES  (N'bilalozgur@gmail.com', 66655544488)
--SSN ERROR verir çünkü diðer tabloda PK olan ve girilmemiþ veriyi burada ekleyemezsin.

--IDENTITY
--manuel giriþ yapýlamaz çünkü kendi veri giriþi yapýyor.

---------------------------------------------

--insert with SELECT statement

CREATE TABLE [Names] (
	[Names] NVARCHAR(100)
	);
GO 

INSERT INTO Names 
SELECT first_name FROM SampleRetail.sale.customer WHERE first_name LIKE 'M%'
--Baþka bir veri tabanýndan bir tabloda M ile baþlayan isimleri talomuza çektik. 


--SELECT INTO
--****************************

SELECT *
INTO person_person_2  --yeni oluþturulacak tablo ismi
FROM Person.Person

SELECT * FROM person_person_2
--farklý databaselerdende veri çekilebilinir.  
--veriyi taþýr. Objeleri taþýmaz (PK vs. taþýmaz)

--DEFAULT (insert default values)
--*******************************

SELECT * FROM Book.Publisher

INSERT INTO Book.Publisher
DEFAULT VALUES
--default bir veri ekler. hiçbir þey girmediðimiz için NULL ekler

--UPDATE
--*********************************
--Update iþleminde koþul tanýma dikkat ediniz. Eðer herhangi bir koþul tanýmlamazsanýz sütundaki tüm deðerlere deðiþiklik uygulanacaktýr.

SELECT * FROM person_person_2

UPDATE person_person_2
SET Person_FirstName = 'adsum'
--tabloda ki bütün isimleri adsum yaptý.

UPDATE person_person_2
SET Person_FirstName = 'Emel'
WHERE SSN=44556677889
 
--update içinde join, subquery, built-in functions kullanabilirsiniz:

--update with functions
UPDATE person_person_2 SET Person_FirstName = b.Person_FirstName
FROM person_person_2 a INNER JOIN Person.Person b ON a.SSN = b.SSN

--update with functions

UPDATE person_person_2
SET SSN = LEFT(SSN, 5)

--DELETE
--************************************

--IDENTITY constraint

SELECT * FROM Book.Publisher

INSERT Book.Publisher VALUES ('X yayincilik'), ('Y yayincilik')

DELETE FROM Book.Publisher
--delete format atmaz. O yuzden yeni bir veri girisi oldugunda kaldigi sira numarasindan devam edecektir.
--truncate ile yapsaydik 1'den baþlayacaktýr.

INSERT Book.Publisher VALUES ('Z yayincilik');

-------
DELETE FROM Person.Person
WHERE Person_LastName IS NULL;
--where ile filtreleyerek lastname'yi NULL olanlari sildirmis olduk.


--FOREIGN KEY-REFERENCE CONSTRAINT

DELETE FROM Person.Person
WHERE SSN = 12233344445;
--Silmez ERROR verir çünkü sen bunu diðer tabloda da (Person.Mail) kullandýn diye hata verir.

-- DROP
--*********************************

DROP TABLE [dbo].[Names]

DROP TABLE [dbo].[person_person_2]

--foreign key constraint

DROP TABLE [Person].[Person]
--ERROR: Silmez çünkü bu tablo baþka bir tabloda FK olarak kullanýlan sütunlar var. 

-- TRUNCATE
--*******************************

SELECT * FROM Book.Publisher;

TRUNCATE TABLE Book.Publisher;
--Tabloya format atmýþ oldu. Bundan sonra buna bir þey eklenirse DELETE'in aksine 1'den baþlayacak.

SELECT * FROM Person.Mail;

TRUNCATE TABLE Person.Mail;

-- ALTER
--***********************************

--ADD KEY CONSTRAINTS
--- Bazý FK olmasý gerek sütunlarý yapmamýþtýk baþta þimdi onlarý yapacaðýz

--1--
ALTER TABLE Book.Book 
ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)  --ERROR
-- Çünkü bir sütunun FK olabilmesi için refere edildiði tabloda ya UNIQUE olacak ya da PK olmak zorunda.

--2--
ALTER TABLE Book.Author 
ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)  --ERROR
-- default olarak Author_ID oluþturulurken, NULL alabildiði için PK'ya atamamýza izin vermedi. 

--3--
ALTER TABLE Book.Author 
ALTER COLUMN Author_ID INT NOT NULL

--4--
ALTER TABLE Book.Author 
ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)

--5--
ALTER TABLE Book.Book 
ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)

-------

ALTER TABLE Book.Book 
ADD CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID) REFERENCES Book.Publisher (Publisher_ID)
--Book.Book tablosunda ki Publisher_ID'yi FK yapýyoruz. 

ALTER TABLE Person.Loan 
ADD CONSTRAINT FK_PERSON FOREIGN KEY (SSN) REFERENCES Person.Person (SSN);

ALTER TABLE Person.Loan 
ADD CONSTRAINT FK_book FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID);
--ON DELETE CASCADE / SET NULL / SET DEFAULT / NO ACTION --default
--ON UPDATE CASCADE / SET NULL / SET DEFAULT / NO ACTION --default

--ADD CHECK CONSTRAINTS
-- (Sütunlara contraint kýsýtlama/sýnýrlama getirmek için.)

SELECT * FROM Person.Phone;

ALTER TABLE Person.Phone 
ADD CONSTRAINT FK_Phone_check CHECK (Phone_Number BETWEEN 700000000 AND 9999999999);

-- DROP Constraints
-- (Sütunlardan contraint kýsýtlama/sýnýrlama kaldýrmak için.)

ALTER TABLE Person.Phone
DROP CONSTRAINT FK_Phone_check;