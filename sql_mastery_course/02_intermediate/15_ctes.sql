-- ========================================================================
-- LESSON 15: CTEs — Common Table Expressions
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. Basic CTE
-- ============================================================

-- 1A. Top 5 products by revenue
WITH product_revenue AS (
    SELECT p.product_id,
           p.product_name,
           p.category,
           ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id
)
SELECT product_name, category, revenue
FROM product_revenue
ORDER BY revenue DESC
LIMIT 5;

-- Expected:
-- Standing Desk|Furniture|4803.75
-- Noise Canceling Headphones|Electronics|1270.74
-- 27-inch Monitor|Electronics|960.49
-- Cable Organizer|Accessories|469.53
-- Notebook Set|Accessories|450.0

-- ============================================================
-- 2. Multiple CTEs
-- ============================================================

-- Multi-step: product_sales → category_summary
WITH
    product_sales AS (
        SELECT p.product_id, p.product_name, p.category,
               SUM(oi.quantity) AS units_sold,
               ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
        FROM products p
        JOIN order_items oi ON p.product_id = oi.product_id
        GROUP BY p.product_id
    ),
    category_summary AS (
        SELECT category,
               COUNT(*) AS product_count,
               ROUND(SUM(revenue), 2) AS category_revenue,
               ROUND(AVG(revenue), 2) AS avg_product_revenue
        FROM product_sales
        GROUP BY category
    )
SELECT category, product_count, category_revenue, avg_product_revenue
FROM category_summary
ORDER BY category_revenue DESC;

-- Expected:
-- Furniture|1|4803.75|4803.75
-- Electronics|6|3356.55|559.43
-- Accessories|5|1318.31|263.66

-- ============================================================
-- 3. CTE vs Subquery — Same Query, Two Ways
-- ============================================================

-- 3A. With subquery (harder to read):
SELECT department, employee, salary
FROM (
    SELECT d.department_name AS department,
           e.first_name || ' ' || e.last_name AS employee,
           e.salary,
           ROW_NUMBER() OVER (
               PARTITION BY e.department_id ORDER BY e.salary DESC
           ) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
)
WHERE rn <= 2
ORDER BY department, rn;

-- 3B. With CTE (cleaner):
WITH ranked_employees AS (
    SELECT d.department_name AS department,
           e.first_name || ' ' || e.last_name AS employee,
           e.salary,
           ROW_NUMBER() OVER (
               PARTITION BY e.department_id ORDER BY e.salary DESC
           ) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
)
SELECT department, employee, salary
FROM ranked_employees
WHERE rn <= 2
ORDER BY department, rn;

-- Expected (same for both):
-- Data & Analytics|Bob Johnson|110000.0
-- Data & Analytics|Edward Norton|100000.0
-- Engineering|George Harris|200000.0
-- Engineering|Jane Doe|95000.0
-- Human Resources|Julia Roberts|78000.0
-- Marketing|Diana Prince|85000.0
-- Marketing|Hannah Martin|60000.0
-- Product|Alice Williams|105000.0
-- Product|Fiona Apple|80000.0
-- Sales|Michael Jordan|130000.0
-- Sales|Laura Wilson|70000.0

-- ============================================================
-- 4. CTE for Running Calculations
-- ============================================================

-- Running total of orders per customer
WITH ordered_orders AS (
    SELECT customer_id, order_date, total_amount,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id ORDER BY order_date
           ) AS order_seq
    FROM orders
    WHERE status != 'Cancelled'
)
SELECT customer_id, order_seq, order_date, total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS running_total
FROM ordered_orders
WHERE customer_id IN (1, 2)
ORDER BY customer_id, order_seq;

-- Expected:
-- 1|1|2024-01-05|125.99|125.99
-- 1|2|2024-01-20|199.99|325.98
-- 1|3|2024-03-10|89.99|415.97
-- 1|4|2024-05-03|275.5|691.47
-- 2|1|2024-01-07|89.5|89.5
-- 2|2|2024-02-01|150.0|239.5

-- ============================================================
-- 5. Recursive CTEs
-- ============================================================

-- 5A. Generate a date series
WITH RECURSIVE dates(date) AS (
    SELECT DATE('2024-01-01')
    UNION ALL
    SELECT DATE(date, '+1 day')
    FROM dates
    WHERE date < '2024-01-10'
)
SELECT date FROM dates;

-- Expected:
-- 2024-01-01 through 2024-01-10 (10 rows)

