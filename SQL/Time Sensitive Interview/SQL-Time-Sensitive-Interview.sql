--You should report count of orders, Website sales rate, Inbound call sales rate, outbound call sales rate and number of different agents for each hour.

--There are three type of orders. One order is may be online, outbound or inbound. 
--For outbound call there must be an agent. For inbound call there mustn't be an agent.


/*
hour	product_code	transaction_type	sales_agent
8:00	ABC123				Online				NULL
8:00	ABC123				Online				NULL
8:00	XYZ789				Online				NULL
8:00	XYZ789				Phone				NULL
9:30	DEF456				Phone				John
9:30	GHI789				Online				John
10:15	XYZ789				Phone				John
10:15	GHI789				Online				NULL
10:15	GHI789				Phone				NULL
10:15	DEF456				Phone				Jane
10:15	GHI789				Phone				NULL
*/

CREATE TABLE sales_table (
	[hour] time(0),
	product_code varchar(6),
	transaction_type varchar(10),
	sales_agent varchar(6)
	)

INSERT INTO sales_table ([hour], product_code, transaction_type, sales_agent)
VALUES 
('8:00','ABC123','Online',NULL),
('8:00','ABC123','Online',NULL),
('8:00','XYZ789','Online',NULL),
('8:00','XYZ789','Phone',NULL),
('9:30','DEF456','Phone','John'),
('9:30','GHI789','Online','John'),
('10:15','XYZ789','Phone','John'),
('10:15','GHI789','Online',NULL),
('10:15','GHI789','Phone', NULL),
('10:15','DEF456','Phone','Jane'),
('10:15','GHI789','Phone',NULL)


--count of orders
SELECT [hour], COUNT(*) AS cnt_of_orders
FROM sales_table
GROUP BY [hour];


--website sales rate
SELECT 
	SUM(CASE WHEN  transaction_type = 'Online' THEN 1 ELSE 0 END) /  COUNT(*)
FROM sales_table


--inbound call sales rate
SELECT *, ISNULL(NULLIF(ISNULL(sales_agent, 'inbound') ,sales_agent), 'outbound') AS call_type
FROM sales_table

WITH t1 AS
(
	SELECT *, ISNULL(NULLIF(ISNULL(sales_agent, 'inbound') ,sales_agent), 'outbound') AS call_type
	FROM sales_table
)
SELECT 
	1*SUM(CASE WHEN  call_type = 'inbo' THEN 1 ELSE 0 END) / 1*COUNT(call_type)
FROM t1







--------------//////////////////////////
---------------////////////////////////





-------Write a query that returns the source of users. Users must have only one client. 
--For multiple sources, print ‘multiple’.


/*
user_id	client_id	source
A23bc	101			API
A23bc	101			API
A23bc	101			API
X9PqW	202			Mobile App
X9PqW	202			Website
X9PqW	202			Social Media
G7RtZ	808			Mobile App
G7RtZ	303			Mobile App
G7RtZ	303			Mobile App
T5Yhn	404			Website
T5Yhn	405			Social Media
T5Yhn	406			Social Media
K8Mju	505			Website
K8Mju	505			Website
K8Mju	505			Website
E4Sdf	606			Mobile App
E4Sdf	606			API
E4Sdf	606			API
*/











