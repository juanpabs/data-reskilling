-- Create the Database and Table
-- This creates a new database 'sales_demo' and a table 'sales' to store region-wise sales data for various salespeople.
CREATE DATABASE IF NOT EXISTS sales_demo;
USE sales_demo;

CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    region VARCHAR(50),
    salesperson VARCHAR(100),
    product_category VARCHAR(50),
    sales_amount DECIMAL(10, 2),
    sales_date DATE
);

-- Insert sample data
-- Populates the 'sales' table with some example sales records.
INSERT INTO sales (region, salesperson, product_category, sales_amount, sales_date) VALUES
('North', 'Alice', 'Electronics', 5000, '2024-01-10'),
('North', 'Bob', 'Furniture', 3000, '2024-01-12'),
('South', 'Charlie', 'Electronics', 7000, '2024-01-15'),
('South', 'David', 'Furniture', 2000, '2024-01-20'),
('West', 'Eve', 'Electronics', 4500, '2024-02-01'),
('West', 'Frank', 'Furniture', 3500, '2024-02-03');

-- Subquery in SELECT (Before Refactoring)
-- Calculates the total sales for each salesperson for the 'Electronics' category using a subquery in the SELECT clause.
SELECT 
    salesperson,
    (SELECT SUM(sales_amount) 
     FROM sales s2 
     WHERE s2.salesperson = s1.salesperson 
     AND s2.product_category = 'Electronics') AS electronics_sales
FROM sales s1
GROUP BY salesperson;

-- Refactoring Subquery in SELECT to a CTE
-- Refactors the previous query to use a CTE for 'electronics_sales' and joins it in the main query for clarity.
WITH ElectronicsSales AS (
    SELECT 
        salesperson, 
        SUM(sales_amount) AS electronics_sales
    FROM sales
    WHERE product_category = 'Electronics'
    GROUP BY salesperson
)
SELECT 
    s.salesperson,
    es.electronics_sales
FROM sales s
LEFT JOIN ElectronicsSales es
ON s.salesperson = es.salesperson;

-- Subquery in FROM (Before Refactoring)
-- Calculates the total sales for each salesperson per region using a subquery in the FROM clause, then orders by total sales to get the top salesperson.
SELECT 
    region, 
    salesperson AS top_salesperson
FROM (
    SELECT 
        region, 
        salesperson, 
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY region, salesperson
) AS regional_sales
ORDER BY total_sales DESC;

-- Refactoring Subquery in FROM to a CTE
-- Refactors the previous query to use a CTE to calculate regional sales totals, improving readability.
WITH RegionalSales AS (
    SELECT 
        region, 
        salesperson, 
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY region, salesperson
)
SELECT 
    region, 
    salesperson AS top_salesperson
FROM RegionalSales
ORDER BY total_sales DESC;

-- Subquery in WHERE (Before Refactoring)
-- Calculates the total sales per salesperson and filters those whose total sales are above the average sales using a subquery in the HAVING clause.
SELECT 
    salesperson, 
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY salesperson
HAVING SUM(sales_amount) > (
    SELECT AVG(sales_amount) FROM sales
);

-- Refactoring Subquery in WHERE to a CTE
-- Refactors the previous query by using a CTE to calculate the average sales and references it in the HAVING clause.
WITH AvgSales AS (
    SELECT AVG(sales_amount) AS avg_sales FROM sales
)
SELECT 
    s.salesperson, 
    SUM(s.sales_amount) AS total_sales
FROM sales s
GROUP BY s.salesperson
HAVING total_sales > (SELECT avg_sales FROM AvgSales);

-- Original query with subquery used twice
-- Calculates total sales per salesperson and also calculates the average of those totals, using the same subquery twice, once in SELECT and once in WHERE.
SELECT 
    s.salesperson,
    s.total_sales,
    (SELECT AVG(total_sales) 
     FROM (SELECT salesperson, SUM(sales_amount) AS total_sales FROM sales GROUP BY salesperson) AS avg_sales_subquery) AS avg_sales
FROM 
    (SELECT salesperson, SUM(sales_amount) AS total_sales FROM sales GROUP BY salesperson) AS s
WHERE 
    s.total_sales > (SELECT AVG(total_sales) 
                     FROM (SELECT salesperson, SUM(sales_amount) AS total_sales FROM sales GROUP BY salesperson) AS avg_sales_subquery);

-- Refactored query using a CTE to reuse the subquery
-- Refactors the previous query by using a CTE to calculate 'SalesTotals' and then calculates the average sales, allowing the subquery to be reused instead of repeating it.
WITH SalesTotals AS (
    SELECT 
        salesperson, 
        SUM(sales_amount) AS total_sales
    FROM sales
    GROUP BY salesperson
),
AvgSales AS (
    SELECT AVG(total_sales) AS avg_sales FROM SalesTotals
)
SELECT 
    s.salesperson,
    s.total_sales,
    a.avg_sales
FROM SalesTotals s, AvgSales a
WHERE 
    s.total_sales > a.avg_sales;

-- Clean Up
-- Drops the 'sales_demo' database to clean up the environment after the demo is complete.
DROP DATABASE sales_demo;
