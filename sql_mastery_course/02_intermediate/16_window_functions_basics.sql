-- ========================================================================
-- LESSON 16: Window Functions Basics
-- Target: sqlite3 /mnt/c/Users/USER/.../sql_mastery.db
-- ========================================================================

-- ============================================================
-- 1. OVER() and PARTITION BY
-- ============================================================

-- Show each employee's salary alongside their department average
SELECT e.first_name || ' ' || e.last_name AS employee,
       d.department_name,
       e.salary,
       ROUND(AVG(e.salary) OVER (PARTITION BY e.department_id), 2) AS dept_avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.salary DESC;

-- Expected:
-- Bob Johnson|Data & Analytics|110000.0|85000.0
-- Edward Norton|Data & Analytics|100000.0|85000.0
-- John Smith|Data & Analytics|75000.0|85000.0
-- Ian Clark|Data & Analytics|55000.0|85000.0
-- George Harris|Engineering|200000.0|113000.0
-- Jane Doe|Engineering|95000.0|113000.0
-- Kevin Bacon|Engineering|92000.0|113000.0
-- Charlie Brown|Engineering|65000.0|113000.0
-- Julia Roberts|Human Resources|78000.0|78000.0
-- Diana Prince|Marketing|85000.0|72500.0
-- Hannah Martin|Marketing|60000.0|72500.0
-- Alice Williams|Product|105000.0|92500.0
-- Fiona Apple|Product|80000.0|92500.0
-- Michael Jordan|Sales|130000.0|100000.0
-- Laura Wilson|Sales|70000.0|100000.0

-- ============================================================
-- 2. ROW_NUMBER(), RANK(), DENSE_RANK()
-- ============================================================

-- 2A. Compare all three ranking functions
SELECT d.department_name,
       e.first_name || ' ' || e.last_name AS employee,
       e.salary,
       ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS row_num,
       RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rank,
       DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS dense_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.salary DESC;

-- 2B. Top 3 movies per genre
WITH ranked_movies AS (
    SELECT title, genre, rating,
           ROW_NUMBER() OVER (PARTITION BY genre ORDER BY rating DESC) AS rn
    FROM movies
)
SELECT genre, title, rating
FROM ranked_movies
WHERE rn <= 3
ORDER BY genre, rn;

-- ============================================================
-- 3. LAG() and LEAD() — Compare Across Rows
-- ============================================================

-- 3A. Compare each order to customer's previous order
SELECT customer_id, order_id, order_date, total_amount,
       LAG(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ) AS previous_order_amount,
       ROUND(total_amount - LAG(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS difference
FROM orders
WHERE status != 'Cancelled'
  AND customer_id IN (1, 3, 5)
ORDER BY customer_id, order_date;

-- Expected:
-- 1|1001|2024-01-05|125.99|NULL|NULL
-- 1|1007|2024-01-20|199.99|125.99|74.0
-- 1|1026|2024-03-10|89.99|199.99|-110.0
-- 1|1047|2024-05-03|275.5|89.99|185.51
-- 3|1003|2024-01-10|249.99|NULL|NULL
-- 3|1018|2024-02-18|215.0|249.99|-34.99
-- 3|1036|2024-04-05|430.0|215.0|215.0
-- 5|1005|2024-01-15|310.25|NULL|NULL
-- 5|1024|2024-03-05|320.0|310.25|9.75
-- 5|1037|2024-04-08|99.5|320.0|-220.5

-- 3B. LEAD — Next order's value
SELECT customer_id, order_id, order_date, total_amount,
       LEAD(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ) AS next_order_amount
FROM orders
WHERE customer_id = 1
ORDER BY order_date;

-- Expected:
-- 1|1001|2024-01-05|125.99|199.99
-- 1|1007|2024-01-20|199.99|89.99
-- 1|1026|2024-03-10|89.99|275.5
-- 1|1047|2024-05-03|275.5|NULL

-- ============================================================
-- 4. SUM() OVER() — Running Totals
-- ============================================================

-- 4A. Running monthly revenue
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', order_date) AS month,
           ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY month
)
SELECT month, revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS running_total
FROM monthly_revenue
ORDER BY month;

-- Expected:
-- 2024-01|1515.98|1515.98
-- 2024-02|2230.73|3746.71
-- 2024-03|1975.74|5722.45
-- 2024-04|2442.23|8164.68
-- 2024-05|1112.5|9277.18

-- 4B. Running total per customer
SELECT customer_id, order_date, total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY customer_id ORDER BY order_date
       ), 2) AS customer_running_total
FROM orders
WHERE customer_id IN (1, 2) AND status != 'Cancelled'
ORDER BY customer_id, order_date;

-- Expected:
-- 1|2024-01-05|125.99|125.99
-- 1|2024-01-20|199.99|325.98
-- 1|2024-03-10|89.99|415.97
-- 1|2024-05-03|275.5|691.47
-- 2|2024-01-07|89.5|89.5
-- 2|2024-02-01|150.0|239.5

