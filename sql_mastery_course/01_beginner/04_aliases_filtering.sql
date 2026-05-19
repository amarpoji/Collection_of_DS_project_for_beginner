-- ============================================================
-- Lesson 04: Aliases & Advanced Filtering
-- Column/table aliases and complex filter conditions
-- ============================================================

-- -----------------------------------------------------------
-- Column Aliases
-- -----------------------------------------------------------

-- Rename salary in output
SELECT first_name, last_name, salary AS annual_salary
FROM employees;

-- Concatenated full name with alias
SELECT first_name || ' ' || last_name AS full_name, salary
FROM employees
LIMIT 5;
-- Expected: John Smith (75000), Jane Doe (95000), Bob Johnson (110000),
--           Alice Williams (105000), Charlie Brown (65000)

-- Alias for aggregate results
SELECT COUNT(*) AS total_employees,
       ROUND(AVG(salary), 2) AS average_salary
FROM employees;
-- Expected: total_employees=15, average_salary=93333.33

-- Alias with space (use double quotes)
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM employees
LIMIT 3;

-- AS is optional
SELECT salary * 1.1 salary_with_raise FROM employees LIMIT 3;

-- -----------------------------------------------------------
-- Table Aliases
-- -----------------------------------------------------------

-- Using table alias 'e'
SELECT e.first_name, e.salary
FROM employees AS e
LIMIT 5;

-- Without AS keyword
SELECT e.first_name, e.salary
FROM employees e
LIMIT 5;

-- -----------------------------------------------------------
-- Combining Filters with Parentheses
-- -----------------------------------------------------------

-- WITHOUT parentheses -- evaluates differently!
SELECT first_name, last_name, state, is_active
FROM customers
WHERE state = 'NY' OR state = 'CA' AND is_active = 1;
-- This means: state='NY' OR (state='CA' AND is_active=1)

-- WITH parentheses -- correct grouping
SELECT first_name, last_name, state, is_active
FROM customers
WHERE (state = 'NY' OR state = 'CA') AND is_active = 1;
-- Expected: Sarah (NY), Mike (CA), Olivia (CA), Charlotte (CA)

-- Employees in dept 1 or 2 with salary > 80000
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE (department_id = 1 OR department_id = 2) AND salary > 80000;
-- Expected: Jane (95000), Bob (110000), Edward (100000), Kevin (92000)

-- Movies that are Sci-Fi with high rating OR any movie after 2020
SELECT title, genre, rating, release_year
FROM movies
WHERE (genre = 'Sci-Fi' AND rating > 8.5) OR release_year > 2020;

-- -----------------------------------------------------------
-- IS NULL / IS NOT NULL
-- -----------------------------------------------------------

-- Find orders with NULL shipping_city (if any)
SELECT order_id, total_amount
FROM orders
WHERE shipping_city IS NULL;

-- Find employees WITH a manager (manager_id is not the text 'NULL')
SELECT first_name, last_name, manager_id
FROM employees
WHERE manager_id != 'NULL';
-- Note: In this database, 'NULL' is stored as text string, not actual NULL

-- -----------------------------------------------------------
-- Practical Filtering Patterns
-- -----------------------------------------------------------

-- Low stock products (< 50 units)
SELECT product_name, category, stock_quantity
FROM products
WHERE stock_quantity < 50;

-- High budget, high rating movies
SELECT title, budget_millions, rating
FROM movies
WHERE budget_millions > 100 AND rating > 8.0
ORDER BY rating DESC;
-- Expected: Inception (160, 8.8), Interstellar (165, 8.6),
--           The Dark Knight (185, 9.0), Gladiator (103, 8.5)

-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Full name, position, compensation (salary >= 80000)
SELECT first_name || ' ' || last_name AS full_name,
       job_title AS position,
       salary AS annual_compensation
FROM employees
WHERE salary >= 80000;

-- Exercise 2: Active customers from NY, CA, TX
SELECT first_name, last_name, state, is_active
FROM customers
WHERE (state = 'NY' OR state = 'CA' OR state = 'TX') AND is_active = 1;

-- Exercise 3: Accessories under $20
SELECT product_name, unit_price
FROM products
WHERE category = 'Accessories' AND unit_price < 20;
-- Expected: Coffee Mug (14.99), Water Bottle (19.99), Notebook Set (12.5),
--           Cable Organizer (9.99), Wrist Rest (15.99)

-- Exercise 4: Action or Sci-Fi movies with rating >= 8.0
SELECT title, genre, rating
FROM movies
WHERE (genre = 'Action' OR genre = 'Sci-Fi') AND rating >= 8.0
ORDER BY genre, rating DESC;

-- Exercise 5: Employees without a manager
SELECT first_name, last_name, job_title
FROM employees
WHERE manager_id = 'NULL';
-- Expected: John Smith (Data Analyst), George Harris (CTO),
--           Julia Roberts (HR Manager), Michael Jordan (Sales Manager)

-- 🔥 Mini Challenge Solutions

-- 1. Delivered orders over $200
SELECT order_id, customer_id, status, total_amount
FROM orders
WHERE status = 'Delivered' AND total_amount > 200;

-- 2. Salary between 70k-100k in dept 1 or 3
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary BETWEEN 70000 AND 100000
  AND (department_id = 1 OR department_id = 3);

-- 3. Airbnb entire homes with rating >= 4.8
SELECT property_name, room_type, rating
FROM airbnb_listings
WHERE room_type = 'Entire home/apt' AND rating >= 4.8;

-- 4. Profitable movies (revenue > budget) with rating > 8.0
SELECT title, budget_millions, revenue_millions, rating,
       (revenue_millions - budget_millions) AS profit_millions
FROM movies
WHERE revenue_millions > budget_millions AND rating > 8.0
ORDER BY profit_millions DESC;
