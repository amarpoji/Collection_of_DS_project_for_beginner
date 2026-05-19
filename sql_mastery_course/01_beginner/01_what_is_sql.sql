-- ============================================================
-- Lesson 01: What is SQL, Databases & Tables
-- Exploring the sql_mastery.db database
-- ============================================================
-- ============================================================
-- NOTE: The commands below that start with '.' are sqlite3
-- dot commands. They are NOT standard SQL. Run them in the
-- sqlite3 CLI, NOT inside a SQL script.
-- ============================================================
-- -----------------------------------------------------------
-- 1. List all tables in the database
-- -----------------------------------------------------------
-- Run this in the sqlite3 CLI: .tables
-- Expected output:
-- airbnb_listings  customers        departments      employees
-- movies           order_items      orders           products
-- -----------------------------------------------------------
-- 2. View table schema (structure)
-- -----------------------------------------------------------
-- Run this in the sqlite3 CLI: .schema employees
-- Expected output:
-- CREATE TABLE employees (
--     employee_id INTEGER,
--     first_name TEXT,
--     last_name TEXT,
--     email TEXT,
--     phone TEXT,
--     hire_date TEXT,
--     job_title TEXT,
--     salary REAL,
--     department_id INTEGER,
--     manager_id TEXT
-- );
-- -----------------------------------------------------------
-- 3. View column details with PRAGMA
-- -----------------------------------------------------------
-- Run this in the sqlite3 CLI: PRAGMA table_info(customers);
-- Expected output:
-- cid  name               type     notnull  dflt_value  pk
-- ---  -----------------  -------  -------  ----------  --
-- 0    customer_id        INTEGER  0                    0
-- 1    first_name         TEXT     0                    0
-- 2    last_name          TEXT     0                    0
-- 3    email              TEXT     0                    0
-- 4    gender             TEXT     0                    0
-- 5    age                INTEGER  0                    0
-- 6    city               TEXT     0                    0
-- 7    state              TEXT     0                    0
-- 8    registration_date  TEXT     0                    0
-- 9    is_active          INTEGER  0                    0
-- -----------------------------------------------------------
-- 4. Count rows in each table
-- -----------------------------------------------------------
-- Count employees
SELECT 'employees:' AS table_name,
    COUNT(*) AS row_count
FROM employees;
-- Expected: employees: 15
-- Count customers
SELECT 'customers:' AS table_name,
    COUNT(*) AS row_count
FROM customers;
-- Expected: customers: 20
-- Count orders
SELECT 'orders:' AS table_name,
    COUNT(*) AS row_count
FROM orders;
-- Expected: orders: 50
-- Count movies
SELECT 'movies:' AS table_name,
    COUNT(*) AS row_count
FROM movies;
-- Expected: movies: 40
-- Count all in one query
SELECT 'employees' AS table_name,
    COUNT(*) AS row_count
FROM employees
UNION ALL
SELECT 'customers',
    COUNT(*)
FROM customers
UNION ALL
SELECT 'orders',
    COUNT(*)
FROM orders
UNION ALL
SELECT 'products',
    COUNT(*)
FROM products
UNION ALL
SELECT 'order_items',
    COUNT(*)
FROM order_items
UNION ALL
SELECT 'movies',
    COUNT(*)
FROM movies
UNION ALL
SELECT 'airbnb_listings',
    COUNT(*)
FROM airbnb_listings
UNION ALL
SELECT 'departments',
    COUNT(*)
FROM departments;
-- -----------------------------------------------------------
-- 5. Select a few rows to see what the data looks like
-- -----------------------------------------------------------
-- Preview employees table
SELECT *
FROM employees
LIMIT 3;
-- Preview movies table
SELECT *
FROM movies
LIMIT 3;
-- Preview airbnb_listings table
SELECT *
FROM airbnb_listings
LIMIT 3;
-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------
-- Exercise 1: List tables
-- .tables
-- Exercise 2: View movies schema
-- .schema movies
-- Exercise 3: PRAGMA table_info for orders
-- PRAGMA table_info(orders);
-- Exercise 4: Count airbnb_listings rows
SELECT COUNT(*) AS airbnb_count
FROM airbnb_listings;
-- Expected: 20
-- Exercise 5: Explore schemas
-- .schema airbnb_listings
-- .schema departments
-- .schema order_items
-- .schema products
-- 🔥 Mini Challenge:
-- 1. Which tables have a 'rating' column?
--    Check with: PRAGMA table_info(movies);
--    and:       PRAGMA table_info(airbnb_listings);
-- 2. How many columns in order_items?
-- PRAGMA table_info(order_items);
-- Expected: 5 columns (item_id, order_id, product_id, quantity, unit_price)
-- 3. Data type of price in airbnb_listings?
-- PRAGMA table_info(airbnb_listings);
-- Expected: REAL