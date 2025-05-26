-- Create a new database
CREATE DATABASE using_clause_demo_db;
USE using_clause_demo_db;

-- Create a table for customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- Insert sample data into customers table
INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Michael Brown');

-- Create a table for orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT, -- Common column
    order_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert sample data into orders table
INSERT INTO orders (order_id, customer_id, order_amount) VALUES
(1, 1, 150.00),
(2, 1, 200.00),
(3, 2, 350.00);

-- Join customers and orders using the ON condition
SELECT customers.customer_name, orders.order_id, orders.order_amount
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id;

-- Join customers and orders using the USING clause
SELECT customer_name, order_id, order_amount
FROM customers
JOIN orders USING (customer_id);

-- Create a table for products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    order_id INT, -- Common column with the orders table
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert sample data into products table
INSERT INTO products (product_id, product_name, order_id) VALUES
(1, 'Laptop', 1),
(2, 'Smartphone', 2),
(3, 'Tablet', 3);

-- Join customers, orders, and products using the USING clause
SELECT customer_name, order_id, product_name, order_amount
FROM customers
JOIN orders USING (customer_id)
JOIN products USING (order_id);

-- Clean up: Drop the customers, orders, and products tables
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- Drop the database
DROP DATABASE IF EXISTS using_clause_demo_db;

























