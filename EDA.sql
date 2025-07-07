-- Exploring all the objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Exploring all columns
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'


/*
Dimensions Exploration --> Identifying the unique values in each dimension.
Recognizing how data might be grouped or segmented for analysis
*/

--Exploring all countries where our customers come from
SELECT DISTINCT country FROM [gold.dim_customers]

-- Exploring all the important categories
SELECT DISTINCT category,subcategory,product_name FROM [gold.dim_products]
ORDER BY 1,2,3


/*
Date Exploration --> Identify the earliest and latest dates, understand the scope of the data aand the timespan
*/

-- First and Last order
SELECT 
MIN (order_date) AS first_order_date ,
MAX(order_date) AS last_order_date,
DATEDIFF(year,MIN (order_date),MAX(order_date)) AS order_years_range
from [gold.fact_sales]

--Youngest and oldest customers

SELECT
DATEDIFF(year,MIN(birthdate),GETDATE()) AS oldest_age,
DATEDIFF(year,MAX(birthdate),GETDATE()) AS youngest_age
FROM [gold.dim_customers]


/*
Measures Exploration --> Calculating the key metric of the business "Highest level of aggregation | lowest level of details"

*/
--Find the Total Sales
SELECT SUM(sales_amount) AS total_Sales from [gold.fact_sales]

-- Find the average selling price
SELECT AVG(price) AS average_selling_price FROM [gold.fact_sales]

-- Find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM [gold.fact_sales]
SELECT COUNT(Distinct order_number) AS total_orders FROM [gold.fact_sales]

-- Find the total number of orders
SELECT COUNT(product_name) AS total_products FROM [gold.dim_products]
SELECT COUNT(DISTINCT product_name) AS total_products FROM [gold.dim_products]

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM [gold.dim_customers]

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM [gold.fact_sales] 


--Generating a report the shows all the metrics
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value from [gold.fact_sales]
UNION ALL
SELECT 'Total Quantity',SUM(quantity) from [gold.fact_sales]
UNION ALL
SELECT 'Average Price', AVG(price)  FROM [gold.fact_sales]
UNION ALL
SELECT 'Total number of orders',COUNT(Distinct order_number) FROM [gold.fact_sales]
UNION ALL
SELECT 'Total number of products',COUNT(DISTINCT product_name) FROM [gold.dim_products]
UNION ALL
SELECT'Total number of customers', COUNT(DISTINCT customer_key) FROM [gold.fact_sales] 


/*
Magnitude Analysis --> Compare Measure values by categories
*/
--Find total customers by countries
SELECT
country,COUNT(customer_key) AS total_customers
From [gold.dim_customers]
group by country
order by total_customers DESC

-- Find total customers by gender
SELECT
gender,
COUNT(customer_key) AS total_customers
From [gold.dim_customers]
group by gender
order by total_customers DESC

-- Find total products by category
SELECT
category,
COUNT(product_key) AS total_products
From [gold.dim_products]
group by category
order by total_products DESC

--What is the total revenue generated for each category?
SELECT category,
SUM(s.sales_amount) AS total_revenue
FROM [gold.fact_sales] s 
LEFT JOIN [gold.dim_products] p
on p.product_key = s.product_key
GROUP BY category
ORDER BY total_revenue DESC

--What is the average costs in each category?
SELECT category,
AVG(cost) AS avg_cost
FROM [gold.dim_products]
GROUP BY category
ORDER BY avg_cost DESC

--Find total revenue generatedd by each customer
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount) AS total_revenue
FROM [gold.fact_sales] s 
LEFT JOIN [gold.dim_customers] c
on c.customer_key = s.customer_key
GROUP BY
c.customer_key,
c.first_name,
c.last_name

ORDER BY total_revenue DESC

-- Whatt is the distribution of sold items across countries?
SELECT
c.country,

SUM(s.quantity) AS total_sold_items
FROM [gold.fact_sales] s 
LEFT JOIN [gold.dim_customers] c
on c.customer_key = s.customer_key
GROUP BY
c.country
ORDER BY total_sold_items DESC

/*
Ranking Analysis -->Order the values of dimensions by a measure
*/
--Which 5 Products generate the highest revenue
SELECT * FROM
	(SELECT 
	p.product_name,
	SUM(s.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM [gold.fact_sales] s
	LEFT JOIN [gold.dim_products] p
	ON p.product_key = s.product_key
	GROUP BY p.product_name)t
WHERE rank_products <= 5

--Which 5 Products generate the lowest revenue
SELECT * FROM
	(SELECT 
	p.product_name,
	SUM(s.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount)) AS rank_products
	FROM [gold.fact_sales] s
	LEFT JOIN [gold.dim_products] p
	ON p.product_key = s.product_key
	GROUP BY p.product_name)t
WHERE rank_products <= 5
