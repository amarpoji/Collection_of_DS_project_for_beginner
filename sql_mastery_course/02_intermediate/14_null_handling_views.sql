-- ========================================================================
-- LESSON 14: NULL Handling & Views
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- PART 1: NULL Handling
-- ============================================================

-- 1A. NULL comparison — WRONG vs RIGHT
-- WRONG (this returns 0 rows):
-- SELECT * FROM employees WHERE manager_id = NULL;

-- RIGHT:
-- SELECT * FROM employees WHERE manager_id IS NULL;

-- NOTE: In this database, manager_id stores the STRING 'NULL',
-- not actual SQL NULL:
SELECT employee_id, first_name, last_name, manager_id,
       manager_id IS NULL AS is_sql_null,
       manager_id = 'NULL' AS is_string_null
FROM employees
WHERE manager_id = 'NULL';

-- Expected:
-- 1|John|Smith|NULL|0|1
-- 9|George|Harris|NULL|0|1
-- 12|Julia|Roberts|NULL|0|1
-- 15|Michael|Jordan|NULL|0|1

-- ============================================================
-- 2. IFNULL — Replace NULL with default
-- ============================================================

-- Products with no sales — IFNULL replaces NULL sum with 0
SELECT p.product_id, p.product_name,
       IFNULL(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
HAVING total_revenue = 0;

-- Expected:
-- 8|Ergonomic Chair|0.0
-- 9|Laptop Stand|0.0
-- 10|Desk Lamp|0.0
-- 13|Backpack|0.0
-- 15|LED Desk Strip|0.0
-- 16|Bluetooth Speaker|0.0
-- 17|Monitor Arm|0.0
-- 19|External SSD 1TB|0.0

-- ============================================================
-- 3. COALESCE — First non-NULL value
-- ============================================================

-- COALESCE with priority fallback
SELECT first_name || ' ' || last_name AS customer,
       COALESCE(email, phone, 'No Contact') AS contact
FROM customers
LIMIT 5;

-- Expected:
-- Sarah Johnson|sarah.j@email.com
-- Mike Chen|mike.chen@email.com
-- Emma Davis|emma.d@email.com
-- Alex Kumar|alex.k@email.com
-- Olivia Martinez|olivia.m@email.com

-- COALESCE with LEFT JOIN (count orders per customer)
SELECT c.first_name || ' ' || c.last_name AS customer,
       COALESCE(COUNT(o.order_id), 0) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY order_count DESC
LIMIT 5;

-- ============================================================
-- 4. NULLIF — Return NULL when values are equal
-- ============================================================

-- 4A. Convert string 'NULL' to actual SQL NULL
SELECT employee_id, first_name || ' ' || last_name AS employee,
       NULLIF(manager_id, 'NULL') AS manager_id_clean
FROM employees
WHERE manager_id = 'NULL';

-- Expected:
-- 1|John Smith|NULL
-- 9|George Harris|NULL
-- 12|Julia Roberts|NULL
-- 15|Michael Jordan|NULL

-- ============================================================
-- 5. NULL in WHERE, ORDER BY, GROUP BY
-- ============================================================

-- 5A. WHERE — Find non-manager employees
SELECT first_name || ' ' || last_name AS employee
FROM employees
WHERE manager_id != 'NULL'
  AND employee_id NOT IN (
      SELECT DISTINCT manager_id FROM employees
      WHERE manager_id != 'NULL'
  );

-- Expected: employees who don't manage anyone
-- Ian Clark, Hannah Martin, Laura Wilson, Fiona Apple,
-- Charlie Brown, Kevin Bacon, Edward Norton

-- 5B. ORDER BY — NULLs sort last
SELECT first_name, last_name, NULLIF(manager_id, 'NULL') AS mgr
FROM employees
ORDER BY mgr
LIMIT 5;

-- Expected (actual manager_ids first, sorted ascending):
-- Jane|Doe|1
-- Bob|Johnson|1
-- Diana|Prince|1
-- Alice|Williams|1
-- John|Smith|NULL

-- ============================================================
-- PART 2: Views
-- ============================================================

-- 6A. CREATE VIEW — Active customers
CREATE VIEW IF NOT EXISTS active_customers AS
SELECT customer_id, first_name, last_name, email, city, state,
       registration_date
FROM customers
WHERE is_active = 1;

-- Query the view
SELECT * FROM active_customers ORDER BY last_name LIMIT 5;

-- Expected:
-- 13|Mia|Anderson|mia.a@email.com|Atlanta|GA|2023-08-19
-- 2|Mike|Chen|mike.chen@email.com|San Francisco|CA|2023-02-20
-- 18|Henry|Clark|henry.c@email.com|St. Louis|MO|2023-01-10
-- 3|Emma|Davis|emma.d@email.com|Chicago|IL|2023-03-10
-- 14|Benjamin|Thomas|ben.t@email.com|Dallas|TX|2023-04-15

-- 6B. CREATE VIEW — Order summary
CREATE VIEW IF NOT EXISTS order_summary AS
SELECT o.order_id, o.order_date, o.status,
       o.total_amount, o.payment_method,
       c.first_name || ' ' || c.last_name AS customer,
       c.city, c.state
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Query: top 5 delivered orders
SELECT order_id, customer, total_amount
FROM order_summary
WHERE status = 'Delivered'
ORDER BY total_amount DESC
LIMIT 5;

-- Expected:
-- 1039|Harper Lewis|520.0
-- 1016|Benjamin Thomas|500.0
-- 1036|Emma Davis|430.0
-- 1009|Liam Garcia|420.0
-- 1050|Benjamin Thomas|410.0

-- 6C. CREATE VIEW — Department budgets
CREATE VIEW IF NOT EXISTS department_budgets AS
SELECT d.department_id, d.department_name, d.location,
       d.budget,
       COUNT(e.employee_id) AS employee_count,
       ROUND(SUM(e.salary), 2) AS total_salaries,
       ROUND(d.budget - SUM(e.salary), 2) AS remaining_budget
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id;

-- Query the view
SELECT department_name, budget, total_salaries, remaining_budget
FROM department_budgets
ORDER BY remaining_budget DESC;

-- Expected:
-- Product|800000.0|185000.0|615000.0
-- Sales|750000.0|200000.0|550000.0
-- Marketing|600000.0|145000.0|455000.0
-- Human Resources|300000.0|78000.0|222000.0
-- Data & Analytics|500000.0|340000.0|160000.0
-- Engineering|1200000.0|452000.0|748000.0

-- ============================================================
-- 7. DROP VIEW
-- ============================================================

-- DROP VIEW IF EXISTS active_customers;
-- DROP VIEW IF EXISTS order_summary;
-- DROP VIEW IF EXISTS department_budgets;

-- ============================================================
-- Exercises (uncomment to run)
-- ============================================================

-- 1. Create product_sales view
-- CREATE VIEW IF NOT EXISTS product_sales AS
-- SELECT p.product_id, p.product_name, p.category,
--        IFNULL(SUM(oi.quantity), 0) AS total_quantity_sold,
--        IFNULL(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_revenue
-- FROM products p
-- LEFT JOIN order_items oi ON p.product_id = oi.product_id
-- GROUP BY p.product_id;
--
-- SELECT * FROM product_sales ORDER BY total_revenue DESC LIMIT 5;

-- 2. COALESCE with bonus eligibility
-- SELECT first_name || ' ' || last_name AS employee,
--        salary,
--        NULLIF(manager_id, 'NULL') AS clean_manager_id,
--        CASE WHEN salary < 80000 THEN 'Yes' ELSE 'No' END AS bonus_eligible
-- FROM employees
-- ORDER BY salary;

-- 3. Create high_value_orders view
-- CREATE VIEW IF NOT EXISTS high_value_orders AS
-- SELECT o.order_id, o.order_date, o.total_amount,
--        c.first_name || ' ' || c.last_name AS customer
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.customer_id
-- WHERE o.total_amount > 300;
--
-- SELECT * FROM high_value_orders ORDER BY total_amount DESC;

-- 4. IFNULL for product sales
-- SELECT p.product_name,
--        IFNULL(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_sales
-- FROM products p
-- LEFT JOIN order_items oi ON p.product_id = oi.product_id
-- GROUP BY p.product_id
-- ORDER BY total_sales;

-- 5. Create and drop short_movies view
-- CREATE VIEW IF NOT EXISTS short_movies AS
-- SELECT title, release_year, rating, duration_min
-- FROM movies
-- WHERE duration_min < 100;
--
-- SELECT * FROM short_movies;
-- DROP VIEW IF EXISTS short_movies;

-- ============================================================
-- 🔥 Mini Challenges (uncomment to run)
-- ============================================================

-- 1. Simulate NULLs with LEFT JOIN on airbnb_listings
-- SELECT n.neighbourhood,
--        COALESCE(l.property_name, 'No listings') AS property,
--        COALESCE(CAST(l.price AS TEXT), 'N/A') AS price
-- FROM (SELECT DISTINCT neighbourhood FROM airbnb_listings) n
-- LEFT JOIN airbnb_listings l ON n.neighbourhood = l.neighbourhood
-- ORDER BY n.neighbourhood;

-- 2. Monthly KPI view
-- CREATE VIEW IF NOT EXISTS monthly_kpi AS
-- SELECT strftime('%Y-%m', order_date) AS month,
--        COUNT(*) AS total_orders,
--        ROUND(SUM(CASE WHEN status != 'Cancelled' THEN total_amount ELSE 0 END), 2) AS revenue,
--        COUNT(DISTINCT customer_id) AS distinct_customers,
--        ROUND(AVG(CASE WHEN status != 'Cancelled' THEN total_amount END), 2) AS avg_order_value
-- FROM orders
-- GROUP BY month
-- ORDER BY month;
--
-- SELECT * FROM monthly_kpi;
-- DROP VIEW IF EXISTS monthly_kpi;
