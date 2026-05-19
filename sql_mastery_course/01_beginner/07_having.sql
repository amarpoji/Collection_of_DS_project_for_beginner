-- ============================================================
-- Lesson 07: HAVING
-- Filtering groups after aggregation
-- ============================================================

-- -----------------------------------------------------------
-- HAVING with aggregate functions
-- -----------------------------------------------------------

-- Departments where avg salary > 90000
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 90000;
-- Expected: department 2 (Engineering, 110500), department 6 (Sales, 100000)

-- Same with department names (JOIN)
SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 90000;
-- Expected: Engineering (110500), Sales (100000)

-- Genres with avg rating >= 8.5
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movies
GROUP BY genre
HAVING AVG(rating) >= 8.5;
-- Expected: Crime (8.74, 5 movies), Drama (8.55, 6 movies)

-- Movies by decade with avg rating > 8.3
SELECT
    (release_year / 10) * 10 AS decade,
    COUNT(*) AS movie_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM movies
GROUP BY decade
HAVING AVG(rating) > 8.3
ORDER BY decade;

-- -----------------------------------------------------------
-- WHERE + GROUP BY + HAVING + ORDER BY combined
-- -----------------------------------------------------------

-- Departments where avg salary > 75000 (only employees earning > 60000)
SELECT
    d.department_name,
    COUNT(*) AS senior_staff,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 60000
GROUP BY d.department_name
HAVING AVG(e.salary) > 75000
ORDER BY avg_salary DESC;

-- Product categories with total stock > 200
SELECT category,
       SUM(stock_quantity) AS total_stock,
       COUNT(*) AS product_count,
       ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING SUM(stock_quantity) > 200
ORDER BY total_stock DESC;
-- Expected: Accessories (1870), Electronics (755), Furniture (405)

-- High-value customers (total spent > $500)
SELECT customer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 500
ORDER BY total_spent DESC;

-- Profitable movie genres (avg revenue > avg budget)
SELECT genre,
       COUNT(*) AS total_movies,
       ROUND(AVG(revenue_millions), 2) AS avg_revenue,
       ROUND(AVG(budget_millions), 2) AS avg_budget,
       ROUND(AVG(revenue_millions - budget_millions), 2) AS avg_profit
FROM movies
GROUP BY genre
HAVING AVG(revenue_millions) > AVG(budget_millions)
ORDER BY avg_profit DESC;

-- -----------------------------------------------------------
-- Common Mistake: HAVING for row-level filtering
-- -----------------------------------------------------------

-- WRONG way (works but bad practice)
SELECT first_name, last_name, salary
FROM employees
HAVING salary > 80000;

-- RIGHT way (use WHERE for row filtering)
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 80000;

-- -----------------------------------------------------------
-- Exercise Solutions
-- -----------------------------------------------------------

-- Exercise 1: Genres with more than 5 movies
SELECT genre, COUNT(*) AS movie_count
FROM movies
GROUP BY genre
HAVING COUNT(*) > 5;
-- Expected: Sci-Fi (8), Animation (7), Drama (6), Action (6)

-- Exercise 2: Departments with total payroll > $300,000
SELECT department_id, SUM(salary) AS total_payroll
FROM employees
GROUP BY department_id
HAVING SUM(salary) > 300000;

-- Exercise 3: Neighbourhoods with avg Airbnb price > $150
SELECT neighbourhood,
       ROUND(AVG(price), 2) AS avg_price,
       COUNT(*) AS listing_count
FROM airbnb_listings
GROUP BY neighbourhood
HAVING AVG(price) > 150
ORDER BY avg_price DESC;
-- Expected: Manhattan listings likely above $150

-- Exercise 4: Categories where avg product price < $50
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) < 50;
-- Expected: Accessories (avg ~23.92)

-- Exercise 5: Customers with at least 3 orders
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 3;

-- 🔥 Mini Challenge Solutions

-- 1. Genres with avg rating > 8.0 AND at least 5 movies
SELECT genre,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS movie_count
FROM movies
GROUP BY genre
HAVING AVG(rating) > 8.0 AND COUNT(*) >= 5
ORDER BY avg_rating DESC;

-- 2. Departments with avg salary between $80k and $100k
SELECT d.department_name,
       ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) BETWEEN 80000 AND 100000;

-- 3. Categories with total stock < 500 AND at least 5 products
SELECT category,
       SUM(stock_quantity) AS total_stock,
       COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING SUM(stock_quantity) < 500 AND COUNT(*) >= 5;
-- Expected: None (Accessories has 1870 stock, Electronics 755, Furniture 405 with 6 products)
-- So Furniture might match if stock < 500 and count >= 6... let's see.
-- Furniture: stock = 30+25+180+100+70+... wait, Furniture has: 599(30), 450(25), 39.99(180), 55(100), 89(70) = 405
-- 405 < 500 and count = 5... let me check. Products 7-10 and 17 are Furniture.
-- products: 7=Standing Desk, 8=Ergonomic Chair, 9=Laptop Stand, 10=Desk Lamp, 17=Monitor Arm = 5 products
-- total_stock = 30+25+180+100+70 = 405 < 500. So Furniture should appear.

-- 4. Managers who supervise at least 2 employees
-- Note: manager_id is stored as text in this DB
SELECT manager_id, COUNT(*) AS supervisee_count
FROM employees
WHERE manager_id != 'NULL'
GROUP BY manager_id
HAVING COUNT(*) >= 2;
