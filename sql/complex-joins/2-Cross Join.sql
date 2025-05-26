-- Create a new database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Create a table for products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Insert sample data into products table
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 1000.00),
(2, 'Smartphone', 600.00),
(3, 'Tablet', 300.00);

-- Create a table for promotions
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY,
    promotion_description VARCHAR(100),
    discount_percentage DECIMAL(5, 2)
);

-- Insert sample data into promotions table
INSERT INTO promotions (promotion_id, promotion_description, discount_percentage) VALUES
(1, 'Back to School', 10.00),
(2, 'Holiday Sale', 20.00),
(3, 'Clearance', 50.00);

-- Generate all product-promotion combinations using CROSS JOIN
SELECT p.product_name AS 'Product', p.price AS 'Price',
       pr.promotion_description AS 'Promotion', 
       pr.discount_percentage AS 'Discount (%)'
FROM products p
CROSS JOIN promotions pr;

-- Generate all product-promotion combinations and calculate final price after discount
SELECT p.product_name AS 'Product', p.price AS 'Original Price',
       pr.promotion_description AS 'Promotion', pr.discount_percentage AS 'Discount (%)',
       (p.price - (p.price * pr.discount_percentage / 100)) AS 'Discounted Price'
FROM products p
CROSS JOIN promotions pr;

-- Clean up: Drop the products and promotions tables
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS promotions;

-- Drop the database
DROP DATABASE IF EXISTS ecommerce_db;





























