-- ============================================================
-- Lesson 06: GROUP BY
-- Grouping rows and calculating aggregates per group
-- ============================================================

-- -----------------------------------------------------------
-- GROUP BY with one column
-- -----------------------------------------------------------

-- Average salary by department_id
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id;
-- Expected: 1=85000, 2=110500, 3=92500, 4=72500, 5=78000, 6=100000

-- Average salary by department name (with JOIN)
SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;
-- Expected: Data & Analytics=85000, Engineering=110500, Product=92500,
--           Marketing=72500, Human Resources=78000, Sales=100000

-- Revenue by order status
SELECT status, ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- Count movies by genre
SELECT genre, COUNT(*) AS movie_count
FROM movies
GROUP BY genre
ORDER BY movie_count DESC;
-- Expected: Sci-Fi (8), Animation (7), Drama (6), Action (6), Crime (5)...

-- -----------------------------------------------------------
-- GROUP BY with multiple columns
-- -----------------------------------------------------------

-- Count products by category
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;
-- Expected: Accessories (7), Electronics (7), Furniture (6)

-- Average rating by genre
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movies
GROUP BY genre
ORDER BY avg_rating DESC;

-- Orders by shipping state
SELECT shipping_state, COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_value
FROM orders
GROUP BY shipping_state
ORDER BY total_value DESC;

-- Average price by Airbnb room type
SELECT room_type,
       COUNT(*) AS listing_count,
       ROUND(AVG(price), 2) AS avg_price
FROM airbnb_listings
GROUP BY room_type;
-- Expected: Entire home/apt (16, ~210.94), Private room (4, ~76.25)

-- -----------------------------------------------------------
-- GROUP BY + WHERE + ORDER BY combined
-- -----------------------------------------------------------

-- Department stats with location (JOIN + GROUP BY)
SELECT d.location, d.department_name,
       ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.location, d.department_name
ORDER BY avg_salary DESC;

-- Count active customers by state
SELECT state, COUNT(*) AS active_customers
FROM customers
WHERE is_active = 1
GROUP BY state
ORDER BY active_customers DESC;

-- -----------------------------------------------------------
-- Complete business examples
-- -----------------------------------------------------------

-- HR report: employee stats per department
SELECT
    d.department_name,
    COUNT(*) AS headcount,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    SUM(e.salary) AS total_payroll
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_payroll DESC;

-- Movie stats by genre
SELECT
    genre,
    COUNT(*) AS total_movies,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(revenue_millions), 2) AS avg_revenue_millions,
    ROUND(AVG(budget_millions), 2) AS avg_budget_millions
FROM movies
GROUP BY genre
ORDER BY avg_revenue_millions DESC;

-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Employee count by department
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
ORDER BY employee_count DESC;

-- Exercise 2: Total spent by each customer (from orders)
SELECT customer_id, ROUND(SUM(total_amount), 2) AS total_spent
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- Exercise 3: Average product price by category
SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category;

-- Exercise 4: Movies per release year (only years with >1 movie)
SELECT release_year, COUNT(*) AS movie_count
FROM movies
GROUP BY release_year
HAVING movie_count > 1
ORDER BY release_year;

-- Exercise 5: Max salary by department
SELECT department_id, MAX(salary) AS max_salary
FROM employees
GROUP BY department_id;

-- 🔥 Mini Challenge Solutions

-- 1. Avg rating by genre (only genres with >= 3 movies)
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movies
GROUP BY genre
HAVING COUNT(*) >= 3
ORDER BY avg_rating DESC;

-- 2. Airbnb listings per neighbourhood
SELECT neighbourhood, COUNT(*) AS listing_count
FROM airbnb_listings
GROUP BY neighbourhood
ORDER BY listing_count DESC;

-- 3. Total sales by payment method
SELECT payment_method,
       ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 4. Job titles that appear more than once
SELECT job_title,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY job_title
HAVING COUNT(*) > 1;
-- Note: In our data, no job title appears more than once,
-- so this may return 0 rows. That's a valid learning outcome!
