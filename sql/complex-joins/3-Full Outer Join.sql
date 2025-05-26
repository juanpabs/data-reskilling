-- Create a new database
CREATE DATABASE customer_order_db;
USE customer_order_db;

-- Create a table for customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY, customer_name VARCHAR(100)
);

-- Insert sample data into customers table
INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Michael Brown'), -- Michael hasn't placed an order yet
(4, 'Sarah Johnson'); -- Sarah hasn't placed an order yet

-- Create a table for orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT, -- Foreign key to reference customers
    order_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert sample data into orders table
INSERT INTO orders (order_id, customer_id, order_amount) VALUES
(1, 1, 150.00),      -- John has made an order
(2, 1, 200.00),      -- Another order by John
(3, 2, 350.00),      -- Jane's order
(4, NULL, 500.00);   -- An order with no customer (possibly due to incomplete data)

-- Simulate FULL OUTER JOIN using UNION of LEFT JOIN and RIGHT JOIN
SELECT c.customer_name AS 'Customer', o.order_id AS 'Order ID', o.order_amount AS 'Order Amount'
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT c.customer_name AS 'Customer', o.order_id AS 'Order ID', o.order_amount AS 'Order Amount'
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

/*
-- SQL Server and PostgreSQL - Use FULL OUTER JOIN to merge customers and orders 
SELECT c.customer_name AS 'Customer', o.order_id AS 'Order ID', o.order_amount AS 'Order Amount'
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
*/

-- Clean up: Drop the customers and orders tables
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- Drop the database
DROP DATABASE IF EXISTS customer_order_db;























