-- Create a new database
CREATE DATABASE company_db;
USE company_db;

-- Create a table for employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    position VARCHAR(50),
    manager_id INT, -- References the employee_id of the manager
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Insert sample data representing an organization
INSERT INTO employees (employee_id, employee_name, position, manager_id) VALUES
(1, 'Alice', 'CEO', NULL),        -- Alice is the CEO (No manager)
(2, 'Bob', 'Manager', 1),         -- Bob reports to Alice
(3, 'Charlie', 'Manager', 1),     -- Charlie reports to Alice
(4, 'David', 'Team Lead', 2),     -- David reports to Bob
(5, 'Eva', 'Team Lead', 2),       -- Eva reports to Bob
(6, 'Frank', 'Team Lead', 3),     -- Frank reports to Charlie
(7, 'Grace', 'Team Lead', 3);     -- Grace reports to Charlie

-- 1. Show only employees who have a manager (excludes employees without a manager)
SELECT e1.employee_name AS 'Employee', e1.position AS 'Employee Position',
       m.employee_name AS 'Manager', 
       m.position AS 'Manager Position'
FROM employees e1
JOIN employees m ON e1.manager_id = m.employee_id;

-- 2. Show employees, their positions, and their managers 
SELECT e1.employee_name AS 'Employee', e1.position AS 'Employee Position',
       COALESCE(m.employee_name, 'No Manager') AS 'Manager', 
       COALESCE(m.position, 'N/A') AS 'Manager Position'
FROM employees e1
LEFT JOIN employees m ON e1.manager_id = m.employee_id;

-- 3. Group employees by their manager and display employees as a comma-separated list
SELECT m.employee_name AS 'Manager', GROUP_CONCAT(e1.employee_name SEPARATOR ', ') AS 'Employees'
FROM employees e1
JOIN employees m ON e1.manager_id = m.employee_id
GROUP BY m.employee_name;

-- Clean up: Drop the employees table
DROP TABLE IF EXISTS employees;

-- Drop the database
DROP DATABASE IF EXISTS company_db;






























