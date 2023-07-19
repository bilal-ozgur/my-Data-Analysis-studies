--SET OPERATORS
--UNION, INTERSECT,EXCEPT


-- 1- List in ascending order the stores where both "Samsung Galaxy Tab S3 Keyboard Cover" and "Apple - Pre-Owned iPad 3 - 64GB - Black" are stocked.(Using by set operators)

SELECT store_name
FROM
	sale.store AS a,
	product.stock AS b,
	product.product AS c
WHERE 
	a.store_id = b.store_id AND
	b.product_id = c.product_id AND
	product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
INTERSECT
SELECT store_name
FROM
	sale.store AS a,
	product.stock AS b,
	product.product AS c
WHERE 
	a.store_id = b.store_id AND
	b.product_id = c.product_id AND
	product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black'


-- 2- Detect the store that does not have a product named "Samsung Galaxy Tab S3 Keyboard Cover" in its stock. (Paste the store name in the box below.) (Using by set operators)

SELECT store_name
FROM
	sale.store AS a,
	product.stock AS b,
	product.product AS c
WHERE 
	a.store_id = b.store_id AND
	b.product_id = c.product_id  
EXCEPT 
SELECT store_name
FROM
	sale.store AS a,
	product.stock AS b,
	product.product AS c
WHERE 
	a.store_id = b.store_id AND
	b.product_id = c.product_id AND
	product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
