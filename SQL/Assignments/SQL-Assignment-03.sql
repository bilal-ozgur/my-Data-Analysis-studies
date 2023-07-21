--Discount Effects

--Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.
--(In this assignment, you are expected to generate a solution using SQL with a logical approach. )


SELECT *
FROM product.product AS a, sale.order_item AS B
WHERE a.product_id = b.product_id
ORDER BY 1


SELECT a.product_id, order_id, quantity, discount
FROM product.product AS a, sale.order_item AS B
WHERE a.product_id = b.product_id
ORDER BY product_id, discount, order_id

SELECT discount, COUNT(order_id) AS cnt_of_orders, SUM(quantity) AS sum_of_qty
FROM product.product AS a, sale.order_item AS b
WHERE a.product_id = b.product_id
GROUP BY discount