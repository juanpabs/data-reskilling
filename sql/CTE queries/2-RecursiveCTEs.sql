-- Create the Database
CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- Create a table to store employee-manager relationships
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INT
);

-- Insert sample data for employees and managers
INSERT INTO employees (employee_id, employee_name, manager_id) VALUES
(1, 'CEO', NULL),
(2, 'CFO', 1),
(3, 'CTO', 1),
(4, 'VP of Finance', 2),
(5, 'VP of Engineering', 3),
(6, 'Finance Manager', 4),
(7, 'Engineering Manager', 5),
(8, 'Software Engineer', 7),
(9, 'Data Scientist', 7);

-- Recursive CTE to retrieve the employee hierarchy
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Start with the CEO (or top of the hierarchy)
    SELECT 
        employee_id, 
        employee_name, 
        manager_id, 
        1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: Find employees who report to the current level of employees
    SELECT 
        e.employee_id, 
        e.employee_name, 
        e.manager_id, 
        eh.level + 1 AS level
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
-- Query the hierarchy, ordered by level
SELECT * 
FROM EmployeeHierarchy
ORDER BY level;

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT 
        employee_id, 
        employee_name, 
        manager_id, 
        1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT 
        e.employee_id, 
        e.employee_name, 
        e.manager_id, 
        eh.level + 1 AS level
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
    WHERE eh.level < 3 -- Limit recursion to 3 levels
)
SELECT * 
FROM EmployeeHierarchy
ORDER BY level;

-- Clean Up
-- Drop the employees table after the demo
DROP TABLE employees;
DROP DATABASE CompanyDB;