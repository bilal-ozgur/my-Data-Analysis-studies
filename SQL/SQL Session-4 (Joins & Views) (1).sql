
--SQL SESSION-4, 10.07.2023, (Joins & Views)

--////////////////////////////////////////////--
------ INNER JOIN ------

--Make a list of products showing the product ID, product name, category ID, and category name.
--(�r�nleri kategori isimleri ile birlikte listeleyin)
--(�r�n IDsi, �r�n ad�, kategori IDsi ve kategori adlar�n� se�in)

SELECT * FROM product.product
SELECT * FROM product.category

SELECT p.product_id, p.product_name, p.category_id, c.category_name
FROM product.product p
	INNER JOIN product.category c
	ON p.category_id=c.category_id; 

--------------------------

SELECT p.product_id, p.product_name, p.category_id, c.category_name
FROM product.product p, product.category c
WHERE p.category_id=c.category_id;


--List employees of stores with their store information.
--Select first name, last name, store name


SELECT * FROM sale.staff
SELECT * FROM sale.store

SELECT 
	a.first_name, a.last_name, b.store_name
FROM
	sale.staff a
	INNER JOIN
	sale.store b
	ON a.store_id=b.store_id


--How many employees are in each store?


SELECT 
	b.store_name, COUNT(a.staff_id) num_of_employees
FROM
	sale.staff a
	INNER JOIN
	sale.store b
	ON a.store_id=b.store_id
GROUP BY
	b.store_name;
	

--////////////////////////////////////////////--
------ LEFT JOIN ------

--Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Hi� sipari� verilmemi� �r�nleri listeleyin)

SELECT * FROM product.product
SELECT * FROM sale.order_item

SELECT COUNT(DISTINCT product_id) 
FROM sale.order_item;

SELECT p.product_id, p.product_name, o.order_id
FROM product.product p 
	 LEFT JOIN sale.order_item o
	 ON p.product_id=o.product_id
WHERE o.order_id IS NULL
ORDER BY 1;


--Report the total number of products sold by each employee

SELECT * FROM sale.order_item


SELECT a.staff_id, COALESCE(SUM(c.quantity), 0) num_of_product  --ISNULL(SUM(c.quantity), 0)
FROM sale.staff a
	LEFT JOIN sale.orders b ON a.staff_id=b.staff_id
	LEFT JOIN sale.order_item c ON b.order_id=c.order_id
GROUP BY a.staff_id
ORDER BY 1;

------------

SELECT a.staff_id, SUM(c.quantity) num_of_product
FROM sale.staff a
	INNER JOIN sale.orders b ON a.staff_id=b.staff_id
	INNER JOIN sale.order_item c ON b.order_id=c.order_id
GROUP BY a.staff_id
ORDER BY 1;


--////////////////////////////////////////////--
------ RIGHT JOIN ------

--Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Hi� sipari� verilmemi� �r�nleri listeleyin)

SELECT p.product_id, p.product_name, o.order_id
FROM sale.order_item o 
	 RIGHT JOIN product.product p
	 ON p.product_id=o.product_id
WHERE o.order_id IS NULL
ORDER BY 1;


--////////////////////////////////////////////--
------ FULL OUTER JOIN ------

--Report the stock quantities of all products
--(�r�nlerin stok miktar�n� raporlay�n)
--(Her �r�n�n stok ve sipari� bilgisi olmak zorunda de�il)

SELECT * FROM product.stock

SELECT p.product_id, SUM(s.quantity) total_quantity
FROM product.product AS p
	 FULL JOIN product.stock s
	 ON p.product_id=s.product_id
GROUP BY p.product_id
ORDER BY 1,2;


--////////////////////////////////////////////--
------ CROSS JOIN ------

/*The stock table does not have all the products in the product table, and you want to add these products to the stock table.
  You have to insert all these products for every three stores with �0 (zero)� quantity.
  Write a query to prepare this data.*/

--stock tablosunda olmay�p product tablosunda mevcut olan �r�nlerin stock tablosuna t�m store'lar i�in kay�t edilmesi gerekiyor. 
--sto�u olmad��� i�in quantity'leri 0 olmak zorunda
--Ve bir product_id t�m store'lar�n stock'una eklenmesi gerekti�i i�in cross join yapmam�z gerekiyor.


SELECT p.product_id, s.store_id, 0 AS quantity
FROM product.product p
	 CROSS JOIN sale.store s
WHERE p.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY 1,2;

SELECT product_id FROM product.stock


SELECT * FROM product.stock

SELECT a.product_id, b.store_id, COALESCE(c.quantity,0)	quantity
FROM product.product a
	CROSS JOIN sale.store b
	LEFT JOIN product.stock c 
	ON a.product_id=c.product_id
	AND b.store_id=c.store_id
ORDER BY 1,2;


--////////////////////////////////////////////--
------ SELF JOIN ------

--Write a query that returns the staff names with their manager names.
--Expected columns: staff first name, staff last name, manager name
--(Personelleri ve �eflerini listeleyin)
--(�al��an ad� ve y�netici ad� bilgilerini getirin)

SELECT * FROM sale.staff

SELECT a.first_name, a.last_name, b.first_name
FROM sale.staff a
	 LEFT JOIN sale.staff b ON a.manager_id=b.staff_id;

----------

SELECT a.first_name, a.last_name, b.first_name
FROM sale.staff a
	 INNER JOIN sale.staff b ON a.manager_id=b.staff_id;
GO

--Write a query that returns both the names of staff and the names of their 1st and 2nd managers
--(Bir �nceki sorgu sonucunda gelen �eflerin yan�na onlar�n da �eflerini getiriniz)
--(�al��an ad�, �ef ad�, �efin �efinin ad� bilgilerini getirin)








--////////////////////////////////////////////--
------ VIEWS ------

--create a view that shows the products customers ordered
--(m��terilerin sipari� etti�i �r�nleri g�steren bir view olu�turun)

CREATE VIEW vw_customers_sale 
AS
SELECT a.customer_id, a.first_name, a.last_name, b.order_id, c.product_id, d.product_name
FROM sale.customer a 
	 LEFT JOIN sale.orders b ON a.customer_id=b.customer_id
	 LEFT JOIN sale.order_item c ON b.order_id=c.order_id
	 LEFT JOIN product.product d ON c.product_id=d.product_id;
GO

SELECT * FROM [dbo].[vw_customers_sale]
GO

EXEC sp_helptext [vw_customers_sale]
GO

ALTER VIEW vw_customers_sale   
AS 
SELECT a.customer_id, a.first_name, a.last_name, c.product_id, d.product_name  
FROM sale.customer a   
  LEFT JOIN sale.orders b ON a.customer_id=b.customer_id  
  LEFT JOIN sale.order_item c ON b.order_id=c.order_id  
  LEFT JOIN product.product d ON c.product_id=d.product_id;
GO

SELECT * FROM [dbo].[vw_customers_sale]

DROP VIEW [vw_customers_sale]

SELECT * FROM [vw_customer_sales]

DROP VIEW [vw_customer_sales]


-------------------------