-- 5B. Employee org chart (hierarchy)
WITH RECURSIVE org_chart AS (
    -- Anchor: top-level managers
    SELECT employee_id, first_name || ' ' || last_name AS employee,
           manager_id, 0 AS level
    FROM employees
    WHERE manager_id = 'NULL'
    
    UNION ALL
    
    -- Recursive: employees reporting to those above
    SELECT e.employee_id, e.first_name || ' ' || e.last_name,
           e.manager_id, oc.level + 1
    FROM employees e
    JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT employee, level
FROM org_chart
ORDER BY level, employee;

-- Expected:
-- George Harris|0
-- John Smith|0
-- Julia Roberts|0
-- Michael Jordan|0
-- Alice Williams|1
-- Bob Johnson|1
-- Diana Prince|1
-- Jane Doe|1
-- Laura Wilson|1
-- Charlie Brown|2
-- Edward Norton|2
-- Fiona Apple|2
-- Hannah Martin|2
-- Ian Clark|2
-- Kevin Bacon|2

-- ============================================================
-- Exercises (uncomment to run)
-- ============================================================

-- 1. Top 2 products per category by revenue
-- WITH product_ranked AS (
--     SELECT p.category, p.product_name,
--            ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
--            ROW_NUMBER() OVER (
--                PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.unit_price) DESC
--            ) AS rn
--     FROM products p
--     JOIN order_items oi ON p.product_id = oi.product_id
--     GROUP BY p.product_id
-- )
-- SELECT category, product_name, revenue, rn
-- FROM product_ranked
-- WHERE rn <= 2
-- ORDER BY category, rn;

-- 2. Customers with more than 3 orders
-- WITH order_counts AS (
--     SELECT customer_id, COUNT(*) AS order_count
--     FROM orders
--     GROUP BY customer_id
-- )
-- SELECT c.first_name || ' ' || c.last_name AS customer,
--        oc.order_count
-- FROM customers c
-- JOIN order_counts oc ON c.customer_id = oc.customer_id
-- WHERE oc.order_count > 3
-- ORDER BY oc.order_count DESC;

-- 3. Department salary stats using multiple CTEs
-- WITH dept_avg AS (
--     SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
--     FROM employees
--     GROUP BY department_id
-- ),
-- dept_stats AS (
--     SELECT department_id,
--            MIN(salary) AS min_salary,
--            MAX(salary) AS max_salary,
--            ROUND(AVG(salary), 2) AS avg_salary
--     FROM employees
--     GROUP BY department_id
-- )
-- SELECT d.department_name,
--        ds.min_salary, ds.max_salary, ds.avg_salary
-- FROM departments d
-- JOIN dept_stats ds ON d.department_id = ds.department_id
-- ORDER BY d.department_name;

-- 4. Employee salary vs department average
-- WITH dept_avg AS (
--     SELECT department_id, ROUND(AVG(salary), 2) AS dept_avg_salary
--     FROM employees
--     GROUP BY department_id
-- )
-- SELECT e.first_name || ' ' || e.last_name AS employee,
--        e.salary,
--        d.department_name,
--        da.dept_avg_salary,
--        ROUND(e.salary - da.dept_avg_salary, 2) AS diff_from_avg
-- FROM employees e
-- JOIN departments d ON e.department_id = d.department_id
-- JOIN dept_avg da ON e.department_id = da.department_id
-- ORDER BY diff_from_avg DESC;

-- 5. Running total revenue by day
-- WITH daily_revenue AS (
--     SELECT order_date,
--            ROUND(SUM(total_amount), 2) AS day_revenue
--     FROM orders
--     WHERE status != 'Cancelled'
--     GROUP BY order_date
-- )
-- SELECT order_date, day_revenue,
--        ROUND(SUM(day_revenue) OVER (ORDER BY order_date), 2) AS cumulative_revenue
-- FROM daily_revenue
-- ORDER BY order_date
-- LIMIT 15;

-- ============================================================
-- 🔥 Mini Challenges (uncomment to run)
-- ============================================================

-- 1. Complete date series with order gaps
-- WITH RECURSIVE dates(date) AS (
--     SELECT DATE('2024-01-01')
--     UNION ALL
--     SELECT DATE(date, '+1 day')
--     FROM dates
--     WHERE date < '2024-01-31'
-- )
-- SELECT d.date,
--        COUNT(o.order_id) AS orders,
--        CASE WHEN COUNT(o.order_id) = 0 THEN 'No orders' ELSE 'Has orders' END AS status
-- FROM dates d
-- LEFT JOIN orders o ON d.date = o.order_date
-- GROUP BY d.date
-- ORDER BY d.date;

-- 2. Multi-CTE pipeline: top 3 customers
-- WITH customer_orders AS (
--     SELECT c.customer_id,
--            c.first_name || ' ' || c.last_name AS customer_name,
--            o.order_id, o.total_amount
--     FROM customers c
--     JOIN orders o ON c.customer_id = o.customer_id
--     WHERE o.status != 'Cancelled'
-- ),
-- customer_totals AS (
--     SELECT customer_id, customer_name,
--            COUNT(order_id) AS order_count,
--            ROUND(SUM(total_amount), 2) AS total_spent
--     FROM customer_orders
--     GROUP BY customer_id
-- ),
-- top_customers AS (
--     SELECT customer_name, total_spent, order_count,
--            ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS rank
--     FROM customer_totals
-- )
-- SELECT rank, customer_name, total_spent, order_count
-- FROM top_customers
-- WHERE rank <= 3
-- ORDER BY rank;
