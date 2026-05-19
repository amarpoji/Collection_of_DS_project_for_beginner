-- ============================================================
-- Lesson 02: SELECT & WHERE
-- Querying data with filters
-- ============================================================

-- -----------------------------------------------------------
-- Basic SELECT
-- -----------------------------------------------------------

-- Select specific columns
SELECT first_name, last_name, salary
FROM employees;
-- Expected: 15 rows showing employee names and salaries

-- Select all columns (use carefully!)
SELECT * FROM employees;
-- Expected: 15 rows with all employee columns

-- -----------------------------------------------------------
-- WHERE with comparison operators
-- -----------------------------------------------------------

-- Employees earning more than $90,000
SELECT first_name, last_name, job_title, salary
FROM employees
WHERE salary > 90000;
-- Expected:
-- Jane     Doe      Software Engineer    95000
-- Bob      Johnson  Data Scientist      110000
-- Alice    Williams Product Manager     105000
-- Edward   Norton   Data Engineer       100000
-- George   Harris   CTO                 200000
-- Kevin    Bacon    DevOps Engineer      92000
-- Michael  Jordan   Sales Manager       130000

-- Exact match on text
SELECT employee_id, first_name, last_name, job_title
FROM employees
WHERE first_name = 'Alice';
-- Expected: 4  Alice  Williams  Product Manager

-- Employees in department_id = 1 (Data & Analytics)
SELECT first_name, last_name, job_title
FROM employees
WHERE department_id = 1;

-- -----------------------------------------------------------
-- WHERE with AND, OR, NOT
-- -----------------------------------------------------------

-- AND: Female customers from New York
SELECT first_name, last_name, city, state
FROM customers
WHERE gender = 'Female' AND state = 'NY';
-- Expected: Sarah  Johnson  New York  NY

-- OR: Customers from California OR Texas
SELECT first_name, last_name, city, state
FROM customers
WHERE state = 'CA' OR state = 'TX';

-- NOT: Inactive customers
SELECT first_name, last_name, email, is_active
FROM customers
WHERE NOT is_active = 1;
-- Expected: Sophia Brown, Noah Wilson, Lucas White

-- -----------------------------------------------------------
-- WHERE with IN
-- -----------------------------------------------------------

-- Movies in specific genres
SELECT title, genre, release_year, rating
FROM movies
WHERE genre IN ('Action', 'Sci-Fi', 'Thriller')
ORDER BY rating DESC;

-- -----------------------------------------------------------
-- WHERE with BETWEEN
-- -----------------------------------------------------------

-- Movies released between 2010 and 2020
SELECT title, release_year, rating
FROM movies
WHERE release_year BETWEEN 2010 AND 2020;

-- Products priced between $50 and $150
SELECT product_name, category, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 150;

-- -----------------------------------------------------------
-- WHERE with LIKE (pattern matching)
-- -----------------------------------------------------------

-- Last name starts with 'M'
SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE 'M%';
-- Expected: Olivia  Martinez  olivia.m@email.com

-- Email domain is 'email.com'
SELECT first_name, last_name, email
FROM customers
WHERE email LIKE '%@email.com';

-- Job title contains 'Data'
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title LIKE '%Data%';
-- Expected: John Smith (Data Analyst), Bob Johnson (Data Scientist),
--           Edward Norton (Data Engineer), Ian Clark (Jr Data Analyst)

-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Customers in Chicago
SELECT first_name, last_name, city
FROM customers
WHERE city = 'Chicago';
-- Expected: Emma  Davis  Chicago

-- Exercise 2: Employees with salary >= 100000
SELECT first_name, last_name, job_title, salary
FROM employees
WHERE salary >= 100000;
-- Expected: Bob (110000), Alice (105000), Edward (100000),
--           George (200000), Michael (130000)

-- Exercise 3: Movies with rating >= 8.5 after 2000
SELECT title, rating, release_year
FROM movies
WHERE rating >= 8.5 AND release_year > 2000;

-- Exercise 4: Customers between 25 and 35
SELECT first_name, last_name, age, city
FROM customers
WHERE age BETWEEN 25 AND 35;

-- Exercise 5: Job titles ending with 'Engineer'
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title LIKE '%Engineer';
-- Expected: Jane (Software Engineer), Kevin (DevOps Engineer)

-- 🔥 Mini Challenge Solutions

-- 1. Sci-Fi movies with rating above 8.5
SELECT title, genre, rating
FROM movies
WHERE genre = 'Sci-Fi' AND rating > 8.5;
-- Expected: The Matrix (8.7), Inception (8.8)

-- 2. Orders that are Pending or Shipped
SELECT order_id, customer_id, status, total_amount
FROM orders
WHERE status IN ('Pending', 'Shipped');

-- 3. Employees hired 2018-2020 with salary < 100000
SELECT first_name, last_name, hire_date, salary
FROM employees
WHERE hire_date BETWEEN '2018-01-01' AND '2020-12-31'
  AND salary < 100000;

-- 4. Email ending @email.com, NOT from California
SELECT first_name, last_name, email, state
FROM customers
WHERE email LIKE '%@email.com' AND state != 'CA';
