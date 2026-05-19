-- ============================================================
-- Lesson 05: Aggregate Functions
-- COUNT, SUM, AVG, MIN, MAX, ROUND
-- ============================================================

-- -----------------------------------------------------------
-- COUNT() - Count rows
-- -----------------------------------------------------------

-- Count all employees
SELECT COUNT(*) AS total_employees
FROM employees;
-- Expected: 15

-- Count total orders
SELECT COUNT(*) AS total_orders
FROM orders;
-- Expected: 50

-- Count distinct states
SELECT COUNT(DISTINCT state) AS unique_states
FROM customers;
-- Expected: 15

-- -----------------------------------------------------------
-- SUM() - Add up values
-- -----------------------------------------------------------

-- Total payroll
SELECT SUM(salary) AS total_payroll
FROM employees;
-- Expected: 1400000.0

-- Total revenue from delivered orders
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered';

-- Total stock in warehouse
SELECT SUM(stock_quantity) AS total_items_in_stock
FROM products;

-- -----------------------------------------------------------
-- AVG() - Calculate average
-- -----------------------------------------------------------

-- Average salary
SELECT AVG(salary) AS average_salary
FROM employees;
-- Expected: 93333.33...

-- Average movie rating
SELECT AVG(rating) AS average_rating
FROM movies;
-- Expected: 8.29...

-- -----------------------------------------------------------
-- MIN() and MAX() - Find extremes
-- -----------------------------------------------------------

-- Lowest and highest salary
SELECT MIN(salary) AS lowest_salary,
       MAX(salary) AS highest_salary
FROM employees;
-- Expected: 55000.0, 200000.0

-- Cheapest and most expensive product
SELECT MIN(unit_price) AS cheapest_product,
       MAX(unit_price) AS most_expensive_product
FROM products;
-- Expected: 9.99, 599.0

-- Oldest and newest movie
SELECT MIN(release_year) AS oldest_movie,
       MAX(release_year) AS newest_movie
FROM movies;
-- Expected: 1972, 2022

-- -----------------------------------------------------------
-- ROUND() - Format numbers
-- -----------------------------------------------------------

-- Average salary with 2 decimal places
SELECT ROUND(AVG(salary), 2) AS avg_salary_formatted
FROM employees;
-- Expected: 93333.33

-- Average rating with 1 decimal
SELECT ROUND(AVG(rating), 1) AS avg_rating
FROM movies;

-- -----------------------------------------------------------
-- Real-world business examples
-- -----------------------------------------------------------

-- Employee dashboard
SELECT
    COUNT(*) AS total_employees,
    ROUND(AVG(salary), 0) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_payroll
FROM employees;
-- Expected: 15, 93333, 55000, 200000, 1400000.0

-- Order summary
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    MIN(total_amount) AS smallest_order,
    MAX(total_amount) AS largest_order,
    SUM(total_amount) AS total_revenue
FROM orders;

-- Movie collection overview
SELECT
    COUNT(*) AS total_movies,
    ROUND(AVG(rating), 2) AS avg_rating,
    MIN(rating) AS lowest_rating,
    MAX(rating) AS highest_rating,
    ROUND(AVG(duration_min), 0) AS avg_duration_min
FROM movies;

-- Airbnb overview
SELECT
    COUNT(*) AS total_listings,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(price) AS cheapest_price,
    MAX(price) AS most_expensive,
    ROUND(AVG(rating), 2) AS avg_rating
FROM airbnb_listings;

-- Product inventory summary
SELECT
    COUNT(*) AS total_products,
    ROUND(AVG(unit_price), 2) AS avg_price,
    MIN(unit_price) AS min_price,
    MAX(unit_price) AS max_price,
    SUM(stock_quantity) AS total_stock
FROM products;

-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Count movies and unique genres
SELECT COUNT(*) AS total_movies,
       COUNT(DISTINCT genre) AS unique_genres
FROM movies;

-- Exercise 2: Total revenue from delivered orders
SELECT SUM(total_amount) AS delivered_revenue
FROM orders
WHERE status = 'Delivered';

-- Exercise 3: Average Airbnb price rounded to 2 decimals
SELECT ROUND(AVG(price), 2) AS avg_airbnb_price
FROM airbnb_listings;

-- Exercise 4: Customer age stats
SELECT MIN(age) AS youngest,
       MAX(age) AS oldest,
       ROUND(AVG(age), 1) AS avg_age
FROM customers;

-- Exercise 5: Total stock across all products
SELECT SUM(stock_quantity) AS total_stock
FROM products;

-- 🔥 Mini Challenge Solutions

-- 1. Average movie budget, revenue, and profit
SELECT
    ROUND(AVG(budget_millions), 2) AS avg_budget_millions,
    ROUND(AVG(revenue_millions), 2) AS avg_revenue_millions,
    ROUND(AVG(revenue_millions - budget_millions), 2) AS avg_profit_millions
FROM movies;

-- 2. Highest and lowest rated Airbnb prices
SELECT
    MAX(CASE WHEN rating = (SELECT MAX(rating) FROM airbnb_listings) THEN price END) AS highest_rated_price,
    MIN(CASE WHEN rating = (SELECT MIN(rating) FROM airbnb_listings) THEN price END) AS lowest_rated_price
FROM airbnb_listings;
-- Or simpler:
SELECT
    MAX(price) AS max_price_any,
    MIN(price) AS min_price_any
FROM airbnb_listings;

-- 3. Count employees above vs at/below $80,000
SELECT 'Above $80,000' AS salary_range, COUNT(*) AS employee_count
FROM employees
WHERE salary > 80000
UNION ALL
SELECT '$80,000 or below', COUNT(*)
FROM employees
WHERE salary <= 80000;
