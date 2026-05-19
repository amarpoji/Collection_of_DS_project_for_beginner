-- ============================================================
-- Lesson 08: Beginner Review
-- Comprehensive review of all beginner SQL concepts
-- ============================================================

-- -----------------------------------------------------------
-- Real-World Business Questions
-- -----------------------------------------------------------

-- 1. Which departments have the most employees?
SELECT d.department_name, COUNT(*) AS headcount
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY headcount DESC;
-- Expected: Data & Analytics (4), Engineering (4), Product (2), etc.

-- 2. Average order value by payment method
SELECT payment_method,
       COUNT(*) AS order_count,
       ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
GROUP BY payment_method
ORDER BY avg_order_value DESC;

-- 3. Movies with best ROI (return on investment)
SELECT title, genre, release_year,
       revenue_millions - budget_millions AS profit_millions,
       ROUND((revenue_millions - budget_millions) / budget_millions, 2) AS roi
FROM movies
WHERE budget_millions > 0
ORDER BY roi DESC
LIMIT 10;

-- 4. Customer count by state
SELECT state, COUNT(*) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

-- 5. Top-selling product category (by revenue from order_items)
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 6. Employees earning above company average
SELECT first_name, last_name, job_title, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;
-- Expected: George (200000), Michael (130000), Bob (110000), Alice (105000), Edward (100000)

-- 7. Cities with more than 1 customer
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY customer_count DESC;

-- 8. Order status breakdown
SELECT status,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_value
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- 9. Airbnb room type breakdown
SELECT room_type,
       COUNT(*) AS listing_count,
       ROUND(AVG(price), 2) AS avg_price,
       ROUND(AVG(rating), 2) AS avg_rating
FROM airbnb_listings
GROUP BY room_type;

-- 10. High earners in Engineering or Sales
SELECT e.first_name, e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name IN ('Engineering', 'Sales')
  AND e.salary > 90000
ORDER BY e.salary DESC;

-- -----------------------------------------------------------
-- Review Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Employees in Data & Analytics department
SELECT e.first_name, e.last_name, e.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Data & Analytics';

-- Exercise 2: Movies after 2010 with rating >= 8.0
SELECT title, release_year, rating
FROM movies
WHERE release_year > 2010 AND rating >= 8.0
ORDER BY rating DESC;

-- Exercise 3: Order summary statistics
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(total_amount), 2) AS avg_order_amount,
    MAX(total_amount) AS highest_order_amount
FROM orders;

-- Exercise 4: Customers with 3+ orders
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY order_count DESC;

-- Exercise 5: Categories with avg price > $30 and >= 4 products
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_price,
       COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING AVG(unit_price) > 30 AND COUNT(*) >= 4;

-- Exercise 6: 6th through 10th highest paid employees
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;

-- Exercise 7: Distinct cities in California
SELECT DISTINCT city
FROM customers
WHERE state = 'CA'
ORDER BY city;

-- Exercise 8: Complex order filtering
SELECT order_id, customer_id, status, total_amount
FROM orders
WHERE (status = 'Delivered' AND total_amount > 200)
   OR (status = 'Shipped' AND total_amount > 150)
ORDER BY total_amount DESC;

-- Exercise 9: Job title stats
SELECT
    job_title,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM employees
GROUP BY job_title
ORDER BY avg_salary DESC;

-- Exercise 10: Top 5 genres by avg revenue
SELECT genre,
       COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS avg_rating,
       ROUND(AVG(revenue_millions), 2) AS avg_revenue
FROM movies
GROUP BY genre
HAVING COUNT(*) >= 3 AND AVG(rating) >= 7.5
ORDER BY avg_revenue DESC
LIMIT 5;

-- -----------------------------------------------------------
-- 🔥 The Ultimate Beginner Challenge
-- -----------------------------------------------------------

-- Department performance report
SELECT
    d.department_name,
    COUNT(*) AS employee_count,
    ROUND(AVG(e.salary), 0) AS avg_salary,
    SUM(e.salary) AS total_payroll,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) >= 2
ORDER BY avg_salary DESC;

-- Expected output (approximate):
-- department_name     employee_count  avg_salary  total_payroll  min_salary  max_salary
-- -----------------  --------------  ----------  -------------  ----------  ----------
-- Engineering                     4       110500        442000       65000      200000
-- Sales                           2       100000        200000       70000      130000
-- Product                         2        92500        185000       80000      105000
-- Data & Analytics                4        85000        340000       55000      110000
-- Marketing                       2        72500        145000       60000       85000