-- ============================================================
-- 5. Real Business Examples
-- ============================================================

-- 5A. Employee salary rank within department
SELECT d.department_name,
       e.first_name || ' ' || e.last_name AS employee,
       e.salary,
       RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, salary_rank;

-- 5B. Month-over-month revenue change
WITH monthly_revenue AS (
    SELECT strftime('%Y-%m', order_date) AS month,
           ROUND(SUM(total_amount), 2) AS revenue
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY month
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) /
              LAG(revenue) OVER (ORDER BY month) * 100, 2) AS change_pct
FROM monthly_revenue
ORDER BY month;

-- Expected:
-- 2024-01|1515.98|NULL|NULL
-- 2024-02|2230.73|1515.98|47.15
-- 2024-03|1975.74|2230.73|-11.43
-- 2024-04|2442.23|1975.74|23.62
-- 2024-05|1112.5|2442.23|-54.44

-- 5C. Running total by shipping state
SELECT shipping_state, order_date, total_amount,
       ROUND(SUM(total_amount) OVER (
           PARTITION BY shipping_state ORDER BY order_date
       ), 2) AS state_running_total
FROM orders
WHERE status != 'Cancelled' AND shipping_state IN ('CA', 'NY')
ORDER BY shipping_state, order_date
LIMIT 8;

-- Expected:
-- CA|2024-01-07|89.5|89.5
-- CA|2024-01-15|310.25|399.75
-- CA|2024-02-01|150.0|549.75
-- CA|2024-03-22|55.5|605.25
-- CA|2024-04-01|210.0|815.25
-- CA|2024-04-08|99.5|914.75
-- NY|2024-01-05|125.99|125.99
-- NY|2024-01-20|199.99|325.98

-- ============================================================
-- Exercises (uncomment to run)
-- ============================================================

-- 1. Rank products by price within category
-- SELECT category, product_name, unit_price,
--        ROW_NUMBER() OVER (
--            PARTITION BY category ORDER BY unit_price DESC
--        ) AS price_rank
-- FROM products
-- ORDER BY category, price_rank;

-- 2. Employee salary vs previous hire in same department
-- SELECT d.department_name,
--        e.first_name || ' ' || e.last_name AS employee,
--        e.hire_date, e.salary,
--        LAG(e.salary) OVER (
--            PARTITION BY e.department_id ORDER BY e.hire_date
--        ) AS prev_salary
-- FROM employees e
-- JOIN departments d ON e.department_id = d.department_id
-- ORDER BY d.department_name, e.hire_date;

-- 3. Running total of movie revenue by studio
-- SELECT studio, title, release_year, revenue_millions,
--        ROUND(SUM(revenue_millions) OVER (
--            PARTITION BY studio ORDER BY release_year
--        ), 2) AS studio_running_revenue
-- FROM movies
-- ORDER BY studio, release_year;

-- 4. Airbnb price ranking by neighbourhood
-- SELECT neighbourhood, property_name, price,
--        RANK() OVER (
--            PARTITION BY neighbourhood ORDER BY price
--        ) AS price_rank
-- FROM airbnb_listings
-- ORDER BY neighbourhood, price_rank;

-- 5. Order comparison for customer 1
-- SELECT order_id, order_date, total_amount,
--        LAG(total_amount) OVER (ORDER BY order_date) AS prev_amount,
--        ROUND(total_amount - LAG(total_amount) OVER (ORDER BY order_date), 2) AS difference
-- FROM orders
-- WHERE customer_id = 1 AND status != 'Cancelled'
-- ORDER BY order_date;

-- ============================================================
-- 🔥 Mini Challenges (uncomment to run)
-- ============================================================

-- 1. Top 2 per category with DENSE_RANK (handles ties)
-- WITH product_sales AS (
--     SELECT p.category, p.product_name,
--            ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
--     FROM products p
--     JOIN order_items oi ON p.product_id = oi.product_id
--     GROUP BY p.product_id
-- ),
-- ranked_products AS (
--     SELECT category, product_name, revenue,
--            DENSE_RANK() OVER (
--                PARTITION BY category ORDER BY revenue DESC
--            ) AS dr
--     FROM product_sales
-- )
-- SELECT category, product_name, revenue, dr
-- FROM ranked_products
-- WHERE dr <= 2
-- ORDER BY category, dr;

-- 2. 3-month moving average of revenue
-- WITH monthly_revenue AS (
--     SELECT strftime('%Y-%m', order_date) AS month,
--            ROUND(SUM(total_amount), 2) AS revenue
--     FROM orders
--     WHERE status != 'Cancelled'
--     GROUP BY month
-- )
-- SELECT month, revenue,
--        ROUND(AVG(revenue) OVER (
--            ORDER BY month
--            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
--        ), 2) AS moving_avg_3m
-- FROM monthly_revenue
-- ORDER BY month;
